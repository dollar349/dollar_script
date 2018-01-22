#!/bin/sh
sudo ip route change default via 192.168.43.1 dev wlan0
sudo route add -net 10.0.0.0 netmask 255.0.0.0 gw 10.162.224.1
sudo route add -net 126.0.0.0 netmask 255.0.0.0 gw 10.162.224.1
sudo route add -net 185.0.0.0 netmask 255.0.0.0 gw 10.162.224.1
