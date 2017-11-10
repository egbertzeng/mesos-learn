
### 一、Java部署的原因
```
我们想通过mesos来管理Java编写的微服务，因此我们需要安装Java。
同时也为后面mesos管理大数据应用提供runtime。所以Java必须安装。

```

### 二、Java部署的方法
```
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
```
### 三、 配置环境变量
```
  配置环境变量
     vim ~/.bashrc
     写入
        export JAVA_HOME=/cloudstar/software/jdk1.8.0_144
        PATH=${JAVA_HOME}/bin:/bin:/usr/bin:/sbin:/usr/sbin:$PAHT:

    分发环境变量
        scp  ~/.bashrc   bigdata04:~/.bashrc
        scp  ~/.bashrc   bigdata05:~/.bashrc

    刷新环境变量
        source ~/.bashrc


```

### 四、 验证Java部署成功
```
在集群中的任意机器上执行如下命令，将得到诸如下方的回显
命令：
    java -version
回显：
    java version "1.8.0_74"
    Java(TM) SE Runtime Environment (build 1.8.0_74-b02)
    Java HotSpot(TM) 64-Bit Server VM (build 25.74-b02, mixed mode)

```