#!/bin/sh
#DATA=`date -u +%m%d`
#FOLDER_NAME="Z_WORK_"$DATA
if [[ $1 != "" ]]; then
FOLDER_NAME=$1
echo $FOLDER_NAME
git clone https://npusgithub.emrsn.org/ConvergedSystems/icom-cms.git $FOLDER_NAME && \
cd $FOLDER_NAME && \
sed -i '/SOURCE_MIRROR_URL=/s/=.*/=\"http:\/\/10.162.243.192\/oe-mirror\/\"/' getlayers.sh && ./getlayers.sh && \
sed -i '/^LOCAL_MIRROR/s/?=.*/= \"http:\/\/10.162.243.192\/oe-mirror\/\"/' build/conf/local.conf && \
sed -i '/^dhcp-range=/s/dhcp-range/#dhcp-range/' meta-openembedded/meta-networking/recipes-support/dnsmasq/files/dnsmasq.conf 
cp -raf ~/.dollar_script/iCOMCMS/POINT.sh .
cp -raf ~/.dollar_script/iCOMCMS/for_cleanall.sh build/.
else 
echo "Please enter folder name"
fi
