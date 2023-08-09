<?php
declare (strict_types=1);

namespace app\middleware;

use think\facade\Db;

class AuthUser
{
    public function handle($request, \Closure $next)
    {
        $islogin = false;
        $cookie = cookie('user_token');
        $user = null;
        if($cookie){
            $token=authcode($cookie, 'DECODE', config_get('syskey'));
            list($uid, $sid, $expiretime) = explode("\t", $token);
            $user = session('user_'.$uid);
            if(!$user){
                $user = Db::name('user')->where('id', $uid)->find();
                session('user_'.$uid, $user);
            }
            if($user && $user['enable']==1){
                $session=md5($user['id'].$user['password']);
                if($session==$sid && $expiretime>time()) {
                    if(!$user['avatar_url']) $user['avatar_url'] = '/static/images/user.png';
                    $islogin = true;
                }
            }
        }
        $request->islogin = $islogin;
        $request->user = $user;
        /*if (!$islogin) {
            if ($request->isAjax() || !$request->isGet()) {
                return msg('error','请登录');
            }
            return redirect((string)url('/login'));
        }*/
        return $next($request);
    }
}
