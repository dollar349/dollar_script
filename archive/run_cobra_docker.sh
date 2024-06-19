#!/bin/bash
if [[ $1 != "" ]]; then
   docker run --name=cobra -ti --ip=10.162.243.2 --net=cobra_net --rm ${1}
else
   echo "please give image name"
fi
