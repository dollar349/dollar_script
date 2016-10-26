#!/bin/sh
#DATA=`date -u +%m%d`
#FOLDER_NAME="Z_WORK_"$DATA
if [[ $1 != "" ]]; then
FOLDER_NAME=$1
echo "clone to $FOLDER_NAME"
if [[ $2 != "" ]]; then
echo "switch branch to $2" 
git clone -b $2 https://npusgithub.emrsn.org/ConvergedSystems/icom-cms.git $FOLDER_NAME 
else
git clone https://npusgithub.emrsn.org/ConvergedSystems/icom-cms.git $FOLDER_NAME 
fi
cd $FOLDER_NAME && \
sed -i '/SOURCE_MIRROR_URL=/s/=.*/=\"http:\/\/10.162.243.192\/oe-mirror\/\"/' getlayers.sh && ./getlayers.sh && \
sed -i '/^LOCAL_MIRROR/s/?=.*/= \"http:\/\/10.162.243.192\/oe-mirror\/\"/' build/conf/local.conf && \
sed -i '/^dhcp-range=/s/dhcp-range/#dhcp-range/' meta-openembedded/meta-networking/recipes-support/dnsmasq/files/dnsmasq.conf 
cp -raf ~/.dollar_script/iCOMCMS/POINT.sh .
cp -raf ~/.dollar_script/iCOMCMS/for_cleanall.sh build/.
cp -raf ~/.dollar_script/iCOMCMS/Compile_for_icom.sh build/.
else 
echo "Please enter folder name"
fi
