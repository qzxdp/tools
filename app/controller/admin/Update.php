<?php


namespace app\controller\admin;


use app\controller\Base;
use app\lib\ExecSQL;
use think\facade\Request;

class Update extends Base
{
    private $RELEASE_API = '';

    public function initialize()
    {
        reset_opcache();
        $this->RELEASE_API = base64_decode('aHR0cHM6Ly93d3cueHVlbXkuY24vVG9vbC9vcGVuL3JlbGVhc2UucGhw');
    }

    private function get_last_release()
    {

        $res = get_curl($this->RELEASE_API, 0, Request::domain());
        $json = json_decode($res);

        if (empty($json) || empty($json->data)) {
            if (!empty($json->message)) {
                throw new \Exception($json->message);
            }
            throw new \Exception('"连接云中心失败，请检查网络连通性是否正常"');
        }
        return $json;
    }

    public function check()
    {
        try {
            $release = $this->get_last_release();
            $release->data->current_version = get_version();

        } catch (\Exception $e) {
            return msg('error', $e->getMessage());

        }
        return msg('ok', 'success', $release->data);
    }

    public function update()
    {
        try {
            $release = $this->get_last_release();

        } catch (\Exception $e) {
            return msg('error', $e->getMessage());

        }
        $get = get_curl($release->data->download_url);
        if (empty($get) || str_starts_with($get, 'CURL Error:')) {
            return msg('error', '下载更新包失败，请检查网络连通性是否正常');
        }
        $tmpFilename = app()->getRuntimePath() . '/tmp/' . uniqid() . '.zip';
        if (!file_exists(dirname($tmpFilename))) {
            mkdir(dirname($tmpFilename), 0777, true);
        }
        if (!file_put_contents($tmpFilename, $get)) {
            return msg('error', '保存文件失败，请检查是否有写入权限');
        }
        $rootPath = app()->getRootPath();
        if (!unzip($tmpFilename, $rootPath)) {
            return msg('error', '解压压缩包失败');
        }
        return msg('ok', '资源包解压成功', $release->data);
    }

    public function updateDatabase()
    {
        $glob = glob(app()->getRuntimePath() . '/update/sql/*.sql');
        if (empty($glob)) {
            return msg('ok', '未发现数据库更新文件');
        }
        foreach ($glob as $value) {
            $result[$value] = [];
            $basename = basename($value);
            $lines = file($value);
            $execSQL = new ExecSQL();
            $lines = $execSQL->purify($lines);
            $number = $execSQL->exec($lines);
            $result[$value] = array_merge($result[$value], $execSQL->getErrors());

            if ($number > 0) {
                $result[$value][] = "影响的记录数 $number";
            }
            $result[$value][] = '创建数据库升级记录成功';
            end:
            unlink($value);
            $result[$value] = "[$basename]：" . implode("\n", $result[$value]);
        }
        return msg('ok', "数据库执行结果：\n" . implode("\n", $result));
    }

    public function updateScript()
    {
        $glob = glob(app()->getRuntimePath() . '/update/script/*.php');
        if (empty($glob)) {
            return msg('ok', '未发现更新脚本');
        }
        foreach ($glob as $value) {
            $result[$value] = [];
            $basename = basename($value);
            try {
                require $value;
                $class = 'UpdateScript';
                if (!class_exists($class)) {
                    throw new \Exception("更新脚本不存在[$class]类");
                }
                $instance = new $class();
                $boot = 'main';
                if (!method_exists($instance, $boot)) {
                    throw new \Exception("更新脚本不存在[$boot]方法");
                }
                $instance->main();
                $result[$value] = array_merge($result[$value], $instance->getResult());
            } catch (\Exception $e) {
                $result[$value][] = $e->getMessage();
            }
            $result[$value][] = '创建更新脚本升级记录成功';
            end:
            unlink($value);
            $result[$value] = "[$basename]：" . implode("\n", $result[$value]);
        }
        return msg('ok', "更新脚本执行结果：\n" . implode("\n", $result));
    }
}