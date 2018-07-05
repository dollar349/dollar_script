#!/bin/sh

if [[ ${1} != "" ]]; then
FOLDER_PATH=${1}
eval FOLDER_PATH=${FOLDER_PATH}
PERL_BIN_PATH="${FOLDER_PATH}/build/tmp/sysroots/x86_64-linux/usr/bin/perl-native/"

echo ${PERL_BIN_PATH}

PATH=${PERL_BIN_PATH}:${PATH}

else
echo "Please enter folder name"

fi


