#!/bin/sh
TESTUSER="admin"
TESTPASSWD="2210"
TARGETIP=10.162.244.3
TARGET_URL="https://${TARGETIP}:443/redfish/v1/Chassis/1/Oem/Avocent:iComCms/AlertSetting/5/"

patchbody1='{"RelayEnabled": true,"NotifyEnabled": false,"NotifyType": "Alarm","ActiveDelaySeconds": 0,"Threshold":30}'
patchbody2='{"RelayEnabled": true,"NotifyEnabled": true,"NotifyType": "Alarm","ActiveDelaySeconds": 0,"Threshold":30}'


while [ 1 ]
do 
ETAG=`curl -k -tls1.2 --user ${TESTUSER}:${TESTPASSWD} -I -L -X GET ${TARGET_URL} | grep ETag`
ETAG=`echo ${ETAG##* }`

curl -k -tls1.2 -i \
 --user ${TESTUSER}:${TESTPASSWD} \
 -X PATCH ${TARGET_URL} \
 --header "Content-Type: application/json" \
 --header "If-Match: $ETAG" \
 -d'{"RelayEnabled": true,"NotifyEnabled": false,"NotifyType": "Alarm","ActiveDelaySeconds": 0,"Threshold":30}'

ETAG=`curl -k -tls1.2 --user ${TESTUSER}:${TESTPASSWD} -I -L -X GET ${TARGET_URL} | grep ETag`
ETAG=`echo ${ETAG##* }` 
curl -k -tls1.2 -i \
 --user ${TESTUSER}:${TESTPASSWD} \
 -X PATCH ${TARGET_URL} \
 --header "Content-Type: application/json" \
 --header "If-Match: $ETAG" \
 -d'{"RelayEnabled": true,"NotifyEnabled": true,"NotifyType": "Alarm","ActiveDelaySeconds": 0,"Threshold":30}'

done 
