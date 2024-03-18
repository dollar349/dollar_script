#!/bin/bash

has() {
    type "$1" >/dev/null 2>&1
}

# Check machine required tools 
REQ_TOOL_LIST="md5sum sha256sum"
for tool in ${REQ_TOOL_LIST}
do
    if ! has ${tool};then
        echo "${tool} not found!"
        echo "Try to install it by the following command!"
        echo "  $ sudo atp install ${tool}"
        echo "  $ sudo yum install ${tool}"
        exit 1
    fi
done

BIN_FILE=$(ls *.bin)
TAR_FILE=$(ls *.tar)

echo "================== MD5 Info ==================="
echo " "
echo "${BIN_FILE}:"
echo "$(md5sum ${BIN_FILE}| awk '{print $1}')"
echo " "
echo "${TAR_FILE}:"
echo "$(md5sum ${TAR_FILE}| awk '{print $1}')"
echo " "
echo "================= SHA256 Info ================="
echo " "
echo "${BIN_FILE}:"
echo "$(sha256sum ${BIN_FILE}| awk '{print $1}')"
echo " "
echo "${TAR_FILE}:"
echo "$(sha256sum ${TAR_FILE}| awk '{print $1}')"
echo " "