### 概述

目前Mio分了三个Server（端口）来提供以下功能：

- 80端口，用于主业务
- 8080端口，提供内置Dashboard
- 9090端口，暴露HTTP API

各目录描述如下：

```
Mio
├── LICENSE
├── README.md
├── api           9090端口对应的代码
├── conf          配置文件目录，用于存放nginx相关的配置文件
├── dashboard     8080端口对应的内置Dashboard代码
├── docs          文档目录
├── gateway       Mio核心代码，用于处理统计、监控等逻辑
├── logs          日志目录
├── resty         第三方库，如lru缓存组件、lor框架等
└── start.sh      启动脚本
```

### 使用

**Dashboard使用**

只要访问`http://ip:8080`即可。

**API Server使用**

以`/status`为例，访问`http://ip:9090/status`这个API，响应如下：

```javascript
{
    "load_timestamp": 1471424591,
    "requests": {
        "current": 0,
        "total": 0,
        "success": 0
    },
    "worker_count": 2,
    "address": "127.0.0.1:9090",
    "ngx_lua_version": "0.10.1",
    "server_zones": {},
    "nginx_version": "1.9.7",
    "connections": {
        "active": 1,
        "writing": 1,
        "current": 1,
        "idle": 0,
        "reading": 0
    },
    "timestamp": 1471424601,
    "generation": 0,
    "upstreams": {}
}
```

### 如何开发Dashboard或添加新API

Dashboard和API Server都是HTTP应用，目前基于[lor框架](https://github.com/sumory/lor)搭建。建议在开发前先行了解lor框架的基本使用方法，并参考目前Dashboard和API Server的代码规范即可。

**具体来说：**

Dashboard和API Server都用到了`gateway/api.lua`中暴露出来的方法，如

```lua
API["/status"] = {
    GET = function()
        return function(req, res, next)
            local resport = status.report()
            if resport then
                res:json(resport, true)
            else
                res:status(500)
            end
        end
    end
}
```

这个API指的是，使用`Get`请求访问`/status`时，正常情况返回一个json数据，错误时返回500状态码。`function(req, res, next) ... end`是一个符合lor框架规范的匿名函数，req/res/next是lor框架里用于包装请求、响应和路由控制的对象，具体请参看[lor文档](http://lor.sumory.com/apis/v0.1.0/#request对象)。

如果要添加API，只要仿照上例在`gateway/api.lua`中编写即可，目前支持的HTTP Method有Get/Post/Put/Delete，这样在9090端口暴露的HTTP API中就会自动加载新的API。这个加载过程是在`api/router.lua`中通过以下代码自动实现的：

```lua
--- 加载gateway暴露出来的API
local default_api_path = "gateway.api"
local ok, api = pcall(require, default_api_path)

if not ok or not api or type(api) ~= "table" then
    ngx.log(ngx.ERR, "[API exposed error], api_path:", default_api_path)
    return api_router
end

for uri, api_methods in pairs(api) do
    ngx.log(ngx.INFO, "load route, uri:", uri)
    if type(api_methods) == "table" then
        for method, func in pairs(api_methods) do
            local m = string_lower(method)
            if m == "get" or m == "post" or m == "put" or m == "delete" then
                api_router[m](api_router, uri, func())
            end
        end
    end
end
```

同样的，在8080端口实现的Dashboard也通过以上方法加载了`gateway/api.lua`中暴露的API。

