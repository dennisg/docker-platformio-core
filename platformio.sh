#!/bin/bash

VOLUME_CONTAINER_NAME=vc_platformio
VOLUME_CONTAINER_IMAGE=sglahn/vc_platformio:latest
IMAGE_NAME=sglahn/platformio-core:3.4.0

if [ ! "$(docker ps -a | grep $VOLUME_CONTAINER_NAME)" ]; then
    docker run -u `id -u $USER`:`id -g $USER` --name $VOLUME_CONTAINER_NAME $VOLUME_CONTAINER_IMAGE
fi

DEVICE=
if [ -e /dev/ttyUSB0 ]; then
    DEVICE="--device=/dev/ttyUSB0"
fi
if [ "$UPLOAD_PORT" ]; then
    DEVICE=$UPLOAD_PORT
fi
echo "Using upload port $DEVICE"

docker run --rm \
    -v `pwd`:/workspace \
    --volumes-from=$VOLUME_CONTAINER_NAME \
    -u `id -u $USER`:`id -g $USER` \
    $DEVICE \
    $IMAGE_NAME \
    $@
