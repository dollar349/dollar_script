#!/bin/bash

RESOURCE_ID="fw_primary"
PASSWD=""
IP=""
PORT=443
image=""
IP=""
user="admin"
FACTORY_RESET="N"
print_help()
{
    echo ""
    echo "This script helps to run push firmware update"
    echo "  Usage: $(basename $0) -I \${target IP} -P \${PASSWORD} -i \${image(xxx.static.mtd.tar)} [options] ..."
    echo "  Example: ./$(basename $0) -I 10.162.247.34 -P 1 -i tmp/deploy/images/ipsl-ast2600/obmc-phosphor-image-ipsl-ast2600.static.mtd.tar"
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
            image=$OPTARG
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

if [ "${image}" = "" ];then
    echo "Please enter an image by [-i \${image(xxx.static.mtd.tar)}]"
    exit 1
fi


#echo "curl -ks -u "${user}:${PASSWD}" HTTPS://${IP}:${PORT}/redfish/v1/UpdateService/FirmwareInventory/${RESOURCE_ID}"
TARGET=`curl -ks -u "${user}:${PASSWD}" HTTPS://${IP}:${PORT}/redfish/v1/UpdateService/FirmwareInventory/${RESOURCE_ID} | jq '.RelatedItem[]."@odata.id"'`

if [ "${TARGET}" = "" ];then
    echo "Get update TARGET failed"
    exit 1
fi
echo "update targe : ${TARGET}"

# Set update target 
curl -k -s -X PATCH -u "${user}:${PASSWD}" -H "Content-Type:application/json" -d "{\"HttpPushUriTargets\":[${TARGET}],\"HttpPushUriTargetsBusy\":true}" "https://${IP}:${PORT}/redfish/v1/UpdateService"
sleep 1

# Factory reset ?
if [ ${FACTORY_RESET} = "Y" ];then
    echo "Firmware update with reset to default..."
    data='{"Oem": {"Vertiv": {"ResetToDefaults": true}}}'
    curl -k -s -X PATCH -u ${user}:${PASSWD} -H "Content-Type:application/json" -d "$data" "HTTPS://${IP}:${PORT}/redfish/v1/UpdateService"
fi

# Start firmware update
t1=$(date +"%s")
TaskService=`curl -k -s -u ${user}:${PASSWD} -F "UpdateFile=@${image};filename=${image##*/}" https://${IP}:${PORT}/upload | jq .TaskMonitor`

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


