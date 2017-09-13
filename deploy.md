
####################################################################################################################################
一、修改机器信息
####################################################################################################################################
0.关闭selinux
    sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
    setenforce 0

0.关闭防火墙
    systemctl stop firewalld.service 
    systemctl disable firewalld.service 
    或组合命令
    systemctl stop firewalld && systemctl disable firewalld
    
    禁用ipv6
    echo 1>/proc/sys/net/ipv6/conf/all/disable_ipv6
    echo 1>/proc/sys/net/ipv6/conf/default/disable_ipv6
    
    设置电信dns
        查看网络连接
        nmcli connection show
        设置网络连接
        nmcli con mod eno16777736 ipv4.dns "114.114.114.114 8.8.8.8"
        nmcli con up eno16777736
        
1.修改密码
    passwd root
    密码修改为12345678

2.修改机器名称
    vim /etc/sysconfig/network
    写入 ：HOSTNAME=bigdata03
    重启机器：reboot -h now 
    验证：hostname 

    此语句重启无效
    echo bigdata03 > /proc/sys/kernel/hostname
    echo bigdata04 > /proc/sys/kernel/hostname
    echo bigdata05 > /proc/sys/kernel/hostname
 

    不用重启机器就能看到修改的办法
     hostnamectl --static set-hostname bigdata03
     hostnamectl --static set-hostname bigdata04
     hostnamectl --static set-hostname bigdata05

3.配置hosts文件
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


4.配置集群免密登陆
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


####################################################################################################################################
二、Java部署
####################################################################################################################################

下载目录
/cloudstar/software
下载jdk
    wget http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz

解压JDK
	tar -zxvf jdk-8u144-linux-x64.tar.gz
	
创建软件目录
	mkdir -p /cloudstar/software/
分发JDK
    
    scp -r jdk1.8.0_144 bigdata04:/cloudstar/software/
    scp -r jdk1.8.0_144 bigdata05:/cloudstar/software/

  配置环境变量
     vim ~/.bashrc 
     写入
export JAVA_HOME=/cloudstar/software/jdk1.8.0_144
export ZOOKEEPER_HOME=/cloudstar/software/zookeeper-3.4.10
PATH=${JAVA_HOME}/bin:${ZOOKEEPER_HOME}/bin:/bin:/usr/bin:/sbin:/usr/sbin:$PAHT:

    分发环境变量
        scp  ~/.bashrc   bigdata04:~/.bashrc 
        scp  ~/.bashrc   bigdata05:~/.bashrc 
            
    刷新环境变量
    source ~/.bashrc 

验证安装成功
        命令：java -version
        回显：
        java version "1.8.0_74"
        Java(TM) SE Runtime Environment (build 1.8.0_74-b02)
        Java HotSpot(TM) 64-Bit Server VM (build 25.74-b02, mixed mode)


####################################################################################################################################
三、zookeeper部署
####################################################################################################################################

规划和策略：
    bigdata03,bigdata04,bigdata05，上部署zookeeper
    在bigdata03上配置，配置完成后发送到其他机器上
下载zookeeper
    wget http://apache.fayea.com/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz
解压zookeeper
     tar -zxvf zookeeper-3.4.10.tar.gz

配置环境变量
 vim ~/.bashrc 
 写入
	ZOOKEEPER_HOME=/cloudstar/software/zookeeper-3.4.10
	PATH=$ZOOKEEPER_HOME/bin$PATH:
 刷新环境变量
 source ~/.bashrc 
分发环境变量
    scp  ~/.bashrc   bigdata04:~/.bashrc 
    scp  ~/.bashrc   bigdata05:~/.bashrc 


配置zookeeper
    1.修改配置文件
         cd  ${ZOOKEEPER_HOME}/conf
         cp zoo_sample.cfg zoo.cfg
         vim ${ZOOKEEPER_HOME}/conf/zoo.cfg
         修改项如下：
         a.指定数据文件的存放位置(同步数据存放的位置)
             dataDir=/cloudstar/software/zookeeper-3.4.10/data
         b.增加zookeeper节点：(配置如下信息)
            server.3=bigdata03:2888:3888
            server.4=bigdata04:2888:3888
            server.5=bigdata05:2888:3888
           （2888:数据传输端口,3888:leader和flower的选举端口    ）
    2.创建文件夹和文件
            mkdir /cloudstar/software/zookeeper-3.4.10/data
            echo  3 > /cloudstar/software/zookeeper-3.4.10/data/myid
分发zookeeper
    scp -r zookeeper-3.4.10 bigdata04:/cloudstar/software/
    scp -r zookeeper-3.4.10 bigdata05:/cloudstar/software/

修改对应机器上的id
    echo  4 > $ZOOKEEPER_HOME/data/myid
    echo  5 > $ZOOKEEPER_HOME/data/myid
zookeeper常用命令
    ${ZOOKEEPER_HOME}/bin/zkServer.sh start
    ${ZOOKEEPER_HOME}/bin/zkServer.sh status

    ${ZOOKEEPER_HOME}/bin/zkServer.sh stop
    ${ZOOKEEPER_HOME}/bin/zkServer.sh restart
