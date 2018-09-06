#!/bin/sh
T_NAME="~/trash/"
eval T_NAME=${T_NAME}
LOG_NAME=${T_NAME}/`date -u +%Y%m%d-%H%M%S`-$RANDOM
mkdir -p ${T_NAME}
echo "Move $* to ${LOG_NAME}"
echo "And then delete them (y/n)? "
read -p "y:commit, n: cancel : " ans

if [ "$ans" == "y" ]; then
  mkdir -p ${LOG_NAME}
        eval mv $* ${LOG_NAME}
        sudo -b nice --adjustment=19 rm -rf ${LOG_NAME}
        echo "Deleting ${LOG_NAME} at background"
else
        echo "  CANCELED"
fi



