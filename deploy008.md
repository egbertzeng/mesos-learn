一、配置mesos-master和marathon的高可用
```
参考链接
http://heqin.blog.51cto.com/8931355/1712426

1.配置主机名称   
    bigdata03执行
        echo 2 > /etc/mesos-master/quorum
        echo 10.100.134.3 > /etc/mesos-master/hostname
        echo 10.100.134.3 > /etc/mesos-master/ip
        mkdir -p /etc/marathon/conf
        echo 10.100.134.3 > /etc/marathon/conf/hostname
    bigdata04执行
        echo 2 > /etc/mesos-master/quorum
        echo 10.100.134.4 > /etc/mesos-master/hostname
        echo 10.100.134.4 > /etc/mesos-master/ip
        mkdir -p /etc/marathon/conf
        echo 10.100.134.4 > /etc/marathon/conf/hostname
    bigdata05执行
        echo 2 > /etc/mesos-master/quorum
        echo 10.100.134.5 > /etc/mesos-master/hostname
        echo 10.100.134.5 > /etc/mesos-master/ip
        mkdir -p /etc/marathon/conf
        echo 10.100.134.5 > /etc/marathon/conf/hostname
2.配置mesos集群的标识名称（所有机器上执行）
    echo bigdata-mesos-cluster1 > /etc/mesos-master/cluster 
3.配置marathon和mesos-master高可用的zookeeper信息
    cp  /etc/mesos/zk   /etc/marathon/conf/master
    cp  /etc/mesos/zk   /etc/marathon/conf/zk
    sed -i  's|mesos|marathon|g'   /etc/marathon/conf/zk
4.重启集群
    
    rm -rf /var/lib/mesos/meta
    systemctl stop  mesos-slave mesos-master marathon chronos
    systemctl start mesos-slave mesos-master marathon chronos
    或者
    rm -rf /var/lib/mesos/meta
    systemctl restart  mesos-slave mesos-master marathon chronos
    systemctl enable   mesos-slave mesos-master marathon chronos

```

二、验证mesos-master和marathon的高可用
```
登录webui，能够看到mesos和marathon的高可用信息
    mesos界面：      http://10.100.134.3:5050
    marathon界面：   http://10.100.134.3:8080
    chronos界面：   http://10.100.134.3:4400
```     
