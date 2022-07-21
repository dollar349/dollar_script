#!/bin/sh
ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")
# Check _GET_PROJECT_INFO.sh script exist
if test ! -f ${SCRIPTPATH}/_GET_PROJECT_INFO.sh; then
    echo "_GET_PROJECT_INFO.sh not found"
    exit 1
fi
source ${SCRIPTPATH}/_GET_PROJECT_INFO.sh
if test "${PRJ_INFO}" != "OK" ; then
    echo "Project path not found"
    exit 1
fi
CURRENT_PWD=`pwd`
cd ${PRJ_BUILD_PATH}
bitbake obmc-phosphor-image && rm -rf /tftpboot/${USER}/image-* && cp tmp/deploy/images/*/image-* /tftpboot/${USER}/.
cd ${CURRENT_PWD}