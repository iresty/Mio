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

 #### 
