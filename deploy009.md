### 一、修改marathon的默认端口   
```
因为marathon的默认端口是8080，我们自己的服务端口也是8080因此需要改动，
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
```  
### 二、验证修改marathon的默认端口   
```
    访问如下界面应该能访问到
    marathon界面：   http://10.100.134.3:8081
```
