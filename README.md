# Mio

`change NGINX world from metrics to insight`

The first goal of `Mio` is to provide powerful API statistics and summary for NGINX.

Metrics is just base, the final goal is automatic improve the user's NGINX system with the power of data.

## Dashborad screenshot
![dashborad](/docs/screenshot.png)

## Installation & run
1. [install](https://openresty.org/en/installation.html) The **latest** OpenResty version.

Please remember add --with-http_stub_status_module configuration parameter when run `./configure`.

2. download Mio to your application directories, then run like this:
```
sudo openresty -p /opt/my-fancy-app/
```

If you build OpenResty from source code, maybe you can not find `openresty`,which is symbolic link to OpenResty's nginx executable file, /usr/local/openresty/nginx/sbin/nginx. So you can run like this:
```
sudo /usr/local/openresty/nginx/sbin/nginx -p /opt/my-fancy-app/
```

3.you can test Mio like this:
```
curl -i http://127.0.0.1/hello
```
> HTTP/1.1 404 Not Found

```
curl -i http://127.0.0.1/summary
```
> {"\/hello":{"total":1,"4xx":1,"sent":314,"request_time":0}}

```
curl -i http://127.0.0.1/status
```
> {"load_timestamp":1470384389,"requests":{"current":0,"total":2,"success":1},"worker_count":2,"address":"127.0.0.1:80","ngx_lua_version":"0.10.5","server_zones":[],"nginx_version":"1.9.15","connections":{"active":1,"writing":1,"current":1,"idle":0,"reading":0},"timestamp":1470384409,"generation":0,"upstreams":[]}

Congratulations,`Mio` is running!

If you run failed, please create a new issue, I will fix it ASAP.

## TODO list

- [ ] use shared dict incr() method  
- [ ] add beautiful UI

## API Compatibility

The `/status` and `/summary` APIs are 100%  compatible with NGINX Plus.

### /status

```
curl http://127.0.0.1/status
```

NGINX Plus 的统计模块数据格式和说明文档在[这里](http://nginx.org/en/docs/http/ngx_http_status_module.html)。NGINX Plus 的json 大块数据为：

```
{
    "version": 6,
    "nginx_version": "1.9.13",
    "address": "206.251.255.64",
    "generation": 21,
    "load_timestamp": 1462615200247,
    "timestamp": 1462870443024,
    "pid": 24978,
    "processes": {},
    "connections": {},
    "ssl": {},
    "requests": {},
    "server_zones": {},
    "upstreams": {},
    "caches": {},
    "stream": {}
}
```

**注意下面数据的缩进，缩进代表json数据的组织**。

比如

> - server_zones
    - hg.nginx.org
        - processing
    - trac.nginx.org
        - responses
            - 1xx

代表的json格式为：

```
"server_zones":{
    "processing":0,
    "requests":71639,
    "responses":{
    	"1xx":0,
    	"2xx":66973,
    	"3xx":3289,
    	"4xx":941,
    	"5xx":264,
    	"total":71467
    },
    "discarded":172,
    "received":21575699,
    "sent":2652969417
},
```

- version

    json格式数据集合的版本号，现在为1。为了兼容性设计

- nginx_version

    NGINX 版本号

- ngx_lua_version

    nginx lua 版本号

- address

   接收 status 请求的服务器地址

- generation

   NGINX 重新加载的次数。不是stop-start的模式，而是reload

- start_timestamp

    NGINX 上次 reload 时的时间戳（ms）

- timestamp

    当前时间戳（ms）。timestamp 和 start_timestamp 之间的差值，就是NGINX 的 uptime

- worker_count

    NGINX worker数

- connections

    > lua 模块获取不到，通过[这个c模块](http://nginx.org/en/docs/http/ngx_http_stub_status_module.html)获取

    - accepted

        曾经接收到的所有终端连接总数（TODO：暂时获取不到）
    - dropped

        drop 掉的所有终端连接总数（TODO：暂时获取不到）
    - current

        当前所有连接数，包括读、写和空闲
    - active

        当前活跃的终端连接数,不包括空闲连接数
    - idle

        当前空闲的终端连接数。**avtive 和 idle 的和，就是 Current**。
    - writing

        当前 NGINX 正在 write response 给终端的连接数

    - reading

        当前 NGINX 正在 read 终端请求头的连接数
- requests
    - total

        NGINX 处理的终端请求总数。自从上一次 stop-start 开始计数，reload 不会影响这个数字。

    - qps

        每秒请求数。

    - success

        NGINX 处理成功的请求总数。内部是通过http应答码小于400来判断的。

    - current

        正在处理的终端请求数(TODO:意义不大，先不做实现)


- server_zones
  - server_zone(这个是 **用户自定义** 的字符串，不是关键字)
    - processing(TODO: 需要 access 阶段配合，稍后完成)

      (The number of client requests that are currently being processed.)

    - requests

      (The total number of client requests received from clients.)

    - discarded

      (The total number of requests completed without sending a response.)

    - received

      (The total number of bytes received from clients.)

    - receive_per_second

        每秒接收到的数据大小，单位是 kb。两次received的差值除以秒数

    - sent

      (The total number of bytes sent to clients.)

    - send_per_second

        每秒发送的数据大小，单位是 kb。两次sent的差值除以秒数

    - responses
      - total  
        The total number of responses sent to clients.
      - 1xx, 2xx, 3xx, 4xx, 5xx  
        The number of responses with status codes 1xx, 2xx, 3xx, 4xx, and 5xx.

- upstreams
    - upstream_name(这个是 **用户自定义** 的字符串，不是关键字)
        - peers
            - id

                server 的 ID
            - server

                server 的 IP:port
            - backup

                布尔值。标记是否为 backup server
            - weight

                这个 server 的权重
            - state（TODO：逻辑比较复杂，稍后完成）

                当前健康状态。值为 “up”, “draining”, “down”, “unavail”,  “unhealthy” 中的一个

            - active

                当前活跃连接数
            - max_conns （TODO：暂时获取不到）

                这个 server 的最大连接数限制
            - requests

                经过这个 server 的所有终端请求总数

            - qps

                每秒请求数

            - response
                - total

                    这个 server 返回响应的总数
                - 1xx, 2xx, 3xx, 4xx, 5xx

                    每个 response 状态码的总数
            - sent

                发送给这个 server 的字节总数。

            - send_per_second

                通过 sent 两次的差值计算出每秒的速率并显示

            - received

                这个 server 接收到的字节总数。

            - receive_per_second

                通过 received 两次的差值计算出每秒的速率并显示

            - fails
                尝试和这个 server 通信，没有成功的总次数

            - unavail

                这个 server 变为『unavail』状态的次数。变为unavail是因为 fails 超过了 [max_fails](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#max_fails) 定义的阈值
            - health_checks( TODO：整个这一项都拿不到，NGINX 没有暴露出来)
                - checks

                    已经发送的[health check](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#health_check) 的次数
                - fails

                    健康检查失败的次数
                - unhealthy

                    这个 server 变为 『unhealthy』状态的次数
                - last_passed

                    布尔值。上一次健康检查是否成功，并且通过了[match测试](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#match)

            - latency
                - mean

                    server 总的平均响应时间，单位是 ms
                - per_minute_mean

                    1分钟内的平均响应时间，单位是 ms
                - per_minute_min

                    1分钟内的最小响应时间，单位是 ms
                - per_minute_max

                    1分钟内的最大响应时间，单位是 ms

### /summary
出于性能考虑，summary 的统计数据会先放在 lru cache 中，由 timer 定时同步到 shared dict 中。
summary 接口的返回值格式为 json，示例：

```
day:{
    "/hello":{
        "total":123, -- 接口访问总数
        "avg_time":0.008, -- 平均返回时间
        "avg_size":10, -- 返回值的平均 body 大小
        "1xx":0,
        "2xx":100982,
        "3xx":0,
        "4xx":222,
        "5xx":112
    },
    "/status":{}
}
```

- 当天的 summary 获取：curl http://127.0.0.1/summary
- 昨天和前天的历史 summary 获取：curl http://127.0.0.1/summary_history
- 最近一分钟的 summary 获取：curl http://127.0.0.1/summary_one_minute
