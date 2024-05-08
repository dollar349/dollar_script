#!/bin/bash
MACHINE=${1^^}
EXTRACT_IMAGE=""
if test "${MACHINE}" = "";then
    echo "Please Give a machine!"
    exit 1
fi

case ${MACHINE} in
   TI)
      TOPDIR_FILE="getlayers.sh"
      IMAGE_PATH="build/deploy-ti/images/am62x-var-som/obmc-phosphor-image-am62x-var-som.wic.zst"
      EXTRACT_IMAGE="zstd -d"
      ;;
   NXP)
      TOPDIR_FILE="getlayers.sh"
      IMAGE_PATH="build_xwayland/tmp/deploy/images/imx8mm-var-dart/obmc-phosphor-image-imx8mm-var-dart.wic.gz"
      EXTRACT_IMAGE="gzip -d"
      ;;
   *)
     echo "${MACHINE} not support"
     ;;
esac

# Find Project TOPDIR 
PRJ_TOPDIR=""
CPWD=$(pwd)
while [ "${CPWD}" != '/' ];
do
    if test -f ${TOPDIR_FILE}; then
        PRJ_TOPDIR=$(pwd)
        break;
    fi
    cd ..
    CPWD=`pwd`  
done

if test "${PRJ_TOPDIR}" = ""; then
    echo "PRJ_TOPDIR not found!!"
    exit 1
fi
echo "${PRJ_TOPDIR}"
IMAGE="${PRJ_TOPDIR}/${IMAGE_PATH}"
if test -f ${IMAGE};then
    IMAGE_OPT="~/MY_IMAGES/${MACHINE}/`date +%m%d_%H%M`"
    eval IMAGE_OPT=${IMAGE_OPT}
    mkdir -p ${IMAGE_OPT} && \
    cp ${IMAGE} ${IMAGE_OPT}/.
    if test "${EXTRACT_IMAGE}" != "";then
        cd ${IMAGE_OPT} && ${EXTRACT_IMAGE} $(basename "${IMAGE}")
    fi
else
    echo " ${IMAGE} not found!!"
fi
