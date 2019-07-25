#!/usr/bin/env bash
app_container_name=image_frontend
app_image_name=image_frontend
backend_container_name=image_backend

container_already_exists="$(sudo docker container ls -a | grep ${app_container_name})"
if [[ "${container_already_exists}" ]];
then
    echo "container ${app_container_name} already exists, it will be deleted"
    sudo docker container stop ${app_container_name}
    sudo docker container rm ${app_container_name}
fi

image_already_exists="$(docker images ls | grep ${app_image_name})"
if [[ "${image_already_exists}" ]];
then
     echo "image ${app_image_name} already exists"
     sudo docker rmi ${app_image_name}
     sudo docker rmi $(docker images -q -f dangling=true)
fi


sudo docker build -t ${app_image_name} .

sudo docker run \
--name ${app_container_name} \
-d \
-p 8088:80 \
${app_image_name}
