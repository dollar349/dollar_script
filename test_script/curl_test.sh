MY_SERVER_IP="192.168.11.8"
CI_API_V4_URL="http://192.168.11.32:8083/api/v4"
TARGET_MACHINE="c55cal"
MY_PROJECT_NAME="ECS_TEST"
ACCESS_TOKEN="glpat-31N5u_t3UXNW6N_cTxCP"
CI_PROJECT_ID="29"

LINK_URL="http://${MY_SERVER_IP}/${MY_PROJECT_NAME}/dailybuild/${TARGET_MACHINE}/today"
IMG_URL="https://img.shields.io/badge/${TARGET_MACHINE}%20status-Build-blue"
BADGE_URL="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/badges"

declare -A STATUS_TABLE
STATUS_TABLE["pass"]="green"
STATUS_TABLE["failed"]="red"
STATUS_TABLE["running"]="yellow"


print_help()
{
    echo ""
    echo "This script helps to update build status to porject badge"
    echo "  Usage: $(basename $0) \${Status}"
    echo ""
    echo "         [Status] support: ${!STATUS_TABLE[@]}"
    echo "  Example: "
    echo "         $(basename $0) pass" 
}

if test "${STATUS_TABLE[$1]}" = "";then
    print_help
    exit 1
fi
NEW_STATUS=${1}
NEW_COLOR=${STATUS_TABLE[${NEW_STATUS}]}

PER_PAGE=100
PAGE=1

JSON_TMP_FILE=package.json


curl -s -o ${JSON_TMP_FILE} -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/badges?page=${PAGE}&per_page=${PER_PAGE}"
BAGDE_ID=$(cat ${JSON_TMP_FILE} | jq ".[] | select(.name == \"${TARGET_MACHINE}\") | .id")
echo "BAGDE_ID=$BAGDE_ID"
rm ${JSON_TMP_FILE}
exit 1

# Get Badge id by name ($TARGET_MACHINE) 
while [ 1 ];do
    curl -s -o ${JSON_TMP_FILE} -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/badges?page=${PAGE}&per_page=${PER_PAGE}
    BAGDE_ID=$(cat ${JSON_TMP_FILE} | jq ".[] | select(.name == \"${TARGET_MACHINE}\") | .id")
    if test "${BAGDE_ID}" != ""; then
        #DELETE_URL=`echo ${DELETE_URL} | tr -d '"'`
        break
    fi
    COUNT=`cat ${JSON_TMP_FILE} | jq '. | length'` 
    if [[ "$COUNT" == "" ||  "$COUNT" -lt "${PER_PAGE}" ]]; then
        break
    fi
    PAGE=$((PAGE+1))
done
echo "BAGDE_ID = $BAGDE_ID"
exit 0
IMG_URL="https://img.shields.io/badge/${TARGET_MACHINE}%20status-${NEW_STATUS}-${NEW_COLOR}"
if test "${BAGDE_ID}" != "";then
    # Update image url
    curl -X PUT -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" -d "image_url=${IMG_URL}" ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/badges/${BAGDE_ID}
else
    # Create Badge
    curl -X POST -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" -d "name=${TARGET_MACHINE}&link_url=${LINK_URL}&image_url=${IMG_URL}" ${BADGE_URL}
fi


