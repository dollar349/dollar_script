#!/bin/sh


REPO_URL="https://gitlab.com/vertiv-co/its/TEMP_TEST_aci/ACI/inc-dev.git"
#REPO_URL="https://gitlab.com/vertiv-co/its/embedded/aci/blueplate-dev.git"
#REPO_URL="https://gitlab.com/vertiv-co/its/embedded/cobra/cobra-dev.git"

if [[ $# -gt ${optarg} ]]; then
    FOLDER_NAME="${@: -1}"
    echo "clone ${REPO_URL} to $FOLDER_NAME"
    if [[ ${BRANCH} != "" ]]; then
        echo "switch branch to ${BRANCH}"
        git clone -b ${BRANCH} ${REPO_URL} ${FOLDER_NAME}
    else
        git clone ${REPO_URL} ${FOLDER_NAME}
    fi
    ## if folder name includes platform name execute getlayer.sh
    cd ${FOLDER_NAME}
    PLATFORM_SUPPORT_LIST=$(find . -maxdepth 1 -type d -name "build-*" | awk -F 'build-' '{print $NF}' | tr '\n' ' ')
    # sort the platform list (More words in front)
    SORT_LIST=$(echo $PLATFORM_SUPPORT_LIST |  tr ' ' '\n' | awk '{print length, $0}' |  sort -n -r | cut -d " " -f2-)
    for platform in ${SORT_LIST}
    do
        if test "${FOLDER_NAME#*${platform}}" != "${FOLDER_NAME}" ; then
            ./getlayers.sh ${platform}
            break
        fi
    done
    cd --
else
    echo "Please enter folder name"
fi

