#!/bin/sh
#DATA=`date -u +%m%d`
#FOLDER_NAME="Z_WORK_"$DATA
if [[ $1 != "" ]]; then
FOLDER_NAME=$1
echo "clone to $FOLDER_NAME"
if [[ $2 != "" ]]; then
echo "switch branch to $2" 
git clone -b $2 https://ghe.int.vertivco.com/Monitoring/rpc2.git $FOLDER_NAME 
else
git clone https://ghe.int.vertivco.com/Monitoring/rpc2.git $FOLDER_NAME 
fi
cd $FOLDER_NAME && \
./getlayers.sh
cp -raf ~/.dollar_script/RPC2/POINT.sh .
cp -raf ~/.dollar_script/RPC2/for_cleanall.sh .

else 
echo "Please enter folder name"
fi
