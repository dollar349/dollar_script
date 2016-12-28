#!/bin/sh
APPFWDBFILE=`ls /home/dollar/Lima_test/rpc2k/build-rpc2k/tmp/deploy/images/ | grep AppFwUpdt_DB.bin`
if [[ "${APPFWDBFILE}" != "" ]]; then
 echo "file exist"
else
 echo "file not exist"
fi
