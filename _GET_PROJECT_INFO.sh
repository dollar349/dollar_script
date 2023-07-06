#!/bin/sh
################################################################
# usage: 
# ABSPATH=$(readlink -f "$BASH_SOURCE")
# SCRIPTPATH=$(dirname "$ABSPATH")
# # Check _GET_PROJECT_INFO.sh script exist
# if test ! -f ${SCRIPTPATH}/_GET_PROJECT_INFO.sh; then
#     echo "_GET_PROJECT_INFO.sh not found"
#     exit 1
# fi
#
# source ${SCRIPTPATH}/_GET_PROJECT_INFO.sh
#
# if test "${PRJ_INFO}" != "OK" ; then
#     echo "Project path not found"
#     exit 1
# fi
# 
# echo "PRJ_PATH = ${PRJ_PATH}"
# echo "PRJ_MACHINE = ${PRJ_MACHINE}"
# echo "PRJ_BUILD_PATH = ${PRJ_BUILD_PATH}"
# echo "PRJ_LOCAL_CONF = ${PRJ_LOCAL_CONF}"
# echo "PRJ_IMAGE = ${PRJ_IMAGE}"
# echo "PRJ_MANIFEST = ${PRJ_MANIFEST}"
# echo "PRJ_DEPLOY_IMAGE_PATH = ${PRJ_DEPLOY_IMAGE_PATH}"
# echo "PRJ_TIMAGE_TYPE = ${PRJ_TIMAGE_TYPE}"  // SPI or EMMC
# echo "PRJ_REPO_NAME = ${PRJ_REPO_NAME}"
################################################################
CURRENT_PWD=`pwd`
TARGET_FILE="getlayers.sh"
VERTIV_MACHINE_FILE=".MACHINE"


# Find Project real path (PRJ_PATH)
CPWD=`pwd`
while [ "${CPWD}" != '/' ];
do
    if test -f ${TARGET_FILE}; then
        export PRJ_PATH=`pwd`
        break;
    fi
    cd ..
    CPWD=`pwd`  
done

cd ${CURRENT_PWD}
if test "x${PRJ_PATH}" = "x"; then
    export PRJ_INFO="Project not found"
else
    export PRJ_INFO="OK"
fi
MACHINE_BUILD_FOLDER=`cat ${PRJ_PATH}/${VERTIV_MACHINE_FILE}`
if test "${PRJ_INFO}" = "OK" ; then
    # Find Build folder real path (BUILD_PATH) 
    export PRJ_BUILD_PATH="${PRJ_PATH}/build-${MACHINE_BUILD_FOLDER}"
    export PRJ_LOCAL_CONF="${PRJ_PATH}/build-${MACHINE_BUILD_FOLDER}/conf/local.conf"
    export PRJ_MACHINE=`grep ^MACHINE ${PRJ_LOCAL_CONF} | awk -F '=' '{print $NF}' | sed 's/^[ \t]*//g' | sed 's/^"*//g' | sed 's/"*$//g'`
    export PRJ_MANIFEST="${PRJ_BUILD_PATH}/tmp/deploy/images/${PRJ_MACHINE}/obmc-phosphor-image-${PRJ_MACHINE}.manifest"
    export PRJ_DEPLOY_IMAGE_PATH="${PRJ_BUILD_PATH}/tmp/deploy/images/${PRJ_MACHINE}"
    # Get image type (SPI or EMMC)
    if test "$(ls ${PRJ_DEPLOY_IMAGE_PATH}/*-emmc.wks 2>/dev/null)" = ""; then
        export PRJ_TIMAGE_TYPE="SPI"
        export PRJ_IMAGE="${PRJ_BUILD_PATH}/tmp/deploy/images/${PRJ_MACHINE}/obmc-phosphor-image-${PRJ_MACHINE}.static.mtd.tar"
    else
        export PRJ_TIMAGE_TYPE="EMMC"
        export PRJ_IMAGE="${PRJ_BUILD_PATH}/tmp/deploy/images/${PRJ_MACHINE}/obmc-phosphor-image-${PRJ_MACHINE}.ext4.mmc.tar"
    fi
    # Get Project Repository name
    export PRJ_REPO_NAME="$(git --git-dir=${PRJ_PATH}/.git remote -v | head -n 1 | awk -F '/' '{print $NF}')"
    PRJ_REPO_NAME=${PRJ_REPO_NAME%.git*}
fi
