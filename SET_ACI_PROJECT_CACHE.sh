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

COMMON_INC_FILE=""

if test "${PRJ_REPO_NAME}" = "blueplate-dev";then
    COMMON_INC_FILE="${PRJ_PATH}/aci-conf/common/aci-common.conf"
elif test "${PRJ_REPO_NAME}" = "inc-dev";then
    COMMON_INC_FILE="${PRJ_PATH}/inc-conf/common/inc-common.conf"
elif test "${PRJ_REPO_NAME}" = "cobra-dev";then
    COMMON_INC_FILE="${PRJ_PATH}/cobra-conf/common/cobra-common.conf"
fi

echo "Set BB_SRCREV_POLICY to \"cache\" in file ${COMMON_INC_FILE}" 
sed -i 's/^BB_SRCREV_POLICY.*/BB_SRCREV_POLICY = "cache"/' ${COMMON_INC_FILE}
