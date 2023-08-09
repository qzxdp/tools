<?php
/**
 * 开发文档
 */

namespace plugin\dev\doc;

use app\Plugin;

class App extends Plugin
{

    public function index()
    {
        return $this->view();
    }


}