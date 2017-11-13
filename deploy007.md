
##一、让mesos支持docker技术
```
    1.配置所有mesos-slave
        echo 'docker,mesos' | tee /etc/mesos-slave/containerizers
        echo 'docker' | tee /etc/mesos-slave/image_providers
        echo '10mins' > /etc/mesos-slave/executor_registration_timeout
        echo 'filesystem/linux,docker/runtime,cgroups/cpu,cgroups/mem' | tee /etc/mesos-slave/isolation
        echo '/var/run/docker.sock' | tee /etc/mesos-slave/docker_socket
        echo 'docker' | tee /etc/mesos-slave/containerizers
       
       
        echo 'system.slice/mesos-slave.service' > /etc/mesos-slave/cgroups_root
        echo '/sys/fs/cgroup' > /etc/mesos-slave/cgroups_hierarchy

    2.重启所有mesos-slave
        systemctl restart mesos-slave
        systemctl restart mesos-master

        systemctl start mesos-slave
        rm -rf /etc/mesos-slave/containerizers
        rm -rf /etc/mesos-slave/executor_registration_timeout
        rm -rf /etc/mesos-slave/isolation
```

### 二、让定制mesos资源分配（解决mesos默认[31000-32000]端口分配的限制）
```
微服务需要有更广泛的端口分配机制，默认端口分配方案不足以完成微服务的架构，
因此必须进行mesos的端口开放
    可以参考
    http://mesos.apache.org/documentation/attributes-resources/
    http://blog.csdn.net/zhao4471437/article/details/52910200
1.防止冲突所有slave节点删除原来的meta数据
    rm -rf /var/lib/mesos/meta
2.编辑配置文件
   mkdir -p /etc/mesos-slave-data/
   vim /etc/mesos-slave-data/resources.conf
   内容如下：
    [
     {
       "name": "ports",
       "type": "RANGES",
       "ranges": {
         "range": [
           {
             "begin": 21000,
             "end": 24000
           },
           {
             "begin": 30000,
             "end": 64000
           }
         ]
       }
     }
    ]

   
3.分发配置
    scp /etc/mesos-slave-data/resources.conf bigdata04:/etc/mesos-slave-data/resources.conf
    scp /etc/mesos-slave-data/resources.conf bigdata05:/etc/mesos-slave-data/resources.conf
   
4.将配置文件应用到mesos-slave
    echo 'file:///etc/mesos-slave-data/resources.conf'>/etc/mesos-slave/resources
    rm -rf /etc/mesos-slave/resources

5.重启服务meoso-slave
    如果要让配置生效，需要重启进程
    systemctl stop mesos-slave
    systemctl start mesos-slave
    或命令
    systemctl restart mesos-slave
   
    可以清空遗留的信息，而后启动mesos
    rm -rf /var/lib/mesos/meta
    systemctl restart  mesos-master mesos-slave marathon chronos
```

