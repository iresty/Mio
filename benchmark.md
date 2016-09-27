## 性能测试
做一个正确的性能测试并不容易，有不少需要注意的地方。下面是 `Mio` 的性能测试步骤，请大家参考指正。

### 系统设置

#### 关闭 SELinux
如果你是 CentOS/RedHat 系列的操作系统，建议你关闭 SELinux，不然可能会遇到不少诡异的权限问题。

通过这个命令查看 SELinux 是否开启：
>$ sestatus                                              
SELinux status:                 disabled

如果是开启的，通过这个方法来临时关闭：
>$ setenforce 0

同时修改 `/etc/selinux/config` 文件来永久关闭，将 `SELINUX=enforcing`
改为 `SELINUX=disabled`。

#### 最大打开文件数
> $ cat /proc/sys/fs/file-nr                                                                                              
3984    0       3255296

第三个数字 3255296 就是当前系统的全局最大打开文件数。

如果你的机器中这个数字比较小，请修改为 100w 以上或者更多。
通过修改 `/etc/sysctl.conf` 文件来实现：
>fs.file-max = 1020000  
>net.ipv4.ip_conntrack_max = 1020000    
>net.ipv4.netfilter.ip_conntrack_max = 1020000

需要重启系统服务来生效：
>sudo sysctl -p /etc/sysctl.conf

#### 进程限制
修改每一个进程可以打开文件数的限制，也就是 ulimit，这样子查看当前的限制：
>$ ulimit -n    
1024

临时修改的方法：
>$ ulimit -n 1024000

永久修改，编辑 `/etc/security/limits.conf`， 增加：

>\*         hard    nofile      1024000  
\*         soft    nofile      1024000

 星号代表的是所有用户。

#### 测试是否支持到 C1000K
 别着急，我们先用工具测试下，看我们这样子修改后，是否可以支持 C1000K。

 这里有一个开源的工具，来自 SSDB 的作者：https://github.com/ideawu/c1000k。

 使用方法非常简单，启动一个服务端和客户端，来测试连接，具体见这个项目的说明。

#### 修改 NGINX 参数
 ```
 user nginx;

 worker_processes 4;
 worker_cpu_affinity 0001 0010 0100 1000;

 events {
     worker_connections 10240;
 }
 ```

 以上面的配置文件为例，有几个注意点：
 - 新增 OpenResty 的用户，这里取名为 nginx。这样可以保证基于 OpenResty 的程序不会干坏事儿，也不会被想干坏事儿的人利用。比如利用它来执行系统命令什么的。
 - NGINX 的工作进程设置为 4 个。我的测试环境是 24 核，我需要压测工具让每一个 NGINX 工作进程都跑满 CPU，所以我设置的并不高。在你的生成环境中，一般会设置为和 CPU 核数相同的值。
 - 设置 CPU 亲缘性，防止 CPU 资源使用不均衡。
 - 调整每个NGINX worker 的连接数限制。

 其中第二点和第三点，在 NGINX 1.9.10 以后的版本中可以自动完成，如下面所示：
 >worker_processes auto;    
 worker_cpu_affinity auto;

#### 压测前的检查
 压测前，你需要简单的用 curl 检查下 `Mio`的各个接口是否正常工作，比如：
 > curl -i http://127.0.0.1/hello   
 curl -i http://127.0.0.1:9090/status    
 curl -i http://127.0.0.1:9090/summary

 不仅要看返回值，更要看 `logs/error.log` 是否有日志记录。

 一般来说都是权限的问题。比如 NGINX 的用户没有代码目录的权限，你需要用 `chown` 来解决。特别注意的是，`chmod 777` 这样的命令过于粗暴，也有安全隐患，最好不要使用。

 有时候，你关闭了 SELinux，也通过 `chown` 设置了正确的用户，还是报错，提示权限问题。这个时候不要像无头苍蝇一样胡乱尝试，你应该:
 > su nginx

 切换到这个用户下，试试具体的问题。有时候是因为某个代码目录 **没有执行权限**, 你需要 `chmod +x` 来解决。

 比如 `/root/Mio/gateway` 目录，你可能有 Mio 目录的执行权限，却没有 root 的执行权限。你可以 `chmod +x` 来解决，也可以换到其他目录来解决。

#### 开始测试
 这里我们选用最简单易用的 `ab` 来进行压力测试，而不是 loadrunner 和 wrk。毕竟我们的目的很简单，能让NGINX worker 满载就行。

 > ab -c 300 -n 1000000 -k 127.0.0.1/hello

注意其中的 `-k`，保持 KeepAlive，而不是每次都新建一个连接。

在我的测试环境中（24 核，32G内存，4个 NGINX worker），单纯的`hello` 接口，以及加入 `Mio` 的统计代码后，QPS 都在 80000 左右，看不到 `Mio` 对 QPS 的影响。

具体的 NGINX 配置参见 [profiling](profiling.md)。
