#!/bin/bash
PRJ_PATH=""
CURRENT_PWD=`pwd`
TARGET_FILE="getlayers.sh"

CPWD=`pwd`
while [ "${CPWD}" != '/' ];
do
    if test -f ${TARGET_FILE}; then
        PRJ_PATH=`pwd`
        break;
    fi
    cd ..
    CPWD=`pwd`
done



MACHINE_NAME=`cat ${PRJ_PATH}/.MACHINE`
#echo $MACHINE_NAME
vi build-${MACHINE_NAME}/tmp/deploy/images/${MACHINE_NAME}/obmc-phosphor-image-${MACHINE_NAME}.manifest
 

