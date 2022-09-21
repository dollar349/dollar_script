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

# Check is cobra env
if test "`grep COBRA_VERSION ${PRJ_LOCAL_CONF}`" != "";then
   #echo "This is Cobra env"
   sed -i "s/COBRA_VERSION =.*/COBRA_VERSION = \"${NEW_VERSION}\"/" ${PRJ_LOCAL_CONF}
   echo "New COBRA_VERSION is ${NEW_VERSION}"
elif test "`grep INC_VERSION ${PRJ_LOCAL_CONF}`" != "";then
   #echo "This is INC env"
   sed -i "s/INC_VERSION =.*/INC_VERSION = \"${NEW_VERSION}\"/" ${PRJ_LOCAL_CONF}
   echo "New INC_VERSION is ${NEW_VERSION}"
elif test "`grep ACI_VERSION ${PRJ_LOCAL_CONF}`" != "";then
   #echo "This is ACI env"
   sed -i "s/ACI_VERSION =.*/ACI_VERSION = \"${NEW_VERSION}\"/" ${PRJ_LOCAL_CONF}
   echo "New ACI_VERSION is ${NEW_VERSION}"
fi
CURRENT_PWD=`pwd`
cd ${PRJ_BUILD_PATH}
bitbake obmc-phosphor-image
cd ${CURRENT_PWD}
