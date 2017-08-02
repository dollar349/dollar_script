#!/bin/sh
if [[ ${1} != "" ]]; then
FOLDER_PATH=${1}
eval FOLDER_PATH=${FOLDER_PATH}
FOLDER_NAME=`basename "${FOLDER_PATH}"`
RELEASE_FOLDER=`date +%Y_%m_%d`_ReleaseFor_${FOLDER_NAME}
mkdir -p ${RELEASE_FOLDER} 
cp -raf ${FOLDER_PATH}/rpc2k/build-rpc2k/tmp/deploy/images/RPC2_*_AppFwUpdt_DB.bin  ${RELEASE_FOLDER}/.
cp -raf ${FOLDER_PATH}/sources/enp-velocity/core/Tools/Bin/e2_gdd.asn  ${RELEASE_FOLDER}/.
cp -raf ${FOLDER_PATH}/sources/enp-velocity/core/Tools/Bin/e2_gdd.en  ${RELEASE_FOLDER}/.
cp -raf ${FOLDER_PATH}/sources/enp-velocity/enpVsaLib/RPC2K.xml  ${RELEASE_FOLDER}/.

else 
echo "Please enter folder name"
exit 1
fi

exit 0
