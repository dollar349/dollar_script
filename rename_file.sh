#!/bin/bash
FIND_STRING=${1}
NEW_STRING=${2}
if test $# != 2; then
   echo "invalid input"
   exit 1 
fi 

echo "The following file will change to..."
echo "***************************************"
FILE_LIST=$(find . -name "*${FIND_STRING}*")
for f in ${FILE_LIST}
do
    NEW_NAME=$(echo ${f} | sed s/${FIND_STRING}/${NEW_STRING}/)
    echo "${f} -- > ${NEW_NAME}"
done
echo "***************************************"
while true; do
    read -p "Do you Agree? [y/n]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
for f in ${FILE_LIST}
do
    NEW_NAME=$(echo ${f} | sed s/${FIND_STRING}/${NEW_STRING}/)
    mv $f ${NEW_NAME}
done