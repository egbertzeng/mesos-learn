### 一、docker部署原因
```$xslt
为了使用mesos+marathon管理docker微服务，我们需要补水docker。为了简单起见我们还是以yum的方式进行部署。
凡是需要运行容器的地方都要部署docker。

    bigdata03  master
    bigdata04  slave
    bigdata05  slave

```
### 二、docker部署方法
```$xslt
    0.升级
    	yum -y update 
    1.安装：
        yum-config-manager  --add-repo https://download.docker.com/linux/centos/docker-ce.repo  
		yum makecache fast  
		yum -y install docker-ce 
    2. 启动&开机自启动
        systemctl start docker
        systemctl enable docker
    3.重置加速镜像
        echo {"registry-mirrors": ["http://hub-mirror.c.163.com","https://docker.mirrors.ustc.edu.cn"]} >> /etc/docker/daemon.json
    4.重启docker服务
		systemctl restart docker

```

### 三、测试docker部署成功
```$xslt
执行命令
    docker run hello-world
    
回显如下：
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    
    To generate this message, Docker took the following steps:
     1. The Docker client contacted the Docker daemon.
     2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
     3. The Docker daemon created a new container from that image which runs the
        executable that produces the output you are currently reading.
     4. The Docker daemon streamed that output to the Docker client, which sent it
        to your terminal.
    
    To try something more ambitious, you can run an Ubuntu container with:
     $ docker run -it ubuntu bash
    
    Share images, automate workflows, and more with a free Docker ID:
     https://cloud.docker.com/
    
    For more examples and ideas, visit:
     https://docs.docker.com/engine/userguide/
```
### 四、参考链接
```$xslt
如果要开启docker远程访问，可以参考如下链接
http://blog.csdn.net/faryang/article/details/75949611
http://blog.csdn.net/wangfei0904306/article/details/62046753
```

