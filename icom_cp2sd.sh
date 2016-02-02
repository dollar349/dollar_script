#!/bin/sh
if [[ $1 != "" ]]; then
read -p "clean & update to /media/rfs1? ( y / n ):" ans

if [ "$ans" == "y" ]; then
sudo rm -rf /media/rfs1/* && \
sudo tar -xvzf $1/icomcms-image-tm-am335x-cpm3.tar.gz -C /media/rfs1/ && \
sudo tar -xvzf $1/modules-tm-am335x-cpm3.tgz -C /media/rfs1/
fi

read -p "clean & update to /media/rfs2? ( y / n ):" ans
if [ "$ans" == "y" ]; then
sudo rm -rf /media/rfs2/* && \
sudo tar -xvzf $1/icomcms-image-tm-am335x-cpm3.tar.gz -C /media/rfs2/ && \
sudo tar -xvzf $1/modules-tm-am335x-cpm3.tgz -C /media/rfs2/
fi

read -p "clean & update to /media/boot? ( y / n ):" ans
if [ "$ans" == "y" ]; then
sudo rm -rf /media/boot/* && \
sudo cp $1/u-boot.img /media/boot/. && \
sudo cp $1/MLO /media/boot/.
fi


sudo sync
else
echo No image path enter !!!
fi

