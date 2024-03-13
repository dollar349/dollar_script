#!/bin/bash

ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")

# Check _GET_GIT_LOCAL_TOKEN.sh script exist
if test ! -f ${SCRIPTPATH}/_GET_GIT_LOCAL_TOKEN.sh; then
    echo "_GET_GIT_LOCAL_TOKEN.sh not found"
    exit 1
fi

# Get TOKEN
source ${SCRIPTPATH}/_GET_GIT_LOCAL_TOKEN.sh
# GetGitAccessToken dollarwang.synology.me
TOKEN=$(GetGitAccessToken dollarwang.synology.me%3a50080)
if test "$?" != "0";then
    echo "Get Access Token failed"
    exit 1
fi

declare -A GroupList
GroupList["Vertiv"]=23
GroupList["Vertiv/embedded"]=9
GroupList["Vertiv/embedded/aci"]=10
GroupList["Vertiv/embedded/cobra"]=25
GroupList["Vertiv/embedded/common"]=26
GroupList["Vertiv/embedded/team-space"]=27
GroupList["Vertiv/FOSS"]=7

GROUP_ID=""

if test "${1}" == "";then
    echo "Please enter the name for the repository you want to create"
    exit 1
fi

REPO_NAME=${1}

echo "Create your Repository in which Group?"
select opt in "${!GroupList[@]}"
do
    
    if [[ $opt == "" ]]; then
    echo "bye bye!"
    continue;
    fi
    GROUP_ID=${GroupList[${opt}]}
    echo ${opt} GROUP_ID is ${GROUP_ID}
    break;
done

curl -s -d "path=${REPO_NAME}&namespace_id=${GROUP_ID}" -X POST "http://dollarwang.synology.me:50080/api/v4/projects" -H "PRIVATE-TOKEN:${TOKEN}"