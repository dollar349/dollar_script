#!/bin/bash

if [[ "$1" = -[hH] ]];then
  echo "This script will find all local.conf and set the new vrsion to \"INC_VERSION\""
  echo "  Usage: $(basename $0) \${Version that you want}"
fi


if [[ $1 != "" ]]; then
   find . -name local.conf | xargs -i sed -i "s/INC_VERSION =.*/INC_VERSION = \"${1}\"/" {}
else
   echo "please give a string"
fi

