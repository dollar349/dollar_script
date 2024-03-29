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
file_path=$(dirname "$1")

# Get bin file
bin_file="${file_path}/image-bmc"
absolute_path_bin_file=$(readlink -f "${bin_file}")

cp ${1} ${BYO_TOOLS_FOLDER}/. && \
cd ${BYO_TOOLS_FOLDER} && \
docker run --rm -v `pwd`:/app byo_sign_image:v1 bash -c "./SignImage_2048 -f ${image_name} -k private.pem" && \
mkdir -p ${IMAGE_OPT} && \
mv ${image_name} ${IMAGE_OPT}/. && \
echo "The image has been signed and save in [${IMAGE_OPT}]"

if test -f ${absolute_path_bin_file}; then
    echo "Copy image-bmc to folder"
    cp ${absolute_path_bin_file} ${IMAGE_OPT}/image-bmc
fi
