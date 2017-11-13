### 一、mesos部署
```
参考链接如下：
    http://www.linuxidc.com/Linux/2017-03/141478.htm
    http://www.xuliangwei.com/xubusi/422.html
    http://www.mamicode.com/info-detail-1948163.html
    http://www.cnblogs.com/ee900222/p/docker_2.html
    https://www.zwbing.com/80.html
    http://blog.csdn.net/felix_yujing/article/details/51813224
    
集群规划
    bigdata03  mesos-master  mesos-slave marathon  chronos
    bigdata04  mesos-slave
    bigdata05  mesos-slave
```


###  二、安装mesos-mater
```
1.安装mesosphere
    rpm -ivh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
    yum -y install mesos marathon chronos
2.配置zookeeper
    编辑命令
     vim /etc/mesos/zk
    编辑内容
     zk://bigdata03:2181,bigdata04:2181,bigdata05:2181/mesos
3.启动服务&开机启动

    systemctl start  mesos-master mesos-slave marathon chronos
    systemctl enable mesos-master mesos-slave marathon chronos
    
    systemctl stop    mesos-master mesos-slave marathon chronos
    systemctl disable mesos-master mesos-slave marathon chronos
4.验证启动，webui
    mesos界面：      http://10.100.134.3:5050
    marathon界面：   http://10.100.134.3:8080
    chronos界面：   http://10.100.134.3:4400
```

###  三、安装mesos-slave
```
1.安装mesosphere
    rpm -ivh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
    yum -y install mesos
2.配置zookeeper
    vim /etc/mesos/zk
    zk://bigdata03:2181,bigdata04:2181,bigdata05:2181/mesos
3.启动服务&开机启动
    systemctl start  mesos-slave mesos-master
    systemctl enable mesos-slave mesos-master
```
       
###  四、运行Mesos任务，可以在Web界面查看task
```
    MASTER=$(mesos-resolve `cat /etc/mesos/zk`)
    mesos-execute --master=$MASTER --name="cluster-test" --command="sleep 60"
```

### 五、mesos的重要目录  
```
    1.环境变量目录
        /usr/etc/mesos 
    2.执行目录
        /var/run/mesos
    3.日志目录
        /var/log/mesos
    4.配置启动参数配置目录： 
        /etc/mesos-master/ 
        /etc/mesos-slave/ 
        /etc/marathon/conf/ 
        在这些目录分别用来配置mesos-master，mesos-slave，marathon的启动参数。
        以参数名为文件名，参数值为文件内容即可。
    4.服务将被连接到如下path
       /etc/systemd/system/multi-user.target.wants
```
### 六、诊断命令
```
    查看mesos-slave运行状态
        journalctl -f -u  mesos-slave
    
    查看进程运行状态
        systemctl status -l zookeeper
        systemctl status -l mesos-master
        systemctl status -l mesos-slave
        systemctl status -l marathon
```