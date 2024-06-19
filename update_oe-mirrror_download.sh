#!/bin/sh
#MIRRO_SERVER="10.162.243.220:/var/www/html/oe-mirror/cobra-xilinx-obmc2.7.0"
: '
SERVER_LIST=("10.162.243.220:/var/www/html/oe-mirror/xilinx-yocto" \
              "10.162.243.220:/var/www/html/oe-mirror/cobra-xilinx-obmc2.7.0" \
              "10.162.243.220:/var/www/html/oe-mirror/cobra-xilinx-obmc2.7.0_yocto3.1" \
              "10.162.243.220:/var/www/html/oe-mirror/cobra-xilinx-obmc2.9.0" \
              "10.162.243.220:/var/www/html/oe-mirror/2u6n" \
              "10.162.243.220:/var/www/html/oe-mirror/obsidian-base-arm64_202205" \
              "10.162.243.220:/var/www/html/oe-mirror/cobra-xilinx-obmc2.11.0" \
              "10.162.243.143:/var/www/html/oe-mirror/obmcpost2.11.0" \
              )
'
SERVER_LIST=("192.188.88.226:/var/www/html/oe-mirror/VS_TI_Kirkstone" \
             "192.188.88.226:/var/www/html/oe-mirror/VS_NXP_Kirkstone" \
             "192.188.88.226:/var/www/html/oe-mirror/OCT_NXP_Mickledore" \
             "192.188.88.226:/var/www/html/oe-mirror/TI_BSP" \
             )
MOUNT_FOLDER="tmp_mo"
NEWFILE_FOLDER="new_files"
if [[ -d $1 ]]; then
    select opt in "${SERVER_LIST[@]}"
    do
        MIRRO_SERVER=$opt
    
        if [[ $opt == "" ]]; then
        echo "bye bye!"
        continue;
        fi
        break;
    done
    echo "MIRRO_SERVER = $MIRRO_SERVER"

    mkdir -p ${MOUNT_FOLDER}
    mkdir -p ${NEWFILE_FOLDER}
    sudo mount -t nfs ${MIRRO_SERVER} ${MOUNT_FOLDER} && \
    diff --exclude="*.done" $1 ${MOUNT_FOLDER} | grep "Only in $1" | awk '{print $4}' | \
    grep -v "^etc$\|^git2$\|^share$\|^licenses$\|^test$\|^bash43-*\|^bash44-*" | \
    xargs -i cp -raf $1/{} ${NEWFILE_FOLDER}/.  
    sudo umount ${MOUNT_FOLDER} && rm -rf ${MOUNT_FOLDER}
    cd ${NEWFILE_FOLDER} && rm -rf *Avocent* && rm -rf *vertivco* && rm -rf edm* && rm -rf Stingray*
    echo "done"
    echo "if check ${NEWFILE_FOLDER} ok, issue command:"
    echo "scp ${NEWFILE_FOLDER}/* dollar@${MIRRO_SERVER}/."
else
    echo Please enter your downloads folder !!!
fi

