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

NEW_VERSION="dev-"`date +%Y%m%d.%H%M`
sed -i "s/COBRA_VERSION =.*/COBRA_VERSION = \"${NEW_VERSION}\"/" ${PRJ_LOCAL_CONF}
echo "New COBRA_VERSION is ${NEW_VERSION}"
CURRENT_PWD=`pwd`
cd ${PRJ_BUILD_PATH}
bitbake obmc-phosphor-image
cd ${CURRENT_PWD}