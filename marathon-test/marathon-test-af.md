
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
* [marathon-jsons-file](action/f/telecomapistore-portal-service.json)

5.如果不用第4步也可以人肉部署仓库中的镜像
    docker pull 10.100.134.3:5000/telecomapistore/portal-service
    docker kill portal-service
    docker rm  portal-service
    docker run -d -p 31111:80 --name  portal-service  10.100.134.3:5000/telecomapistore/portal-service

==================================================================
二、部署marketing/portal-service的方案
==================================================================
1.编译前端代码到dist
    npm build

2.将dist打包成docker镜像
    docker-compose build

3.推送镜像到私用仓库
    docker tag marketing/portal-service  10.100.134.3:5000/marketing/portal-service
    docker push 10.100.134.3:5000/marketing/portal-service
4.用marathon拉取仓库中的镜像，并部署到集群中
* [marathon-jsons-file](action/f/marketing-portal-servic.json)
5.如果不用第4步也可以人肉部署仓库中的镜像（参考其他镜像的人肉部署方式）
