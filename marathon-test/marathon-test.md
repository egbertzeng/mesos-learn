
#####################################################################################################################
一、marathon最简单的hello world应用
要求：
  部署一个打印语句,输出将在stdout的日志中查看
方案：
* [marathon-json-file](jsons/test001.json)

#####################################################################################################################
二、marathon部署http版的hello world应用
要求：
  用nc命令启动一个HTTP服务
1.在各节点上安装netcat
    yum install nmap-ncat
2.在Marathon页面，点击“Create Application”创建任务
* [marathon-json-file](jsons/test002.json)
3.根据Marathon页面提供的端口
    命令
    curl http://bigdata03:31979
    返回
    Hello World 

#####################################################################################################################

三、marathon部署一套Nginx环境
要求：
Marathon有自己的REST API，我们通过API的方式来创建一个Nginx的Docker容器。

方案：
首先创建如下的配置文件nginx.json
* [marathon-json-file](jsons/nginx.json)
通过marathon提供的端口能访问Nginx默认页面
#####################################################################################################################
四、marathon部署一套Tomcat环境（精简代码）
1.要求：
  成功部署Tomcat
2.实现：
    * [marathon-json-file](jsons/tomcat.json)
3.测试：
    通过marathon提供的端口能访问tomcat默认页面

#####################################################################################################################
五、marathon部署一套pyhton3的web程序
1.要求：
  成功部署pyhton3的web程序
2.实现：
    * [marathon-json-file](jsons/python3.json)
3.测试：
    通过marathon提供的端口能访问tomcat默认页面
 
#####################################################################################################################
六、用marathon部署一个ubuntu应用
要求：
   用marathon部署一个ubuntu应用，每一秒向mesos的sandbox输出一次当前时间
方案：
    * [marathon-json-file](jsons/ubuntu.json)
    
测试：能在mesos中查看相应输出的时间

#####################################################################################################################
七、marathon部署一个docker register
1.要求：
  成功部署一个docker register
  暂时还不能实现重启容器数据不丢
2.实现：
    * [marathon-json-file](registory-docker/Marathon.json)
3.测试：
    通过marathon提供的端口能访问仓库内容
    http://bigdata03:31000/v2/_catalog
 

#####################################################################################################################
八、marathon部署一套最简单的前端程序
1.要求：
  成功部署一个index.html到Nginx
2.实现：
    * [参考](first-portal)
    * [marathon-json-file](first-portal/Marathon.json)
3.测试：
    通过marathon提供的端口能访问index.html
 

#####################################################################################################################
九、marathon部署一个springboot应用
1.要求：
  成功部署一个springboot应用
2.实现：
    1.实现一个springboot的程序
    2.将其打包成docker image 并上传到私有镜像
    3.使用marathon成功部署
3.参考：
    bigdata-common中的basic-test-service应用
4.测试：
    访问：
    http://bigdata04:31011/hi
    返回：
    hello marathon! this msg come from spring boot basic-test-service!
    
 










