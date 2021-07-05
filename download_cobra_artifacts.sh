#!/bin/bash
TOKEN=`cat ~/TOKEN.txt`
if [ $# -eq 1 ]; then
   ID=`echo ${1} | awk -F'/' '{print $NF}'`

   curl -v -L -s \
          -u ":${TOKEN}" \
          -o ${ID}.zip \
          https://api.github.com/repos/vertiv-it-systems/cobra-dev/actions/artifacts/${ID}/zip  && \
   unzip ${ID}.zip && \
   rm ${ID}.zip
          
else
   echo "please enter the url or id"
fi
