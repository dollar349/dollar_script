#!/bin/sh
mkdir -p for_mount_$1
U=$USER
sudo mount -t nfs $1:/home/$U/ for_mount_$1/

