#!/bin/sh
#DATA=`date -u +%m%d`
#FOLDER_NAME="Z_WORK_"$DATA
export PATH=$PATH:/home/dollar/.dollar_script

DAILY_DATE=`date +%Y_%m_%d`
WEB_SERVER=/sys_home/space_for_http_server/icomcms-image/
CLONE_NAME=icom-cms
ROOT_PATH=/sys_home/dollar/daily_build/
DAILY_BUILD=${ROOT_PATH}/${CLONE_NAME}/
BUILD_FOLDER=${DAILY_BUILD}/build/

IMAGE_FILE=${DAILY_BUILD}build/tmp/deploy/images/tm-am335x-cpm3/avct-img_master.xbp

sudo rm -rf ${DAILY_BUILD}
cd ${ROOT_PATH}
git clone https://npusgithub.emrsn.org/ConvergedSystems/icom-cms ${DAILY_BUILD}
sed -i 's/sun-aess.emrsn.org/10.162.243.192/g' icom-cms/getlayers.sh
sed -i 's/sun-aess.emrsn.org/10.162.243.192/g' icom-cms/build/conf/local.conf

cd ${DAILY_BUILD}
./getlayers.sh
sed -i '/^dhcp-range=/s/dhcp-range/#dhcp-range/' meta-openembedded/meta-networking/recipes-support/dnsmasq/files/dnsmasq.conf 
source poky-fido-13.0.0/oe-init-build-env
bitbake icomcms-image

if [[ -e $IMAGE_FILE ]]; then
mkdir -p ${WEB_SERVER}${DAILY_DATE} && cp -raf ${IMAGE_FILE} ${WEB_SERVER}${DAILY_DATE}/.
cd ${BUILD_FOLDER} && UPDATE_SSTATE_CACHE.sh
fi
