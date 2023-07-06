#!/bin/bash

CURRENT_PWD=`pwd`
TARGET_FILE="getlayers.sh"
SI_PATH="/home/dollar/Source_Insight/Cobra"

PRJ_PATH=""
#echo $CURRENT_PWD
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

if test "x${PRJ_PATH}" != "x"; then
    echo "PRJ_PATH = ${PRJ_PATH}"
    cd ${SI_PATH} && \
    ./p_src_to_target.sh ${PRJ_PATH} && \
    echo "Run ./p_src_to_target.sh ${PRJ_PATH} done..."
else
    echo "Get project path failed"
fi 
