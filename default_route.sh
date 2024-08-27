#!/bin/bash
sudo route add -net 192.188.0.0 netmask 255.255.0.0 gw 192.188.88.1 dev enp4s0 metric 0
