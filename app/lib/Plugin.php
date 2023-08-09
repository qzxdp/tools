<?php

namespace app\lib;

use think\Exception;
use think\facade\Db;

/**
 * 实例化后需要保存zip文件到 $zipFilepath
 * Class Plugin
 * @package app\lib
 */
class Plugin
{
    private $tmpPath = '';
    private $uniqid = '';
    private $zipFilename = '';
    private $zipFilepath = '';
    private $tmpDirPath = '';
    private $pluginPath = '';
    private $pluginAuthor = '';
    private $pluginName = '';
    private $pluginClass = '';

    public function __construct()
    {
        $this->tmpPath = app()->getRuntimePath() . '/tmp/';
        $this->uniqid = uniqid();
        $this->zipFilename = $this->uniqid . '.zip';
        $this->zipFilepath = $this->tmpPath . $this->zipFilename;

        $this->tmpDirPath = $this->tmpPath . $this->uniqid . '/';;

        if (!file_exists($this->tmpPath)) {
            mkdir($this->tmpPath, 0777, true);
        }

    }

    private function unzip()
    {
        if (!file_exists($this->zipFilepath)) {
            throw new Exception('压缩包不存在请重试');
        }
        if (!unzip($this->zipFilepath, $this->tmpDirPath)) {
            throw new Exception('解压失败');
        }
        return true;
    }

    private function checkPlugin()
    {
        $tree_relative = tree_relative($this->tmpDirPath);
        $arr1 = array_keys($tree_relative);
        $pluginAuthor = reset($arr1);
        if (empty($pluginAuthor)) {
            throw new Exception('插件目录格式有误,安装失败');
        }
        $arr2 = array_keys($tree_relative[$pluginAuthor]);
        $pluginName = reset($arr2);

        if (empty($pluginAuthor) || empty($pluginName)) {
            throw new Exception('插件目录格式有误,安装失败');
        }

        if (!file_exists("$this->tmpDirPath/$pluginAuthor/$pluginName/Install.php")) {
            throw new Exception('插件缺失Install.php,安装失败');
        }
        return [
            $pluginAuthor,
            $pluginName,
        ];
    }

    private function clearOld()
    {

        if (!file_exists(dirname($this->pluginPath))) {
            mkdir(dirname($this->pluginPath), 0777, true);
        }
        del_tree($this->pluginPath);
    }

    public function install()
    {
        try {

            $this->unzip();

            $checkPlugin = $this->checkPlugin();

            $this->pluginAuthor = $checkPlugin[0];
            $this->pluginName = $checkPlugin[1];

            $this->pluginPath = plugin_path_get() . "/$this->pluginAuthor/$this->pluginName";
            //清空旧插件
            $this->clearOld();
            //移动文件
            rename("$this->tmpDirPath/$this->pluginAuthor/$this->pluginName", $this->pluginPath);
            // 执行Install.php
            require "$this->pluginPath/Install.php";

            $this->pluginClass = "$this->pluginAuthor\\$this->pluginName";
            $class = "plugin\\$this->pluginClass\\Install";
            if (!class_exists($class)) {
                throw new Exception("插件缺失类$this->pluginClass,安装失败");
            }
            $install = new $class();
            $model = Db::name('plugin')->where('class', $this->pluginClass)->find();
            if (!$model) {
                $model['title'] = '插件' . $this->uniqid;
                $model['alias'] = $this->uniqid;
                $model['class'] = $this->pluginClass;
                $model['desc'] = '';
                $model['category_id'] = 0;
                $model['request_count'] = 0;
            }
            $pluginconfig = $install->Install();
            if(isset($pluginconfig['title'])) $model['title'] = $pluginconfig['title'];
            if(isset($pluginconfig['alias'])) $model['alias'] = $pluginconfig['alias'];
            if(isset($pluginconfig['class'])) $model['class'] = $pluginconfig['class'];
            if(isset($pluginconfig['desc'])) $model['desc'] = $pluginconfig['desc'];
            
            //判断alias是否重复
            $model2 = Db::name('plugin')->where('alias', $model['alias'])->find();
            if ($model2 && $model2['id'] !== $model['id']) {
                $model['alias'] .= "_$this->uniqid";
            }
            $model['id'] = Db::name('plugin')->cache('plugins')->insertGetId($model);
        } catch (\Exception $e) {
            @del_tree($this->pluginPath);
            return msg('error', $e->getMessage());
        } finally {
            @del_tree($this->tmpDirPath);
            @unlink($this->zipFilepath);
        }
        return msg('ok', '安装成功', $model);
    }

    /**
     * @return string
     */
    public function getZipFilepath(): string
    {
        return $this->zipFilepath;
    }
}