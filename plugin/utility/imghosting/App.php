<?php
/**
 * QQ高速图床
 */

namespace plugin\utility\imghosting;

use app\Plugin;
use think\facade\Request;
use Exception;

class App extends Plugin
{

    public function index()
    {
        return $this->view();
    }

    public function upload(){
        if(!isset($_FILES['file']))return json(['code'=>-1, 'msg'=>'请选择文件']);
        $filepath = $_FILES["file"]["tmp_name"];
        $filename = $_FILES["file"]["name"];
        if($_FILES['file']['error']>0 || $filepath == ""){
            return json(['code'=>-1, 'msg'=>'文件损坏！']);
        }
        if($_FILES['file']['size']>10*1024*1024){
            return json(['code'=>-1, 'msg'=>'文件最大10M']);
        }
        $apitype = input('?post.apitype')?input('post.apitype'):'qq';

        $classname = 'plugin\\utility\\imghosting\\api\\'.$apitype;
        if(class_exists($classname)){
            $instance = new $classname();
            try{
                $result = $instance->upload($filepath, $filename);
                return json(['code'=>0, 'msg'=>'success', 'data'=>$result]);
            }catch(Exception $e){
                return json(['code'=>-1, 'msg'=>$e->getMessage()]);
            }
        }else{
            return json(['code'=>-1, 'msg'=>'该上传类型不存在']);
        }
    }
    
}