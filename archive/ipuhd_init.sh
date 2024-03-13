#!/bin/bash

IP=${1}
PWD="1"
PORT="443"
if test "x${2}" != "x"; then
  PORT=${2}
fi

curl -ks -X PATCH -u "admin:Password1" "https://${IP}:${PORT}/redfish/v1/AccountService/Accounts/2" -H "content-type:application/json" -d "{\"Password\":\"${PWD}\"}"
sleep 3
curl -ks -X PATCH -u "admin:${PWD}" "https://${IP}:${PORT}/redfish/v1/Managers/1/NetworkProtocol" -H "content-type:application/json" -d '{"SSH":{"ProtocolEnabled": true}}'
