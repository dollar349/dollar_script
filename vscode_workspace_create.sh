#!/bin/bash
print_help()
{
    echo ""
    echo "This script helps to create a mirror folder"
    echo "  Usage: $(basename $0) \${Souce folder} \${Target folder}"
}

if test "$#" != "2"; then
    echo "Invalid option !!!"
    print_help
    exit 1
fi

SOUCE_FOLDER=$1
TARGET_FOLDER=$2

if test ! -d ${SOUCE_FOLDER};then
    echo "[${SOUCE_FOLDER}] not a folder"
    exit 1
fi

if test ! -d ${TARGET_FOLDER};then
    mkdir -p ${TARGET_FOLDER}
fi

WORKSPACE_FILE="${TARGET_FOLDER}/$(basename "${SOUCE_FOLDER}").code-workspace"

cd ${SOUCE_FOLDER} && SOUCE_FOLDER=$(pwd) && cd -


echo '{'                     > ${WORKSPACE_FILE}
echo '        "folders": [' >> ${WORKSPACE_FILE}
FILE_LIST=$(ls --ignore=build* ${SOUCE_FOLDER})
for f in ${FILE_LIST}
do
    echo '                {' >> ${WORKSPACE_FILE} >> ${WORKSPACE_FILE} 
    echo "                        \"path\": \"${SOUCE_FOLDER}/${f}\"" >> ${WORKSPACE_FILE}
    echo '                },' >> ${WORKSPACE_FILE}
    #echo ${SOUCE_FOLDER}/${f} 
done
sed -i '$s/,//' ${WORKSPACE_FILE}
echo '        ]' >> ${WORKSPACE_FILE}
echo '}' >> ${WORKSPACE_FILE}