查看zookeeper日志
    more ${ZOOKEEPER_HOME}/bin/zookeeper.out



####################################################################################################################################
四、docker部署
####################################################################################################################################
安装docker
http://blog.csdn.net/wangfei0904306/article/details/62046753
    1.升级
    	yum -y update 
    1.安装：
        yum-config-manager  --add-repo https://download.docker.com/linux/centos/docker-ce.repo  
		yum makecache fast  
		yum -y install docker-ce 
    2. 启动&开机自启动
        systemctl start docker
        systemctl enable docker
    3.重置加速镜像
		vim  /etc/docker/daemon.json
{"registry-mirrors": ["http://hub-mirror.c.163.com","https://docker.mirrors.ustc.edu.cn"]}

echo {"registry-mirrors": ["http://hub-mirror.c.163.com","https://docker.mirrors.ustc.edu.cn"]} >> /etc/docker/daemon.json

    4.重启docker服务
		systemctl restart docker
    5.测试最小镜像
        docker run hello-world


如果要开启docker远程访问，可以参考如下链接
http://blog.csdn.net/faryang/article/details/75949611
####################################################################################################################################
五、docker私有仓库
####################################################################################################################################

一、搭建docker私有仓库
    1.安装并启动docker
        yum -y install docker.io

    2.下载registry镜像
        docker pull registry

    3.服务端使用http协议
        vim /etc/sysconfig/docker
        添加内容如下：
other_args="--selinux-enabled --insecure-registry 10.100.134.2:5000"

    4.docker常用命令
        service docker restart
        service docker start

    5.启动registry镜像
        docker run -d -p 5000:5000  --restart=always  -v /opt/registry:/tmp/registry  registry

        参数说明：
        -v /opt/registry:/tmp/registry :默认情况下，会将仓库存放于容器内的/tmp/registry目录下，指定本地目录挂载到容器
        此容器要用 docker stop 进行停止
    6.测试仓库运行地址
        浏览地址： http://10.100.134.2:5000/v2/_catalog
        效果示例： {"repositories":[]}

二、测试私有仓库
    1.本地使用http
        在mac中通过docker-tools来设置如下参数
        {
            "insecure-registries": [
                "10.100.134.2:5000"
            ]
        }
    2.本地下载
        docker pull busybox

    3.本地tag
        docker tag busybox 10.100.134.2:5000/busybox

    4.本地查看image
        docker images

    5.上传到私有仓库
        docker push 10.100.134.2:5000/busybox

    6.验证上传成功
        浏览地址： http://10.100.134.2:5000/v2/_catalog
        效果样例： {"repositories":["busybox"]}

三、可能出现的错误
    1.错误提示
        http: server gave HTTP response to HTTPS client
    2.错误原因
        docker repository默认使用https协议进行通信，一般情况下我们用http协议可以满足要求。
        所以只要在server和client任何一方导致的协议不一致都会出现类似的问题。
    3.解决方法
        server端使用http协议
        client端使用http协议








测试私有仓库是否可用
    docker pull hello-world
    docker tag hello-world 10.100.134.3:5000/hello-world
    docker push 10.100.134.3:5000/hello-world

如果出现如下错误
    http: server gave HTTP response to HTTPS client
解决方法如下：
    1.修改配置文件
        vim /etc/docker/daemon.json
        填写如下内容
{
    "registry-mirrors": ["http://hub-mirror.c.163.com","https://docker.mirrors.ustc.edu.cn","10.100.134.3:5000","10.100.134.2:5000"],
    "insecure-registries":["10.100.134.3:5000","10.100.134.2:5000"]
}

    2.分发配置文件
        scp /etc/docker/daemon.json  bigdata03:/etc/docker/daemon.json
        scp /etc/docker/daemon.json  bigdata05:/etc/docker/daemon.json
    3.重启docker服务
        systemctl restart docker
    4.测试是否成功
        测试命令：
        curl http://10.100.134.3:5000/v2/_catalog
        curl http://10.100.134.3:5000/v2/registry/tags/list
        返回结果：
        {"repositories":["hello-world"]}

####################################################################################################################################
六、mesos部署
####################################################################################################################################
参考链接如下：
    http://www.linuxidc.com/Linux/2017-03/141478.htm
    http://www.xuliangwei.com/xubusi/422.html
    http://www.mamicode.com/info-detail-1948163.html
    http://www.cnblogs.com/ee900222/p/docker_2.html
    https://www.zwbing.com/80.html
    http://blog.csdn.net/felix_yujing/article/details/51813224
零、集群规划

	bigdata03  mesos-master  mesos-slave marathon  chronos
	bigdata04  mesos-slave
	bigdata05  mesos-slave
一、安装mesos-mater
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
二、安装mesos-slave
    1.安装mesosphere
        rpm -ivh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
        yum -y install mesos
    2.配置zookeeper
        vim /etc/mesos/zk
        zk://bigdata03:2181,bigdata04:2181,bigdata05:2181/mesos
    3.启动服务&开机启动
        systemctl start  mesos-slave mesos-master
        systemctl enable mesos-slave mesos-master
       
