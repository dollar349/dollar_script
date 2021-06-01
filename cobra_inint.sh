#!/bin/bash

IP=${1}
PWD="1"

curl -ks -X PATCH -u "admin:Password1" "https://${IP}:8080/redfish/v1/AccountService/Accounts/2" -H "content-type:application/json" -d "{\"Password\":\"${PWD}\"}" && \
sleep 2 && \
curl -ks -X PATCH -u "admin:${PWD}" "https://${IP}:8080/redfish/v1/Managers/bmc/NetworkProtocol" -H "content-type:application/json" -d '{"SSH":{"ProtocolEnabled": true}}'
