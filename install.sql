DROP TABLE IF EXISTS `toolbox_category`;
CREATE TABLE `toolbox_category`
(
    `id`          int(11) NOT NULL AUTO_INCREMENT,
    `title`       varchar(255) NOT NULL COMMENT '标题',
    `icon`        varchar(40) DEFAULT NULL,
    `weight`      int(11) NOT NULL DEFAULT '0' COMMENT '权重',
    `enable`      tinyint(1) NOT NULL DEFAULT '1',
    `create_time` datetime     NOT NULL COMMENT '安装时间',
    `update_time` datetime    DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `toolbox_category` (`id`, `title`, `icon`, `weight`, `enable`, `create_time`, `update_time`)
VALUES (1, '站长工具', 'icon ni ni-setting', 9, 1, '2022-04-17 17:55:20', '2022-04-23 20:03:41'),
       (2, '开发工具', 'icon ni ni-code', 8, 1, '2022-04-17 17:55:28', '2022-04-23 20:03:33'),
       (3, '实用工具', 'icon ni ni-map', 7, 1, '2022-04-17 17:55:38', '2022-04-23 14:40:49'),
       (4, '娱乐工具', 'icon ni ni-aperture', 5, 1, '2022-04-17 17:55:45', '2023-09-08 15:49:11'),
       (5, 'ＱＱ工具', 'icon ni ni-chat-circle-fill', 6, 1, '2023-09-08 15:48:31', '2023-09-08 15:52:57');


DROP TABLE IF EXISTS `toolbox_comment`;
CREATE TABLE `toolbox_comment`
(
    `id`          int(11) NOT NULL AUTO_INCREMENT,
    `uid`         int(11) NOT NULL,
    `email`       varchar(255) DEFAULT NULL,
    `ip`          varchar(20)  DEFAULT NULL,
    `content`     text,
    `reply`       text,
    `enable`      tinyint(1) NOT NULL DEFAULT '0',
    `create_time` datetime NOT NULL COMMENT '创建时间',
    `update_time` datetime NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY           `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `toolbox_config`;
CREATE TABLE `toolbox_config`
(
    `key`   varchar(32) NOT NULL COMMENT '标题',
    `value` varchar(255) DEFAULT NULL COMMENT '值',
    PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `toolbox_config` (`key`, `value`)
VALUES ('admin_password', ''),
       ('admin_username', ''),
       ('captcha_id', ''),
       ('captcha_key', ''),
       ('cdn_cdnjs', '//cdn.staticfile.org/'),
       ('cdn_npm', 'https://npm.elemecdn.com/'),
       ('description', '这是一个非常Nice的在线工具箱，本工具箱由全栈行动派提供'),
       ('foot_code', '<br>本站由<a href="//www.qzxdp.cn">全栈行动派</a>强力驱动'),
       ('keywords', '全栈工具箱,源码查看器原创,在线,工具,源码来源于全栈行动派'),
       ('oauth_appid', '1000'),
       ('oauth_appkey', ''),
       ('oauth_appurl', ''),
       ('oauth_openqq', '1'),
       ('oauth_openwx', '1'),
       ('subtitle', '源码来源于全栈行动派'),
       ('syskey', ''),
       ('template', 'default'),
       ('title', '全栈工具箱');


DROP TABLE IF EXISTS `toolbox_link`;
CREATE TABLE `toolbox_link`
(
    `id`          int(11) NOT NULL AUTO_INCREMENT,
    `name`        varchar(120) NOT NULL COMMENT '链接文字',
    `url`         varchar(255) NOT NULL COMMENT '链接地址',
    `weight`      int(11) NOT NULL DEFAULT '0' COMMENT '权重',
    `enable`      tinyint(1) NOT NULL DEFAULT '0' COMMENT '链接状态',
    `create_time` datetime     NOT NULL COMMENT '创建时间',
    `update_time` datetime     NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `toolbox_link` (`id`, `name`, `url`, `weight`, `enable`, `create_time`, `update_time`)
VALUES (1, '全栈行动派', 'https://www.qzxdp.cn/', 8, 1, '2022-04-21 22:24:16', '2022-04-22 22:01:01');


DROP TABLE IF EXISTS `toolbox_plugin`;
CREATE TABLE `toolbox_plugin`
(
    `id`            int(11) NOT NULL AUTO_INCREMENT,
    `title`         varchar(255) NOT NULL COMMENT '插件标题',
    `alias`         varchar(128) NOT NULL COMMENT '插件名',
    `class`         varchar(128) NOT NULL COMMENT '插件类',
    `keyword`       varchar(255) DEFAULT NULL,
    `weight`        int(11) NOT NULL DEFAULT '0' COMMENT '权重',
    `enable`        tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
    `level`         int(11) NOT NULL DEFAULT '0',
    `login`         tinyint(1) NOT NULL DEFAULT '0',
    `request_count` int(11) NOT NULL DEFAULT '0' COMMENT '接口请求次数',
    `category_id`   int(11) NOT NULL DEFAULT '0' COMMENT '分类',
    `desc`          text,
    `create_time`   datetime     NOT NULL COMMENT '安装时间',
    `update_time`   datetime     NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `alias` (`alias`),
    UNIQUE KEY `class` (`class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `toolbox_plugin` (`id`, `title`, `alias`, `class`, `keyword`, `weight`, `enable`, `level`, `login`,
                              `request_count`, `category_id`, `desc`, `create_time`, `update_time`)
VALUES (2, '随机密码生成', 'rand_password', 'utility\\rand_password', 'suijimimashengcheng,sjmmsc', 86, 1, 0, 0, 0, 3,
        '', '2022-04-17 17:54:49', '2023-08-08 17:27:36'),
       (3, '支付宝到账语音', 'alipay_arrival', 'fun\\alipay_arrival', 'zhifubaodaozhangyuyin,zfbdzyy', 7, 1, 0, 0, 0, 4,
        '', '2022-04-17 18:09:43', '2023-08-08 17:29:50'),
       (5, '让流量消失', 'bandwidth_waste', 'fun\\bandwidth_waste', 'rangliuliangxiaoshi,rllxs', 6, 1, 0, 0, 0, 4, '',
        '2022-04-17 18:10:15', '2023-08-08 17:29:53'),
       (13, 'emoji表情', 'emoji', 'utility\\emoji', 'emojibiaoqing,emojibq', 79, 1, 0, 0, 0, 3, '',
        '2022-04-21 17:51:49', '2023-08-08 17:28:09'),
       (19, 'CSS格式化/压缩', 'code_css', 'dev\\code_css', 'cssgeshihuayasuo,cssgshys', 87, 1, 0, 0, 0, 2, '',
        '2022-04-25 10:59:11', '2023-08-08 17:25:00'),
       (20, 'Html格式化/压缩', 'code_html', 'dev\\code_html', 'htmlgeshihuayasuo,htmlgshys', 88, 1, 0, 0, 0, 2, '',
        '2022-04-25 14:52:26', '2023-08-08 17:24:56'),
       (21, 'JavaScript格式化/压缩', 'code_js', 'dev\\code_js', 'javascriptgeshihuayasuo,jsgshys', 89, 1, 0, 0, 0, 2,
        '', '2022-04-25 15:05:53', '2023-08-08 17:24:53'),
       (22, '字节计算器', 'byte_calc', 'dev\\byte_calc', 'zijiejisuanqi,zjjsq', 98, 1, 0, 0, 0, 2, '',
        '2022-04-25 15:28:28', '2023-08-08 17:23:24'),
       (23, '文章生成器', 'bullshit_generator', 'fun\\bullshit_generator', 'wenzhangshengchengqi,wzscq', 8, 1, 0, 0, 0,
        4, '', '2022-04-25 15:51:35', '2023-08-08 17:29:49'),
       (24, 'base64编码/解码', 'base64', 'dev\\base64', 'base64bianmajiema,base64bmjm', 0, 0, 0, 0, 0, 2, '',
        '2022-04-25 16:14:16', '2022-04-25 16:14:16'),
       (25, 'ASCII艺术字生成', 'ascii_art', 'fun\\ascii_art', 'asciiyishuzishengcheng,asciiyszsc', 9, 1, 0, 0, 0, 4, '',
        '2022-04-25 16:30:03', '2023-08-08 17:29:42'),
       (26, '对称加密解密', 'encrypt', 'dev\\encrypt', 'duichenjiamijiemi,dcjmjm', 94, 1, 0, 0, 0, 2, '',
        '2022-04-26 16:53:45', '2023-08-08 17:24:28'),
       (27, '文件哈希计算', 'file_hash', 'utility\\file_hash', 'wenjianhaxijisuan,wenjianhashjisuan,wjhxjs', 85, 1, 0,
        0, 0, 3, '', '2022-04-26 17:50:55', '2023-08-08 17:27:43'),
       (28, 'GitHub下载加速', 'github', 'dev\\github', 'github,xiazaijiasu,xzjs', 96, 1, 0, 0, 0, 2, '',
        '2022-04-27 16:43:06', '2023-08-08 17:23:49'),
       (29, 'QQ百度高速图床', 'imghosting', 'utility\\imghosting', 'qqbaidugaosutuchuang,qqbdgstc', 99, 1, 0, 0, 0, 3,
        '', '2022-04-27 17:21:50', '2023-08-08 17:25:42'),
       (30, 'uniCloud文件快传', 'unicloud', 'utility\\unicloud', 'unicloud,wenjiankuaichuan,unicloudwjkc', 98, 1, 0, 0,
        0, 3, '', '2022-04-28 16:49:37', '2023-08-08 17:25:44'),
       (31, '网站Favicon获取', 'favicon', 'web\\favicon', 'wangzhanfaviconhuoqu,wzfaviconhq', 92, 1, 0, 0, 0, 1, '',
        '2022-04-28 19:01:36', '2023-08-08 17:22:01'),
       (32, '字符串哈希计算', 'str_hash', 'utility\\str_hash', 'zifuchuanhaxijisuan,zfchxjs', 84, 1, 0, 0, 0, 3, '',
        '2022-04-29 18:12:57', '2023-08-08 17:27:44'),
       (33, '在线进制转换', 'hex_convert', 'dev\\hex_convert', 'zaixianjinzhizhuanhuan,zxjzzh', 97, 1, 0, 0, 0, 2, '',
        '2022-04-29 19:19:26', '2023-08-08 17:24:15'),
       (34, 'ICP备案查询', 'icp', 'web\\icp', 'icpbeianchaxun,icpbacx', 97, 1, 0, 0, 0, 1, '', '2022-04-30 16:49:34',
        '2023-08-08 17:21:39'),
       (35, 'IP地址查询', 'ip', 'web\\ip', 'ipdizhichaxun,ipquery,ipdzcx', 98, 1, 0, 0, 0, 1, '', '2022-05-01 10:41:15',
        '2023-08-08 17:21:37'),
       (36, '域名Whois查询', 'whois', 'web\\whois', 'yumingwhoischaxun,ymwhoiscx', 96, 1, 0, 0, 0, 1, '',
        '2022-05-02 10:40:21', '2023-08-08 17:21:42'),
       (37, '在线图片编辑', 'image_editor', 'utility\\image_editor', 'zaixiantupianbianji,zxtpbj', 89, 1, 0, 0, 0, 3,
        '', '2022-05-02 11:42:03', '2023-08-08 17:27:25'),
       (38, '图片转base64', 'image2base64', 'utility\\image2base64', 'tupianzhuanbase64,tpzbase64', 87, 1, 0, 0, 0, 3,
        '', '2022-05-02 12:09:00', '2023-08-08 17:27:29'),
       (39, 'JSON解析格式化', 'json', 'dev\\json', 'jsonjiexigeshihua,jsonjxgsh', 90, 1, 0, 0, 0, 2, '',
        '2022-05-02 12:44:30', '2023-08-08 17:24:51'),
       (40, 'Linux命令查询', 'linux_command', 'dev\\linux_command', 'linuxminglingchaxun,linuxmlcx', 91, 1, 0, 0, 0, 2,
        '', '2022-05-02 14:52:25', '2023-08-08 22:14:25'),
       (41, 'Markdown在线编辑', 'markdown', 'dev\\markdown', 'markdownzaixianbianji,markdownzxbj', 92, 1, 0, 0, 0, 2,
        '', '2022-05-02 16:42:06', '2023-08-08 17:24:42'),
       (42, 'MimeType类型表', 'mime_type', 'dev\\mime_type', 'mimetypeleixingbiao,mimetypelxb', 85, 1, 0, 0, 0, 2, '',
        '2022-05-02 16:50:24', '2023-08-08 17:25:07'),
       (43, '在线钢琴', 'piano', 'fun\\piano', 'zaixiangangqin,piano,zxgq', 5, 1, 0, 0, 0, 4, '', '2022-05-02 17:03:13',
        '2023-08-08 17:29:54'),
       (44, '二维码生成', 'qrcode', 'utility\\qrcode', 'erweimashengcheng,ewmsc,qrcode', 88, 1, 0, 0, 0, 3, '',
        '2022-05-02 17:12:05', '2023-08-08 17:27:27'),
       (45, 'RSA公私钥生成', 'rsa', 'dev\\rsa', 'rsagongsiyueshengcheng,rsagsysc', 95, 1, 0, 0, 0, 2, '',
        '2022-05-02 17:43:38', '2023-08-08 17:24:08'),
       (46, '短网址生成', 'short_url', 'utility\\short_url', 'duanwangzhishengcheng,shorturl,dwzsc', 83, 1, 0, 0, 0, 3,
        '', '2022-05-02 18:24:35', '2023-08-08 17:27:54'),
       (47, '特殊符号大全', 'special_symbols', 'utility\\special_symbols', 'teshufuhaodaquan,tsfhdq', 78, 1, 0, 0, 0, 3,
        '', '2022-05-02 20:22:10', '2023-08-08 17:28:11'),
       (48, '在线语音合成', 'speech_synthesis', 'fun\\speech_synthesis', 'zaixianyuyinhecheng,zxyyhc', 10, 1, 0, 0, 0,
        4, '', '2022-05-02 20:25:56', '2023-08-08 17:29:40'),
       (49, '字数统计与排版', 'text_count', 'utility\\text_count', 'zishutongjiyupaiban,zstjypb', 81, 1, 0, 0, 0, 3, '',
        '2022-05-02 20:49:16', '2023-08-08 17:28:01'),
       (50, 'Unix时间戳转换', 'timestamp', 'utility\\timestamp', 'unixshijianchuozhuanhuan,unixsjczh', 82, 1, 0, 0, 0,
        3, '', '2022-05-03 09:29:08', '2023-08-08 17:27:57'),
       (51, 'UUID生成器', 'uuid', 'dev\\uuid', 'uuidshengchengqi,guid,uuidscq', 93, 1, 0, 0, 0, 2, '',
        '2022-05-03 15:48:04', '2023-08-08 17:24:35'),
       (52, '中文简繁体转化', 'zh_convert', 'utility\\zh_convert', 'zhongwenjianfantizhuanhua,zwjftzh', 80, 1, 0, 0, 0,
        3, '', '2022-05-03 16:16:50', '2023-08-08 17:28:02'),
       (53, '中文域名转码', 'punycode', 'web\\punycode', 'zhongwenyumingzhuanma,zwymzm,punycode', 91, 1, 0, 0, 0, 1, '',
        '2022-05-03 16:25:30', '2023-08-08 17:22:04'),
       (54, '编码解码器', 'decode', 'dev\\decode', 'bianmajiemaqi,bmjmq', 99, 1, 0, 0, 0, 2, '', '2022-05-03 17:15:14',
        '2023-08-08 17:23:20'),
       (55, '腾讯域名拦截查询', 'checkurl', 'web\\checkurl', 'yuminglanjiechaxun,ymljcx', 95, 1, 0, 0, 0, 1, '',
        '2022-05-03 18:31:42', '2023-08-08 17:21:46'),
       (56, '净网云剑拦截查询', 'cqqgsafe', 'web\\cqqgsafe', 'jingwangyunjianlanjiechaxun,jwyjljcx', 94, 1, 0, 0, 0, 1,
        '', '2022-05-03 19:38:25', '2023-08-08 17:21:49'),
       (57, '手机在线FTP', 'http://ftp.cccyun.cc/', 'web\\ftp', 'shoujizaixianftp,sjzxftp', 89, 1, 0, 0, 0, 1, '',
        '2022-05-03 20:01:40', '2023-08-08 17:22:18'),
       (58, 'MySQL管理器', '/tool/mysql/', 'web\\mysql', 'mysqlguanliqi,mysqlglq', 90, 1, 0, 0, 0, 1, '',
        '2022-05-03 20:05:08', '2023-08-08 17:22:15'),
       (59, '百度BDUSS获取', '/tool/bduss/', 'utility\\bduss', 'baidubdusshuoqu,bdbdusshq', 96, 1, 0, 0, 0, 3, '',
        '2022-05-03 20:06:37', '2023-08-08 17:26:10'),
       (60, 'QQ获取COOKIE', 'http://qweb.sinaapp.com/tool/newsid/', 'utility\\newsid', 'qqhuoqucookie,qqhqcookie', 97,
        1, 0, 0, 0, 3, '', '2022-05-03 20:07:13', '2023-08-08 17:28:42'),
       (61, '全网音乐搜索', 'http://www.musictool.top/', 'utility\\musictool', 'quanwangyinyuesousuo,qwyyss,music', 95,
        1, 0, 0, 0, 3, '', '2022-05-03 20:07:48', '2023-08-08 17:26:28'),
       (62, '百度网盘分享', 'http://wp.cccyun.cc/', 'utility\\bdpan', 'baiduwangpanfenxiang,bdwpfx', 92, 1, 0, 0, 0, 3,
        '', '2022-05-03 20:08:20', '2023-08-08 17:26:38'),
       (63, '手机归属地查询', 'mobile', 'utility\\mobile', 'shoujiguishudichaxun,sjgsdcx', 91, 1, 0, 0, 0, 3, '',
        '2022-05-03 20:39:06', '2023-08-08 17:26:52'),
       (64, '身份证归属地查询', 'idcard', 'utility\\idcard', 'shenfenzhengguishudichaxun,sfzgsdcx', 90, 1, 0, 0, 0, 3,
        '', '2022-05-03 20:56:37', '2023-08-08 17:26:55'),
       (65, '网页源代码查看', 'viewhtml', 'web\\viewhtml', 'wangyeyuandaimachakan,wyydmck', 99, 1, 0, 0, 0, 1, '',
        '2023-08-08 09:11:50', '2023-08-08 17:21:32'),
       (66, '数字IP地址转换', 'ip_num', 'web\\ip_num', 'shuziipdizhizhuanhuan,szipdzzh', 93, 1, 0, 0, 0, 1, '',
        '2023-08-08 15:18:31', '2023-08-08 17:21:55'),
       (67, 'RGB颜色对照表', 'rgb_color', 'dev\\rgb_color', 'rgbyanseduizhaobiao,rgbysdzb', 86, 1, 0, 0, 0, 2, '',
        '2023-08-08 16:15:31', '2023-08-08 17:25:04'),
       (68, '查看HTTP请求', 'http', 'web\\http', 'chakanhttpqingqiu,ckhttpqq', 88, 1, 0, 0, 0, 1, '',
        '2023-08-08 16:26:15', '2023-08-08 17:22:20'),
       (69, '音乐外链转换', 'https://link.hhtjim.com/', 'utility\\music_link', 'yinyuewailianzhuanhuan,yywlzh', 93, 1,
        0, 0, 0, 3, '', '2023-08-08 17:11:49', '2023-08-08 17:26:35'),
       (70, 'SEO综合查询', 'https://seo.chinaz.com/', 'web\\seo', 'seozonghechaxun,seozhcx', 86, 1, 0, 0, 0, 1, '',
        '2023-08-08 17:18:00', '2023-08-08 17:22:26'),
       (71, 'PING网站测速', 'https://ping.chinaz.com/', 'web\\ping', 'pingwangzhancesu,pingwzcs', 87, 1, 0, 0, 0, 1, '',
        '2023-08-08 17:18:32', '2023-08-08 17:22:24'),
       (72, '音乐文件解锁', 'http://unlock.musictool.top/', 'utility\\unlockmusic', 'yinyuewenjianjiesuo,yywjjs', 94, 1,
        0, 0, 0, 3, '', '2023-08-08 17:19:40', '2023-08-08 17:26:32'),
       (73, 'HTTP状态查询', 'http_status', 'web\\http_status', 'httpzhuangtaichaxun,httpztcx', 0, 1, 0, 0, 0, 1, '',
        '2022-05-05 18:12:55', '2022-05-05 18:12:55'),
       (74, '域名DNS查询', 'dns', 'web\\dns', 'yumingdnschaxun,ymdnscx', 0, 1, 0, 0, 0, 1, '', '2022-05-07 16:44:11',
        '2022-05-11 15:59:22'),
       (75, '提取群成员', 'group_members', 'wqq\\group_members', 'tiquqqqunchengyuan,tqqqqcy', 88, 1, 0, 0, 0, 5, '',
        '2022-05-17 17:41:22', '2023-09-08 15:58:54'),
       (76, '批量删除群公告', 'group_announce', 'wqq\\group_announce', 'piliangshanchuqungonggao,plscqgg', 87, 1, 0, 0,
        0, 5, '', '2022-05-17 18:11:49', '2023-09-08 15:58:56'),
       (77, '自助解散群', 'group_dismiss', 'wqq\\group_dismiss', 'zizhujiesanqqqun,zzjsqqq', 86, 1, 0, 0, 0, 5, '',
        '2022-05-17 18:33:38', '2023-09-08 15:58:57'),
       (78, '单向好友检测', 'friend_check', 'wqq\\friend_check', 'qqdanxianghaoyoujiance,qqdxhyjc', 97, 1, 0, 0, 0, 5,
        '', '2022-05-17 20:07:22', '2023-09-08 15:58:50'),
       (79, 'QQ强制聊天', 'qqchat', 'wqq\\qqchat', 'qqqiangzhiliaotian,qqqzlt', 99, 1, 0, 0, 0, 5, '',
        '2022-05-17 23:13:21', '2023-09-08 15:58:47'),
       (80, '生成加群链接', 'group_join', 'wqq\\group_join', 'shengchengjiaqunlianjie', 89, 1, 0, 0, 0, 5, '',
        '2023-09-08 10:32:39', '2023-09-08 15:58:52'),
       (81, '设置空白昵称', 'setqqnick', 'wqq\\setqqnick', 'shezhikongbainicheng,szkbnc', 96, 1, 0, 0, 0, 5, '',
        '2023-09-08 11:20:50', '2023-09-08 15:58:51'),
       (83, '自定义在线机型', 'online_device', 'wqq\\online_device', 'zidingyizaixianjixing,zdyzxjx', 98, 1, 0, 0, 0, 5,
        '', '2023-09-08 12:28:58', '2023-09-08 15:58:49'),
       (84, '小米运动步数修改', 'sport', 'utility\\sport', 'xiaomiyundongbushuxiugai,xmydbsxg', 0, 1, 0, 0, 0, 3, '',
        '2022-05-19 17:01:51', '2022-05-19 20:28:21'),
       (85, '短网址还原', 'unshorturl', 'utility\\unshorturl', 'duanwangzhihuanyuan,dwzhy', 83, 1, 0, 0, 0, 3, '',
        '2022-05-20 11:17:56', '2022-05-20 11:34:05'),
       (86, '查B站弹幕发送者', 'bili_danmu', 'utility\\bili_danmu', 'chabzhandanmufasongzhe,cbzdmfsz', 0, 1, 0, 0, 0, 3,
        '', '2022-05-20 13:41:20', '2022-05-20 13:41:43'),
       (87, 'B站视频解析', 'bili_video', 'utility\\bili_video', 'bzhanshipinjiexi,bzspjx', 0, 1, 0, 0, 0, 3, '',
        '2022-05-21 10:42:14', '2022-05-21 10:42:14');


DROP TABLE IF EXISTS `toolbox_querycache`;
CREATE TABLE `toolbox_querycache`
(
    `id`      int(11) NOT NULL AUTO_INCREMENT,
    `type`    varchar(32)  NOT NULL,
    `key`     varchar(128) NOT NULL,
    `subkey`  varchar(128) DEFAULT NULL,
    `content` text,
    `uptime`  datetime     NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `cachekey` (`key`,`type`),
    KEY       `cachekey2` (`subkey`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `toolbox_user`;
CREATE TABLE `toolbox_user`
(
    `id`          int(11) NOT NULL AUTO_INCREMENT,
    `username`    varchar(255) NOT NULL COMMENT '用户名',
    `password`    varchar(64)  NOT NULL,
    `stars`       text         NOT NULL COMMENT '标星',
    `avatar_url`  varchar(255) NOT NULL COMMENT '头像',
    `type`        varchar(20)  NOT NULL,
    `openid`      varchar(150) NOT NULL,
    `enable`      tinyint(1) NOT NULL DEFAULT '1',
    `regip`       varchar(20) DEFAULT NULL,
    `loginip`     varchar(20) DEFAULT NULL,
    `level`       int(11) NOT NULL DEFAULT '0',
    `create_time` datetime     NOT NULL COMMENT '创建时间',
    `update_time` datetime     NOT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY           `openid` (`openid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=1000;