三、运行Mesos任务，可以在Web界面查看task
    MASTER=$(mesos-resolve `cat /etc/mesos/zk`)
    mesos-execute --master=$MASTER --name="cluster-test" --command="sleep 60"

四、让mesos支持docker技术
    1.配置所有mesos-slave
        echo 'docker,mesos' | tee /etc/mesos-slave/containerizers
        echo 'docker' | tee /etc/mesos-slave/image_providers
        echo '10mins' > /etc/mesos-slave/executor_registration_timeout
        echo 'filesystem/linux,docker/runtime,cgroups/cpu,cgroups/mem' | tee /etc/mesos-slave/isolation
        echo '/var/run/docker.sock' | tee /etc/mesos-slave/docker_socket
       
        echo 'system.slice/mesos-slave.service' > /etc/mesos-slave/cgroups_root
        echo '/sys/fs/cgroup' > /etc/mesos-slave/cgroups_hierarchy

    2.重启所有mesos-slave
        systemctl restart mesos-slave
        systemctl restart mesos-master

        systemctl start mesos-slave
        rm -rf /etc/mesos-slave/containerizers
        rm -rf /etc/mesos-slave/executor_registration_timeout
        rm -rf /etc/mesos-slave/isolation

五、让定制mesos资源分配（解决mesos默认[31000-32000]端口分配的限制）
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
    
    
    rm -rf /var/lib/mesos/meta
    systemctl restart  mesos-master mesos-slave marathon chronos



六、重要目录  
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


七、诊断命令
    查看mesos-slave运行状态
        journalctl -f -u  mesos-slave
    
    查看进程运行状态
    systemctl status -l zookeeper
    systemctl status -l mesos-master
    systemctl status -l mesos-slave
    systemctl status -l marathon
++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++
八、配置mesos-master和marathon的高可用
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
++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++
九、修改marathon的默认端口     
Marathon WebUI默认的端口是8080，修改端口的方法：
1.编辑配置文件
    编辑命令
        vim /etc/default/marathon
    添加内容
        export HTTP_PORT=8081
        export MARATHON_HTTP_PORT=8081
2.分发配置文件
    scp /etc/default/marathon bigdata04:/etc/default/marathon
    scp /etc/default/marathon bigdata05:/etc/default/marathon

3.重启marathon
    systemctl stop marathon 
    systemctl start marathon 
    systemctl status marathon   
 ++++++++++++++++++++++++++++++++++++++++
 ++++++++++++++++++++++++++++++++++++++++ 
 
 九、配置marathon-lb
 https://github.com/mesosphere/marathon-lb
 http://www.cnblogs.com/Bourbon-tian/p/7151840.html
 http://www.cnblogs.com/hahp/p/5396302.html
 https://baijiahao.baidu.com/s?id=1569673434470905&wfr=spider&for=pc
 1.下载镜像
    docker pull mesosphere/marathon-lb
 2.编写marathon文件，在marathon上运行marathon-lb
    * [marathon-lb.json](marathon-test/deploy/marathon-lb.json)
 
 3.部署httpd到marathon，并让marathon-lb负载
     * [docker_httpd.json](marathon-test/deploy/docker_httpd.json)

 4.部署Nginx，并让marathon-lb负载
     * [docker_nginx.json](marathon-test/deploy/docker_nginx.json)

 5.部署前端项目，并让marathon-lb负载
   参加项目的Marathon.json
   主要注意点为

   ```
    1.Marathon.json中的labels配置
    "labels": {
      "HAPROXY_GROUP": "external",
      "HAPROXY_0_VHOST": "httpd.marathon.mesos"
    },
       
    2.servicePort被负载到MLB节点上
      原来的entrypoint=appHostIp+appHostPort
      负载后entrypoint=MLBHostIp+appServicePort
   ```
   
   ++++++++++++++++++++++++++++++++++++++++
   ++++++++++++++++++++++++++++++++++++++++
   ++++++++++++++++++++++++++++++++++++++++  
     
     

     
     
    默认使用网卡
    eth0
    http://blog.csdn.net/fanhonooo/article/details/53494100
    http://mesos.apache.org/documentation/latest/configuration/
    
    
    
    
    mesos博客文章
    https://mp.weixin.qq.com/s?__biz=MzA3MDg4Nzc2NQ==&mid=2652134190&idx=1&sn=a36f54ec6c0a30ed781f604628840584&mpshare=1&scene=23&srcid=0829czSyxQmvPxs1jQKweNTS#rd
    
    
    部署inflexdb等
    http://www.jianshu.com/p/d078d353d12f
    
    
    
    
    测试chronos
    http://www.cnblogs.com/ee900222/p/docker_2.html
    * [chronos-test.json](chronos/chronos-test.json)




++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++  
 
 

echo 8081 > /etc/marathon/conf/port
systemctl restart marathon 
systemctl status marathon 
 
 
 
rm -rf /etc/marathon/conf/port
systemctl restart marathon 
systemctl status marathon 


rm -rf /etc/sysconfig/marathon
mkdir -p /etc/sysconfig/marathon/
echo port=8081 > /etc/sysconfig/marathon
