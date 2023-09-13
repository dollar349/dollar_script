#!/bin/bash


GROUP_ID=58948732
BACKUP_LIST="backup_list"

API_V4_URL="https://gitlab.com/api/v4"
ACCESS_TOKEN=""
getVertivAccessToken()
{
    local git_credentials=""
    local token_tmp=""

    if [ ! -f ${HOME}/.git-credentials ]; then
        echo "${HOME}/.git-credentials not found."
        return 1
    fi

    git_credentials="$(cat ${HOME}/.git-credentials | grep -v '^#' | grep "gitlab.com")"

    if test "x${git_credentials}" = "x"; then
        echo "Credentials for gitlab.com not found."
        return 1
    fi

    token_tmp="$(echo ${git_credentials} | awk -F '@' '{print $1}' | awk -F '//' '{print $NF}')"

    if test "${token_tmp}" = ""; then
         echo "Access token for gitlab.com not found."
         return 1
    fi

    if [ $(echo "${token_tmp}" | grep -i ":" | wc -w) -gt 0 ]; then
        # remove username.
        ACCESS_TOKEN="$(echo ${token_tmp} | awk -F ':' '{print $NF}')"
    else
        ACCESS_TOKEN="${token_tmp}"
    fi
}

# Get access token
getVertivAccessToken

curl -s -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" "${API_V4_URL}/groups/${GROUP_ID}/projects" | jq '.[].web_url' >> ${BACKUP_LIST}
while IFS= read -r line
do
    if test "${line}" != "";then
        
        REPO_URL=$(echo ${line} | tr -d '"')
        git clone --bare ${REPO_URL}
        #echo  ${REPO_URL}
    fi
done < ${BACKUP_LIST}
