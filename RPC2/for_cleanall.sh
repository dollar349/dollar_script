#!/bin/sh
#REBUILD_LIST="enp-cli enp-pldcli enp-pldproxy enp-pldserver enp-pldweb"
REBUILD_LIST=`ls common/com.avocent.dev/packages | grep enp`
REBUILD_LIST+=" rpc2k-image extra-rootfs openssh shadow enp-adsap2"
#/home/dollar/P4_RPC2/C_0208/common/com.avocent.dev/packages

for i in $REBUILD_LIST
do
   echo yes | bitbake -c clean $i
   if [ $? == "1" ]; then
       echo "failed to clean $i";
       break;
   fi
done
