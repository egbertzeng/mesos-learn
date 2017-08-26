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











**************************
**************************
**************************
**************************
**************************



