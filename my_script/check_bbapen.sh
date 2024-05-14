#!/bin/bash

#APPEND_FILE=$(find . -name *.bbappend | awk -F'/' '{print $NF}')
APPEND_FILE=$(find . -name *.bbappend)
SEARCH_FOLDER="/home/dollar/ssd/A_TI_BSP_OBMC/sources"
for f in ${APPEND_FILE};
do
    FULL_PATH=${f}
    f=$(echo ${FULL_PATH} | awk -F'/' '{print $NF}')
    FILE_NAME=${f%.bbappend}
    if test "${f#*'%'}" != "${f}" ; then
        FILE_NAME=${FILE_NAME/\%/}
        FILE_NAME=${FILE_NAME/_/}
        #echo $f will use ${FILE_NAME} to search
    fi
    RES=$(find ${SEARCH_FOLDER} -name ${FILE_NAME}*)
    if test "${RES}" != ""; then
        echo "[${FULL_PATH}] match..."
        #echo ${RES}
    fi
done
