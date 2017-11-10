
零、集群规划
```
我们打算在如下机器上部署mesos，需要保障集群中的机器能访问外网。
为了方便安装，我们采用yum的方式进行安装。如果需要可以自行编译
    bigdata03  master
    bigdata04  slave
    bigdata05  slave
```
一、修改机器信息
```
0.关闭selinux
    sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
    setenforce 0

1.关闭防火墙
    分开命令
    systemctl stop firewalld.service
    systemctl disable firewalld.service
    或组合命令
    systemctl stop firewalld && systemctl disable firewalld

2.禁用ipv6
    echo 1>/proc/sys/net/ipv6/conf/all/disable_ipv6
    echo 1>/proc/sys/net/ipv6/conf/default/disable_ipv6

3.设置电信dns
        查看网络连接
        nmcli connection show
        设置网络连接
        nmcli con mod eno16777736 ipv4.dns "114.114.114.114 8.8.8.8"
        nmcli con up eno16777736




4.修改密码
    passwd root
    密码修改为[自己的密码]

```

二、配置集群机器名称
```

1.修改机器名称
    a.重启机器生效的方法
        vim /etc/sysconfig/network
        写入 ：HOSTNAME=bigdata03
        重启机器：reboot -h now
        验证：hostname

    b.临时设置机器名称的方法（此方法重启机器后失效）

        echo bigdata03 > /proc/sys/kernel/hostname
        echo bigdata04 > /proc/sys/kernel/hostname
        echo bigdata05 > /proc/sys/kernel/hostname
    c.不用重启机器就能看到修改的办法(推荐使用)
     hostnamectl --static set-hostname bigdata03
     hostnamectl --static set-hostname bigdata04
     hostnamectl --static set-hostname bigdata05

2.配置hosts文件：为了使用机器名称而不用使用IP
    vim /etc/hosts
    写入
        10.100.134.1 gateway
        10.100.134.2 cluster
        10.100.134.3 bigdata03
        10.100.134.4 bigdata04
        10.100.134.5 bigdata05
        10.100.134.6 bigdata06
    分发配置文件
        scp /etc/hosts bigdata04:/etc/hosts
        scp /etc/hosts bigdata05:/etc/hosts
        scp /etc/hosts bigdata06:/etc/hosts
```

三、配置集群的免密登陆
```
配置集群免密登陆
各个机器上生产新的秘钥
    rm -rf /root/.ssh/*
    ssh-keygen -t rsa
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

汇聚到bigdata03
    ssh-copy-id -i  bigdata03

分发到其他机器
    scp /root/.ssh/authorized_keys bigdata04:/root/.ssh/
    scp /root/.ssh/authorized_keys bigdata05:/root/.ssh/
    scp /root/.ssh/authorized_keys bigdata06:/root/.ssh/
```


