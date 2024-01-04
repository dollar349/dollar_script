#!/bin/bash

source ~/sandbox/conf/LOCAL.conf
if [ "$(type -t conf_docker_image)" = function ]; then
    docker_img=$(conf_docker_image)
    CONTAINER_NAME=$(docker ps --format '{{.Names}}' --filter "ancestor=${docker_img}")
    if test "${CONTAINER_NAME}" != "";then
        docker exec -ti ${CONTAINER_NAME} /bin/bash
        exit 0
    fi
fi

~/sandbox/docker.run