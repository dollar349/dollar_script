#!/bin/sh
if [[ $1 != "" ]]; then
echo "copy to /media/rfs1"
sudo rm -rf /media/rfs1/* && \
sudo tar -xvzf $1/icomcms-image-tm-am335x-cpm3.tar.gz -C /media/rfs1/ && \
sudo tar -xvzf $1/modules-tm-am335x-cpm3.tgz -C /media/rfs1/

echo "copy to /media/rfs2"
sudo rm -rf /media/rfs2/* && \
sudo tar -xvzf $1/icomcms-image-tm-am335x-cpm3.tar.gz -C /media/rfs2/ && \
sudo tar -xvzf $1/modules-tm-am335x-cpm3.tgz -C /media/rfs2/
#sudo cp -raf $1/zImage /media/rfs1/boot/.
#sudo cp -raf $1/am335x-ghmi.dtb /media/rfs1/boot/.
sudo sync
else
echo No image path enter !!!
fi

