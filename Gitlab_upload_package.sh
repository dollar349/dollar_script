#!/bin/sh
# Create Repository ID array
declare -A RID_ARRAY
RID_ARRAY[gadget_drivers]="40134551"
RID_ARRAY[audio_drivers]="40134539"
RID_ARRAY[video_drivers]="40134643"
RID_ARRAY[libaspeed]="40134561"

API_V4_URL="https://gitlab.com/api/v4"

print_help()
{
    echo ""
    echo "This script helps to Upload file to Gitlab Package Registry"
    echo "Upload package to a Repository. "
    echo " In addition to the Repository ID, you need to specify [Package name]/[Version]/[File name]" 
    echo "  Usage: $(basename $0) -r \${Repository ID} -p \${Package name} -v \${Version} -f \${Specify an file to upload}"
    echo "  option: "
    echo "    -F [Specify another name]"
    echo "        Specify another name in the \"Package Registry\""
}


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

UPLOAD_FILE_NAME=""
while getopts 'r:p:v:f:F:h' OPT; do
    case $OPT in
        r)  
            REPO_ID=$OPTARG
            ;;
        p)  
            PACKAGE_NAME=$OPTARG
            ;;
        v)  
            PACKAGE_VERSION=$OPTARG
            ;;
        f)  
            UPLOAD_FILE=$OPTARG
            ;;
        F)  
            UPLOAD_FILE_NAME=$OPTARG
            ;;
        h)
            print_help
            exit 0
            ;;
        ?)
            print_help
            exit 1
            ;;
    esac
done

if test "${1}" = "getid"; then
    if test "${2}" != ""; then
        URL=`echo ${2} | sed "s/.*gitlab.com\///" | sed "s/\//%2F/g"`
    else
        echo "Please provide the URL of the Repository you want to query"
    fi
    getVertivAccessToken
    curl -s --header "PRIVATE-TOKEN:${ACCESS_TOKEN}" "${API_V4_URL}/projects/${URL}" | jq .id
    exit 0
fi

if test "${UPLOAD_FILE}" = "" \
         -o "${PACKAGE_NAME}" = "" \
         -o "${REPO_ID}" = "" \
         -o "${PACKAGE_VERSION}" = "" ; then
    print_help
    exit 1
fi

if test "${UPLOAD_FILE_NAME}" = ""; then
    UPLOAD_FILE_NAME=$(basename ${UPLOAD_FILE})
fi

# If given a repo name
re='^[0-9]+$'
if ! [[ ${REPO_ID} =~ ${re} ]] ; then
   REPO_ID=${RID_ARRAY[${REPO_ID}]}
   if test "${REPO_ID}" = ""; then
        print_help
        echo "ERROR:   Repository ID not found"
        exit 1
   fi
fi

# Get access token from 
getVertivAccessToken

curl --header "PRIVATE-TOKEN:${ACCESS_TOKEN}" --upload-file ${UPLOAD_FILE} "${API_V4_URL}/projects/${REPO_ID}/packages/generic/${PACKAGE_NAME}/${PACKAGE_VERSION}/${UPLOAD_FILE_NAME}"