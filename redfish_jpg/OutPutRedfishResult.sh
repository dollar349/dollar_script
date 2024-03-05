#!/bin/bash

ACCOUNT="admin:admin"
IP="https://192.168.11.19"
TXT_TO_PNG_TOOL="txt_2_png.py"
DEBUG="Y"
URL_LIST=("/redfish/v1/Systems/1" \
          "/redfish/v1/Chassis/1" \
          "/redfish/v1/Systems/1/Processors" \
          "/redfish/v1/Systems/1/Processors/[member]" \
          "/redfish/v1/Systems/1/Processors?\$expand=." \
          "/redfish/v1/Systems/1/Memory" \
          "/redfish/v1/Systems/1/Memory/[member]" \
          "/redfish/v1/Systems/1/Memory?\$expand=." \
          "/redfish/v1/Systems/1/Storages" \
          "/redfish/v1/Systems/1/Storages?\$expand=." \
          "/redfish/v1/Systems/1/Storages/RAIDStorage0" \
          "/redfish/v1/Systems/1/Storages/RAIDStorage0/Volumes" \
          "/redfish/v1/Systems/1/Storages/RAIDStorage0/Volumes/[member]" \
          "/redfish/v1/Chassis/1/Drives" \
          "/redfish/v1/Chassis/1/Drives/[member]" \
          "/redfish/v1/Chassis/1/Drives?\$expand=." \
          "/redfish/v1/Chassis/1/NetworkAdapters" \
          "/redfish/v1/Chassis/1/NetworkAdapters/[member]" \
          "/redfish/v1/Chassis/1/NetworkAdapters/mainboardPCIeCard1/NetworkPorts/1" \
          "/redfish/v1/Chassis/1/NetworkAdapters/mainboardPCIeCard1/NetworkPorts/2" \
          "/redfish/v1/Chassis/1/NetworkAdapters/mainboardPCIeCard2/NetworkPorts/1" \
          "/redfish/v1/Chassis/1/NetworkAdapters/mainboardPCIeCard2/NetworkPorts/2" \
          "/redfish/v1/Chassis/1/NetworkAdapters?\$expand=." \
          "/redfish/v1/Chassis/1/Thermal" \
          "/redfish/v1/Chassis/1/Power" \
          "/redfish/v1/Chassis/1/PCIeDevices" \
          "/redfish/v1/Chassis/1/PCIeDevices/[member]" \
          "/redfish/v1/Chassis/1/PCIeDevices?\$expand=." \
          "/redfish/v1/Systems/1/Bios" \
          "/redfish/v1/Systems/1/Bios/Settings" \
          "/redfish/v1/Managers/1" \
          "/redfish/v1/Managers/1/NetworkProtocol" \
          "/redfish/v1/Managers/1/LldpService" \
          )

if test "$(ls *.png 2>/dev/null)" != ""; then
    echo "Delete all png files (y/n)? "
    read -p "y:delete, n: cancel : " ans
    if [ "$ans" == "y" ]; then
        rm -rf *.png
    else
        echo "  CANCELED"
        exit 0
    fi
fi

for url in  ${URL_LIST[@]}
do
    if test "${url}" != "${url%'[member]'}";then
        # If there is a [member] in the ending, means collection url
        echo "collection url, get all instance by curl"
        URLS=$(curl -k -u ${ACCOUNT} ${IP}${url%'/[member]'} | jq '.Members[]["@odata.id"]' | sed 's/"//g')
    else
        URLS=$url
    fi
    echo "URLS = [${URLS}]"
    for instance in ${URLS}
    do
        FILE_NAME=$(echo ${instance} | sed 's/\//_/g' | sed 's/^_//' | sed 's/?$expand=./.expand/')
        #echo "$FILE_NAME url is [$instance]"
        #echo "curl -k -u ${ACCOUNT} ${IP}${instance}"
        echo "Redfish path: ${instance}" > ${FILE_NAME}.txt
        curl -k -u ${ACCOUNT} ${IP}${instance} >> ${FILE_NAME}.txt
        ./${TXT_TO_PNG_TOOL} ${FILE_NAME}.txt
        rm -rf ${FILE_NAME}.txt
    done
done
