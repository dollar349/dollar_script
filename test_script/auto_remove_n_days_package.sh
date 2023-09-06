#!/bin/bash


ID=41754391
KEEP_N_DAYS=20
KEEP_DATE=$(date +%Y-%m-%d --date="-${KEEP_N_DAYS} day")

MACHINE_LIST="inc-ast2600evb inc-ipsl inc"


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

JSON_TMP_FILE=package.json
DELETE_LIST=delete.json
PER_PAGE=100
echo "Starting to delete image files before ${KEEP_DATE}"
for machine in ${MACHINE_LIST}; do
    # Grep the URLs that need to be deleted
    PAGE=1
    echo "" > ${DELETE_LIST}
    while [ 1 ];do
        curl -s -o ${JSON_TMP_FILE} -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" "${API_V4_URL}/projects/${ID}/packages?page=${PAGE}&per_page=${PER_PAGE}"
        cat ${JSON_TMP_FILE}  | jq ".[] | select(.name == \"DailyBuild-${machine}\" and .version < \"${KEEP_DATE}\") | ._links.delete_api_path" >> ${DELETE_LIST}

        COUNT=`cat ${JSON_TMP_FILE} | jq '. | length'` 
        if [[ "$COUNT" == "" ||  "$COUNT" -lt "${PER_PAGE}" ]]; then
            break
        fi
        PAGE=$((PAGE+1))
        echo $PAGE
    done
    # Start delete file
    while IFS= read -r line
    do
        if test "${line}" != "";then
            DELETE_URL=$(echo ${line} | tr -d '"')
            curl -s --request DELETE -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" ${DELETE_URL}
        fi
    done < ${DELETE_LIST}
done

rm -rf ${JSON_TMP_FILE}
rm -rf ${DELETE_LIST}
