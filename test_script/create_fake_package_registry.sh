#!/bin/bash

ID=41754391

UPLOAD_N_DAY=60
MACHINE_LIST="inc-ast2600evb inc-ipsl inc"

echo "This is test image" > image-bmc
for machine in ${MACHINE_LIST}; do
    echo "This is test image" > obmc-phosphor-image-${machine}.static.mtd.tar
done

a=1

while test ${a} -le ${UPLOAD_N_DAY}
do
    DATE=$(date +%Y-%m-%d --date="-${a} day")
    for machine in ${MACHINE_LIST}; do
        echo "Upload ${machine} : ${DATE}"
        Gitlab_upload_package.sh -r ${ID} -p DailyBuild-${machine} -v ${DATE} -f image-bmc
        Gitlab_upload_package.sh -r ${ID} -p DailyBuild-${machine} -v ${DATE} -f obmc-phosphor-image-${machine}.static.mtd.tar
    done
    a=`expr $a + 1`
done 
#for machine in ${MACHINE_LIST}; do
#    for ((i=1; i<=${UPLOAD_N_DAY}; i++))
#    do
#        echo $(date +%Y-%m-%d --date="-${i} day")
#    done
#echo ${machine}
#done

#Gitlab_upload_package.sh -r ${ID} -p DailyBuild-inc-ast2600evb -v ${DATE} -f image-bmc

rm -rf image-bmc
rm -rf obmc-phosphor-image-*.static.mtd.tar
