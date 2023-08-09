<?php
declare (strict_types=1);

namespace app\middleware;

use think\facade\View;

class RefererCheck
{
    /**
     * 处理请求
     *
     * @param \think\Request $request
     * @param \Closure $next
     * @return Response
     */
    public function handle($request, \Closure $next)
    {

        $url = $_SERVER["REQUEST_URI"];
        printLog("-->".$url);
        if (!checkRefererHost()) {
            return response('Access Denied', 403);
        }
        return $next($request);
    }
}
