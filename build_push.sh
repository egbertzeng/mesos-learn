#!/bin/bash
#########################################
#author: liguohua
#email : liguohua@cloud-star.com.cn
#date  : 2017.08.22
#########################################

#一、定义相关变量
#1.需要改动的变量
_private_docker_registry_uri=10.100.134.3:5000
_project_name=telecomapistore
_module_names=(
               telecomapistore-portal-service
               marketing-portal-service
              )
###################################################
###################################################
###################################################
#2.无需改动的变量
_pwd=$PWD
_project_root_path=$_pwd
_docker_compose_root_path=$_pwd/docker
newLineSlash="################################################################################################################"
echo $newLineSlash
echo "PRESS(a or A)SWITCH AUTO MODE:automatic execute all commands "
read auto
flag='a'
function autoAction() {
    if [ "$auto" != "a" -a "$auto" != "A" ] ; then
        echo $newLineSlash
        echo $1
        read flag
    fi
}
#3.对每个module进行相关操作
for _module_name in ${_module_names[@]};do
    #4.module相关的变量
    _module_root_path=$_pwd/$_module_name
    _docker_image_name=$_project_name/$_module_name
    _docker_image_full_name=$_private_docker_registry_uri/$_docker_image_name

    #二、进行项目编译
    #1.npm build
    autoAction "PRESS(s or S) SKIP: npm build : $_module_name"
    msg="=======1.skip npm build : $_module_name======="
    if [ "$flag" = "s" -o "$flag" = "S" ] ; then
       echo $msg
    else
       echo $msg
       cd $_module_root_path
       npm run build
    fi

    #2.docker build
    autoAction "PRESS(s or S) SKIP: docker build : $_module_name"
    msg="=======2.skip docker build : $_module_name======="
    if [ "$flag" = "s" -o "$flag" = "S" ] ; then
        echo $msg
    else
        echo $msg
        cd $_module_root_path
        docker build -t $_docker_image_full_name .
    fi

    #3.docker push
    autoAction "PRESS(s or S) SKIP: docker push : $_module_name"
    msg="=======3.skip docker push : $_module_name======="
    if [ "$flag" = "s" -o "$flag" = "S" ] ; then
        echo $msg
    else
        echo $msg
        docker push $_docker_image_full_name
    fi
    echo "=======4.docker push $_docker_image_full_name finished!======="
done
echo "=======project push $_project_name finished!======="
