
### 一、zookeeper部署的原因
```
我们后续想通过zookeeper来实现mesos的master节点的HA(High Available)
因此必须安装zookeeper。当然zookeeper在大数据生态圈中作用广泛。像Hadoop，
Hbase,spark,kafka,flink等分布式系统都依赖zookeeper来做集群的状态管理。
因此zookeeper算是一种基础的组件。
```
### 二、zookeeper集群的规划
```
规划：
    我们将计划在如下机器上部署zookeeper
    bigdata03
    bigdata04
    bigdata05

策略：
    在bigdata03上配置，配置完成后发送到其他机器上
```

### 三、zookeeper部署的方法
```
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
```

### 四、zookeeper的配置
```
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
3.分发zookeeper
    scp -r zookeeper-3.4.10 bigdata04:/cloudstar/software/
    scp -r zookeeper-3.4.10 bigdata05:/cloudstar/software/

4.修改对应机器上的id
    echo  4 > $ZOOKEEPER_HOME/data/myid
    echo  5 > $ZOOKEEPER_HOME/data/myid
5.zookeeper常用命令
    ${ZOOKEEPER_HOME}/bin/zkServer.sh start
    ${ZOOKEEPER_HOME}/bin/zkServer.sh status

    ${ZOOKEEPER_HOME}/bin/zkServer.sh stop
    ${ZOOKEEPER_HOME}/bin/zkServer.sh restart
6.查看zookeeper日志
    more ${ZOOKEEPER_HOME}/bin/zookeeper.out

```

