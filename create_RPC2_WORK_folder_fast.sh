#!/bin/sh
#DATA=`date -u +%m%d`
#FOLDER_NAME="Z_WORK_"$DATA
LOCALPWD=`pwd`
CACHEFOLDER="$LOCALPWD/_rpc2_monitoring"
if [[ $1 != "" ]]; then
FOLDER_NAME=$1
echo "copy ${CACHEFOLDER} to $FOLDER_NAME"
cp -raf ${CACHEFOLDER} ${LOCALPWD}/$1 && cd ${LOCALPWD}/$1 && git pull
if [[ $2 != "" ]]; then
    git checkout $2
fi
./getlayers.sh
cp -raf ~/.dollar_script/RPC2/POINT.sh .
cp -raf ~/.dollar_script/RPC2/for_cleanall.sh .

else 
echo "Please enter folder name"
fi
