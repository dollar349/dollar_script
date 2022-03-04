#!/bin/bash

IP=${1}
PWD="1"
PORT="443"
if test "x${2}" != "x"; then
  PORT=${2}
fi

curl -ks -X PATCH -u "admin:admin" "https://${IP}:${PORT}/redfish/v1/AccountService/Accounts/2" -H "content-type:application/json" -d "{\"Password\":\"${PWD}\"}" && \
sleep 2 && \
curl -ks -X PATCH -u "admin:${PWD}" "https://${IP}:${PORT}/redfish/v1/Managers/bmc/NetworkProtocol" -H "content-type:application/json" -d '{"SSH":{"ProtocolEnabled": true}}'
