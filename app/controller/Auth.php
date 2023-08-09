<?php

namespace app\controller;

use Exception;
use think\facade\Db;
use think\facade\Request;
use think\facade\Session;
use think\facade\View;
use app\lib\Oauth;
use think\helper\Str;

class Auth extends Base
{

    public function login()
    {
        if (request()->islogin) {
            return $this->alert('success', '已登录', '/');
        }
        View::assign(['is_qq' => config_get('oauth_openqq'), 'is_wx' => config_get('oauth_openxw')]);
        return view();
    }

    /**
     * QQ 登录
     * @return \think\response\Json
     */
    public function oauth()
    {

        $type = input('post.type');
        if (!$type) {
            return msg('error', '登录方式不能为空');
        }
        if ($type != 'qq') {
            return msg('error', '当前登录方式不支持');
        }
        if (!config_get('oauth_appid') || !config_get('oauth_appkey')) {
            return msg('error', '未配置登录信息');
        }

        $qqOAuth = new \Yurun\OAuthLogin\QQ\OAuth2(config_get('oauth_appid'), config_get('oauth_appkey'), (string)url('/oauth/callback', [], '', true));
        $url = $qqOAuth->getAuthUrl();
        // 存储sdk自动生成的state，回调处理时候要验证
        session('oauth_state', $qqOAuth->state);
        // 储存返回页面
        session('oauth_rurl', !empty($_GET["rurl"]) ? $_GET["rurl"] : '');
        return msg('ok', 'success', $url);
    }

    public function callback()
    {
        if (empty(session('oauth_state'))) {
            return $this->alert('error', 'state校验失败，请重新登录', '/login');
        }

        $qqOAuth = new \Yurun\OAuthLogin\QQ\OAuth2(config_get('oauth_appid'), config_get('oauth_appkey'), (string)url('/oauth/callback', [], '', true));

        try {
            // 获取accessToken，把之前存储的state传入，会自动判断。获取失败会抛出异常！
            $accessToken = $qqOAuth->getAccessToken(session('oauth_state'));
            $userInfo = $qqOAuth->getUserInfo(); //第三方用户信息
            $openid = $qqOAuth->openid; // 唯一ID
        } catch (Exception $err) {
            return $this->alert('error', '登录数据获取失败' . ($err->getMessage()));
        }

        if ($openid && $userInfo) {
            $type = "qq";
            $userInfo['name'] = !empty($userInfo['nickname']) ? $userInfo['nickname'] : $type . Str::random(5);
            $user = Db::name('user')->where('type', $type)->where('openid', $openid)->find();

            if ($user) {
                $uid = $user['id'];
                $password = $user['password'];
                Db::name('user')->where('id', $uid)->update([
                    'avatar_url' => !empty($userInfo['figureurl_qq_2']) ? $userInfo['figureurl_qq_2'] : '',
                    'loginip' => $this->clientip,
                    'update_time' => date('Y-m-d H:i:s')
                ]);
            } else {
                $password = Str::random(16);
                $uid = Db::name('user')->insertGetId([
                    'type' => $type,
                    'openid' => $openid,
                    'username' => $userInfo['name'],
                    'password' => $password,
		    'stars' => '',
                    'avatar_url' => !empty($userInfo['figureurl_qq_2']) ? $userInfo['figureurl_qq_2'] : '',
                    'regip' => $this->clientip,
                    'create_time' => date('Y-m-d H:i:s'),
                    'update_time' => date('Y-m-d H:i:s')
                ]);
            }
            $session = md5($uid . $password);
            $expiretime = time() + 30744000;
            $token = authcode("{$uid}\t{$session}\t{$expiretime}", 'ENCODE', config_get('syskey'));
            cookie('user_token', $token, ['expire' => $expiretime, 'httponly' => true]);

            $rurl = !empty(session('oauth_rurl')) ? session('oauth_rurl') : '/';
            return redirect($rurl);
        } else {
            return $this->alert('error', '绑定失败，请重试');
        }
    }

    public function logout()
    {
        session(null);
        cookie('user_token', null);
        return redirect(request()->header('referer') ?? '/');
    }

    public function verifycode()
    {
        return captcha();
    }

    public function adminlogin()
    {
        $username = input('post.username', null, 'trim');
        $password = input('post.password', null, 'trim');
        $captcha = input('post.captcha', null, 'trim');

        if (empty($username) || empty($password)) {
            return msg('error', '用户名或密码不能为空');
        }
        if (!captcha_check($captcha)) {
            return msg('error', '验证码错误');
        }
        if ($username == config_get('admin_username') && password_verify($password, config_get('admin_password'))) {
            $session = md5($username . config_get('admin_password'));
            $expiretime = time() + 2562000;
            $token = authcode("{$username}\t{$session}\t{$expiretime}", 'ENCODE', config_get('syskey'));
            cookie('admin_token', $token, ['expire' => $expiretime, 'httponly' => true]);
            config_set('admin_lastlogin', date('Y-m-d H:i:s'));
            return msg();
        } else {
            return msg('error', '用户名或密码错误');
        }
    }

    public function adminlogout()
    {
        cookie('admin_token', null);
        return redirect('/admin/login.html');
    }

    public function qqlogin_api()
    {
        $do = input('get.do');
        $type = input('get.type');
        $info = $this->getQqloginInfo($type);
        if (!$info) {
            return json(['saveOK' => 1, 'msg' => '该登录类型不存在']);
        }

        $login = new \app\lib\QQLogin();
        if ($do == 'getqrpic') {
            $array = $login->getqrpic($info[0]);
        } elseif ($do == 'qrlogin') {
            $array = $login->qrlogin($info[0], $info[1], input('get.qrsig'));
            if ($array['saveOK'] == 0) {
                $cookie = ['uin' => $array['uin'], 'cookie' => $array['cookie'], 'nickname' => $array['nickname']];
                session('qq_cookie_' . $type, $cookie);
            }
        }

        return json($array);
    }

    public function qqlogin()
    {
        if (!checkRefererHost()) {
            return redirect('/');
        }

        $redirect = input('get.redirect');
        $type = input('get.type');
        if (!$redirect || !$type) {
            return $this->alert('error', '缺少参数', '/');
        }
        $info = $this->getQqloginInfo($type);
        if (!$info) {
            return $this->alert('error', '该登录类型不存在', '/');
        }
        if (substr($redirect, 0, 1) != '/') {
            return $this->alert('error', '回调地址错误', '/');
        }

        View::assign('logintype', base64_encode($type));
        View::assign('loginname', base64_encode($info[2]));
        View::assign('redirect', base64_encode($redirect));
        return view();
    }

    private function getQqloginInfo($type)
    {
        switch ($type) {
            case 'qzone':
                return ['5', 'https://qzs.qq.com/qzone/v5/loginsucc.html?para=izone', 'QQ空间'];
                break;
            case 'qun':
                return ['73', 'https://qun.qq.com/', 'QQ群管理'];
                break;
            case 'qqid':
                return ['1', 'https://id.qq.com/index.html', '我的QQ中心'];
                break;
            default:
                return null;
                break;
        }
    }

}
