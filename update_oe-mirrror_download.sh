#!/bin/sh
MIRRO_SERVER="10.162.248.66:/sys_home/space_for_http_server"
MOUNT_FOLDER="tmp_mo"
NEWFILE_FOLDER="new_files"
if [[ $1 != "" ]]; then
mkdir -p ${MOUNT_FOLDER}
mkdir -p ${NEWFILE_FOLDER}

sudo mount ${MOUNT_FOLDER} ${MIRRO_SERVER} && \ 
diff --exclude="*.done" $1 ${MOUNT_FOLDER} | grep "Only in downloads"| awk '{print $4}' | grep -v "^etc$\|^git2$\|^share$\|^licenses$\|^test$\|bash43-*" | xargs -i cp -raf $1/{} ${NEWFILE_FOLDER}/.  
sudo umount ${MOUNT_FOLDER} && rm -rf ${MOUNT_FOLDER}

echo "done"
else
echo Please enter your downloads folder !!!
fi

