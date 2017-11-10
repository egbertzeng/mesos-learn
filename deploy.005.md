### 一、docker私有仓库部署原因
```$xslt
我们要有一个统一的地方来完成对docker镜像的管理。docker社区提供的docker-register是一个不错的工具。现在我们先尽快的将
环境建设起来，如果考虑后续的企业级应用可以考虑使用habor进行替换。敬请关注后续关于habor的文章
```

### 二、搭建docker私有仓库
```$xslt
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
```

###  三、测试私有仓库
```$xslt
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
```
 
### 四、测试私有仓库是否可用
```$xslt
测试私有仓库是否可用
    docker pull hello-world
    docker tag hello-world 10.100.134.3:5000/hello-world
    docker push 10.100.134.3:5000/hello-world
```

###  五、可能出现的错误
```$xslt
    1.错误提示
        http: server gave HTTP response to HTTPS client
    2.错误原因
        docker repository默认使用https协议进行通信，一般情况下我们用http协议可以满足要求。
        所以只要在server和client任何一方导致的协议不一致都会出现类似的问题。
    3.解决方法
        server端使用http协议
        client端使用http协议
        
    4.解决方法如下：
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
```










