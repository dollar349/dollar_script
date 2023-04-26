#!/bin/sh
ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")

source ${SCRIPTPATH}/_GET_PROJECT_INFO.sh
if test "${PRJ_INFO}" != "OK" ; then
    echo "Project path not found"
    exit 1
fi
# Check is cobra env
if test "`grep COBRA_VERSION ${PRJ_LOCAL_CONF}`" != "";then
    #echo "This is Cobra env"
    CONF_FILE="${PRJ_PATH}/cobra-conf/common/cobra-common.conf" 
elif test "`grep INC_VERSION ${PRJ_LOCAL_CONF}`" != "";then
    #echo "This is INC env"
    CONF_FILE="${PRJ_PATH}/inc-conf/common/inc-common.conf" 
elif test "`grep ACI_VERSION ${PRJ_LOCAL_CONF}`" != "";then
    #echo "This is ACI env"
    CONF_FILE="${PRJ_PATH}/aci-conf/common/aci-common.conf" 
fi

sed -i '/^BB_SRCREV_POLICY/s|=.*|= "cache"|' inc-conf/common/inc-common.conf
