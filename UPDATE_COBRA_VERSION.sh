#!/bin/bash

if [[ $1 != "" ]]; then
   find . -name local.conf | xargs -i sed -i "s/COBRA_VERSION =.*/COBRA_VERSION = \"${1}\"/" {}
else
   echo "please give a string"
fi

