#!/bin/bash -e

docker_img=$1
echo $docker_img
shift
docker run --workdir /mnt/bundle --rm -it --mount type=bind,source=$PWD,target=/mnt/bundle $docker_img /mnt/bundle/create-bundle.sh $@

