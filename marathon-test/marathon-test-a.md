
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################

####################################################################################################################################
一、大数据产品线前端部署方案
####################################################################################################################################

==================================================================
一、部署telecomapistore/portal-service的方案
==================================================================

1.编译前端代码到dist
    npm build

2.将dist打包成docker镜像
    docker-compose build

3.推送镜像到私用仓库
    docker tag telecomapistore/portal-service  10.100.134.3:5000/telecomapistore/portal-service
    docker push 10.100.134.3:5000/telecomapistore/portal-service

4.用marathon拉取仓库中的镜像，并部署到集群中
{
    "id":"/telecomapistore/portal-service",
    "cpus":0.6,
    "mem":600.0,
    "instances": 3,
    "constraints": [["hostname","UNIQUE",""]],
    "container": {
        "type":"DOCKER",
        "docker": {
            "image": "10.100.134.3:5000/telecomapistore/portal-service",
            "network": "BRIDGE",
            "forcePullImage": true,
            "portMappings": [{"containerPort": 80, "hostPort": 31111,"servicePort": 0, "protocol": "tcp" }]  
          }
    } 
}

5.如果不用第4步也可以人肉部署仓库中的镜像
    docker pull 10.100.134.3:5000/telecomapistore/portal-service
    docker kill portal-service
    docker rm  portal-service
    docker run -d -p 31111:80 --name  portal-service  10.100.134.3:5000/telecomapistore/portal-service

==================================================================
二、部署telecomapistore/portal-service的方案
==================================================================
1.编译前端代码到dist
    npm build

2.将dist打包成docker镜像
    docker-compose build

3.推送镜像到私用仓库
    docker tag marketing/portal-service  10.100.134.3:5000/marketing/portal-service
    docker push 10.100.134.3:5000/marketing/portal-service
4.用marathon拉取仓库中的镜像，并部署到集群中
{
    "id":"/marketing/portal-service",
    "cpus":0.6,
    "mem":600.0,
    "instances": 3,
    "constraints": [["hostname","UNIQUE",""]],
    "container": {
        "type":"DOCKER",
        "docker": {
            "image": "10.100.134.3:5000/marketing/portal-service",
            "network": "BRIDGE",
            "forcePullImage": true,
            "portMappings": [{"containerPort": 80, "hostPort": 31112,"servicePort": 0, "protocol": "tcp" }]  
          }
    } 
}
5.如果不用第4步也可以人肉部署仓库中的镜像（参考其他镜像的人肉部署方式）





####################################################################################################################################
二、大数据产品线后端部署方案
####################################################################################################################################
==================================================================
一、部署telecomapistore/portal-service的方案
==================================================================




从私有仓库部署到marathon

docker rmi telecomapistore/eureka-service -f
docker rmi 10.100.134.3:5000/telecomapistore/eureka-service -f
docker tag telecomapistore/eureka-service 10.100.134.3:5000/telecomapistore/eureka-service
docker push 10.100.134.3:5000/telecomapistore/eureka-service
docker pull 10.100.134.3:5000/telecomapistore/eureka-service



{
    "id":"/telecomapistore/eureka-service",
    "mem":256,
    "instances":1,
    "container":{
        "type":"DOCKER",
        "docker":{
           "network": "BRIDGE",
            "forcePullImage": true,
            "image":"10.100.134.3:5000/telecomapistore/eureka-service",
            "portMappings":[
                {
                    "containerPort":8761,
                    "hostPort":0,
                    "servicePort":0,
                    "protocol":"tcp",
                    "name":"http"
                }
            ]
        }
    },
    "env":{
        "spring.profiles.active":"dev",
        "ALL_SERVICE_RUN_HOST":"10.100.134.3",
        "EUREKA_SERVER_PORT":"8761"
    }
}






**************************
**************************
**************************
**************************
**************************








**************************
**************************
**************************
**************************
**************************








docker rmi telecomapistore/eureka-service -f
docker rmi 10.100.134.3:5000/telecomapistore/eureka-service -f
docker tag telecomapistore/eureka-service 10.100.134.3:5000/telecomapistore/eureka-service
docker push 10.100.134.3:5000/telecomapistore/eureka-service
docker pull 10.100.134.3:5000/telecomapistore/eureka-service

docker rm eureka-service
docker run -p 8761:8761 --name  eureka-service  10.100.134.3:5000/telecomapistore/eureka-service

docker rm eureka-service
docker run -p 31001:31001 --name  eureka-service  10.100.134.3:5000/telecomapistore/eureka-service




docker rmi 10.100.134.3:5000/telecomapistore/configuration-service
docker tag telecomapistore/configuration-service 10.100.134.3:5000/telecomapistore/configuration-service
docker push 10.100.134.3:5000/telecomapistore/configuration-service
docker pull 10.100.134.3:5000/telecomapistore/configuration-service


{
    "id":"/telecomapistore/configuration-service",
    "mem":256,
    "instances":1,
    "container":{
        "type":"DOCKER",
        "docker":{
            "network": "HOST",
            "forcePullImage": true,
            "image":"10.100.134.3:5000/telecomapistore/configuration-service",
            "portMappings":[
                {
                    "containerPort":0,
                    "hostPort":31888,
                    "servicePort":0,
                    "protocol":"tcp",
                    "name":"http"
                }
            ]
        }
    },
    "env":{
        "spring.profiles.active":"dev",
        "ALL_SERVICE_RUN_HOST":"10.100.134.3",
        "EUREKA_SERVER_PORT":"8761"
    }
}








{
  "id": "mysql",
  "cpus": 0.5,
  "mem": 64.0,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "ppc64le/mysql",
      "network": "BRIDGE",
      "portMappings": [
        { "containerPort": 3306, "hostPort": 0, "servicePort": 0, "protocol": "tcp" }
      ]
    }
  },
  "env": {
     "MYSQL_ROOT_PASSWORD" : "password",
     "MYSQL_USER" : "test",
     "MYSQL_PASSWORD" : "test",
     "MYSQL_DB" : "BucketList"
   }
}









