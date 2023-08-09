<?php
/**
 * ICP备案查询
 */

namespace plugin\web\icp;

use app\Plugin;
use Exception;
use think\facade\Db;

class App extends Plugin
{

    const CACHE_TIME = 604800;
    const Query_url = 'http://127.0.0.1:9088/';

    public function index()
    {
        return $this->view();
    }

    public function query(){
        $domain = input('post.domain', null, 'trim');
        if(!$domain) return msg('error','no domain');
        if(strpos($domain,'.') && !checkdomain($domain)){
            return msg('error', '域名格式不正确！');
        }
        $captcha_result = verify_captcha4();
        if($captcha_result !== true){
            return msg('error', '验证失败，请重新验证');
        }

        $cache = Db::name('querycache')->where('type', 'icplist')->where('key|subkey', $domain)->find();
        if($cache && time() - strtotime($cache['uptime']) <= self::CACHE_TIME){
            $array = json_decode($cache['content'], true);
            $data = Db::name('querycache')->where('type', 'icpitem')->whereIn('id', implode(',',$array['list']))->select();
            $list = [];
            foreach($data as $row){
                $list[] = json_decode($row['content'], true);
            }
            return msg('ok','success',['total'=>$array['total'], 'list'=>$list]);
        }

        $cache = Db::name('querycache')->where('type', 'icpitem')->where('key|subkey', $domain)->find();
        if($cache && time() - strtotime($cache['uptime']) <= self::CACHE_TIME){
            $array = json_decode($cache['content'], true);
            return msg('ok','success',['total'=>1, 'list'=>[$array]]);
        }

        try{
            $result = $this->execapi($domain);
        }catch(Exception $e){
            return msg('error', $e->getMessage());
        }

        if($result['total'] > 1 && count($result['data']) > 1){
            $i = 0;
            foreach($result['data'] as $row){
                $id = Db::name('querycache')->duplicate([
                    'subkey' => $row['webLicence'],
                    'content' => json_encode($row),
                    'uptime' => date('Y-m-d H:i:s')
                ])->insertGetId([
                    'type' => 'icpitem',
                    'key' => $row['domain'],
                    'subkey' => $row['webLicence'],
                    'content' => json_encode($row),
                    'uptime' => date('Y-m-d H:i:s')
                ]);
                $result['data'][$i++]['id'] = $id;
                $ids[] = $id;
            }
            Db::name('querycache')->duplicate([
                'subkey' => $result['data'][0]['mainLicence'],
                'content' => json_encode(['total'=>$result['total'], 'list'=>$ids]),
                'uptime' => date('Y-m-d H:i:s')
            ])->insert([
                'type' => 'icplist',
                'key' => $result['data'][0]['unitName'],
                'subkey' => $result['data'][0]['mainLicence'],
                'content' => json_encode(['total'=>$result['total'], 'list'=>$ids]),
                'uptime' => date('Y-m-d H:i:s')
            ]);
        }elseif($result['total'] == 1 && count($result['data']) > 0){
            $id = Db::name('querycache')->duplicate([
                'subkey' => $result['data'][0]['webLicence'],
                'content' => json_encode($result['data'][0]),
                'uptime' => date('Y-m-d H:i:s')
            ])->insertGetId([
                'type' => 'icpitem',
                'key' => $result['data'][0]['domain'],
                'subkey' => $result['data'][0]['webLicence'],
                'content' => json_encode($result['data'][0]),
                'uptime' => date('Y-m-d H:i:s')
            ]);
            $result['data'][0]['id'] = $id;
        }

        return msg('ok','success',['total'=>$result['total'], 'list'=>$result['data']]);
    }

    public function item(){
        $id = input('post.id');
        if(!$id) return msg('error','no id');
        $cache = Db::name('querycache')->where('id', $id)->find();
        if($cache){
            $array = json_decode($cache['content'], true);
            return msg('ok','success',['total'=>1, 'list'=>[$array]]);
        }else{
            return msg('ok','success',['total'=>0, 'list'=>[]]);
        }
    }

    private function execapi($domain){
        $url = self::Query_url.'?domain='.urlencode($domain);
        $data = get_curl($url);
        $arr = json_decode($data, true);
        if(!$arr){
            throw new Exception('查询接口请求失败');
        }else{
            if(isset($arr['code']) && $arr['code'] == 0){
                return $arr;
            }else{
                throw new Exception($arr['msg']);
            }
        }
    }
}