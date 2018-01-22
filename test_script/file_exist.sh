#!/bin/sh
#DATA=`date -u +%m%d`
#FOLDER_NAME="Z_WORK_"$DATA
if [[ $1 != "" ]]; then
FILE_NAME=$1
echo $FOLDER_NAME
if [[ -e $FILE_NAME ]]; then
echo "file exist"
else
echo "file not exist"
fi

else 
echo "Please enter folder name"
fi
