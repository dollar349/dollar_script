#!/bin/bash
FIND_STRING=${1}
NEW_STRING=${2}
if test $# != 2; then
   echo "invalid input"
   exit 1 
fi 
grep -Hnrl "$1" . | xargs -i sed -i "s|${FIND_STRING}|${NEW_STRING}|g" {}
exit 0
