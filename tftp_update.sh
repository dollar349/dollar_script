#!/bin/bash

RESOURCE_ID="fw_primary"
user="admin"
FACTORY_RESET="N"
PASSWD=""
PORT=443
tftp_image=""
IP=""

print_help()
{
    echo ""
    echo "This script helps to run simple firmware update (TFTP)"
    echo "  Usage: $(basename $0) -I \${target IP} -P \${PASSWORD} -i \${TFTP's image path} [options] ..."
    echo "  Example: ./$(basename $0) -I 10.162.247.34 -P 1 -i 10.162.243.220/dollar/obmc-phosphor-image-ipsl-ast2600.static.mtd.tar"
    echo "  option: "
    echo "    -U [USER]"
    echo "        admin as by default"
    echo "    -A"
    echo "        Update 2nd Flash"
    echo "    -r"
    echo "        reset to default"
}
while getopts 'I:P:i:U:rAh' OPT; do
    case $OPT in
        I)
            IP=$OPTARG
            ;;
        P)
            PASSWD=$OPTARG
            ;;
        i)
            tftp_image=$OPTARG
            ;;
        U)
            user=$OPTARG
            ;;
        A)
            RESOURCE_ID="fw_alternative"
            ;;
        r)
            FACTORY_RESET="Y"
            ;;
        h)
            print_help
            exit 0
            ;;
        ?)
            print_help
            exit 1
            ;;
    esac
done

if [ "${IP}" = "" ];then
    echo "Please provide the target IP address by [-I \${target IP}]"
    exit 1
fi

if [ "${PASSWD}" = "" ];then
    echo "Please provide the Password for ${user} by [-P \${PASSWORD}]"
    exit 1
fi

if [ "${tftp_image}" = "" ];then
    echo "Please enter a TFTP's image by [-i \${TFTP's image path}]"
    exit 1
fi

#echo "curl -ks -u "${user}:${PASSWD}" HTTPS://${IP}:${PORT}/redfish/v1/UpdateService/FirmwareInventory/${RESOURCE_ID}"
TARGET=`curl -ks -u "${user}:${PASSWD}" HTTPS://${IP}:${PORT}/redfish/v1/UpdateService/FirmwareInventory/${RESOURCE_ID} | jq '.RelatedItem[]."@odata.id"'`

if [ "${TARGET}" = "" ];then
    echo "Get update TARGET failed"
    exit 1
fi
echo "update targe : ${TARGET}"


# Factory reset ?
if [ ${FACTORY_RESET} = "Y" ];then
    echo "Firmware update with reset to default..."
    data='{"Oem": {"Vertiv": {"ResetToDefaults": true}}}'
    curl -k -i -X PATCH -u ${user}:${PASSWD} -H "Content-Type:application/json" -d "$data" "HTTPS://${IP}:${PORT}/redfish/v1/UpdateService"
fi

data="{\"ImageURI\":\"tftp://${tftp_image}\",\"Targets\": [${TARGET}],\"TransferProtocol\":\"TFTP\"}"
echo ${data}

# Start firmware update
t1=$(date +"%s")
#echo "curl -k -s -X POST -u "${user}:${PASSWD}" -H "Content-Type:application/json" -d "${data}" https://${IP}:${PORT}/redfish/v1/UpdateService/Actions/UpdateService.SimpleUpdate"
TaskService=`curl -k -s -X POST -u "${user}:${PASSWD}" -H "Content-Type:application/json" -d "${data}" https://${IP}:${PORT}/redfish/v1/UpdateService/Actions/UpdateService.SimpleUpdate | jq .TaskMonitor`

# trim double quotes
TaskService=`echo ${TaskService} | tr -d '"'`

echo "TaskService = ${TaskService}"
re='^[0-9]+$'
while
    sleep 3
    Progress=`curl -k -s -u ${user}:${PASSWD} https://${IP}:${PORT}${TaskService} | jq .PercentComplete`
    echo "Progress = ${Progress}"
    [[ ${Progress} =~ $re ]]
do :;  done
echo "Update completed..."
t2=$(date +"%s")
time=`expr $t2 - $t1`
m=`expr $time / 60`
s=`expr $time % 60`

if [ $m -eq 0 ];then
  echo "Time taken $s sec"
else
  echo "Time taken $m min $s sec"
fi

