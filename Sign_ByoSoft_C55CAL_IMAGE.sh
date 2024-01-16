#!/bin/bash

IMAGE_OPT="~/C55CAL_IMAGES/`date +%m%d_%H%M`"
eval IMAGE_OPT=${IMAGE_OPT}
BYO_TOOLS_FOLDER="/home/dollar/tools/ByoSoft/SignImage"

if test "$1" = "";then
    echo "Please give a image name with path"
    exit 1
fi

if test ! -f $1 ; then
    echo "$1 not a file"
    exit 1
fi

image_name=$(basename "$1")

cp ${1} ${BYO_TOOLS_FOLDER}/. && \
cd ${BYO_TOOLS_FOLDER} && \
docker run --rm -v `pwd`:/home/eason/ 192.168.11.32:5000/ami_bmc_rr11.5:v1 bash -c "./SignImage_2048 -f ${image_name} -k private.pem" && \
mkdir -p ${IMAGE_OPT} && \
mv ${image_name} ${IMAGE_OPT}/. && \
echo "The image has been signed and save in [${IMAGE_OPT}]"
