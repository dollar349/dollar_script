MY_SERVER_IP="192.168.11.8"
CI_API_V4_URL="http://192.168.11.32:8083/api/v4"
TARGET_MACHINE="c55cal"
MY_PROJECT_NAME="ECS_TEST"
ACCESS_TOKEN="glpat-31N5u_t3UXNW6N_cTxCP"
CI_PROJECT_ID="29"

LINK_URL="http://${MY_SERVER_IP}/${MY_PROJECT_NAME}/dailybuild/${TARGET_MACHINE}/today"
BADGE_URL="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/badges"

IMG_URL_FORMAT="https://img.shields.io/badge/${TARGET_MACHINE}%20Daily--build%20status"
# IMG_URL="${IMG_URL_FORMAT}-${NEW_STATUS}-${NEW_COLOR}"
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
IMG_URL="${IMG_URL_FORMAT}-${NEW_STATUS}-${NEW_COLOR}"

PER_PAGE=100
PAGE=1
# Get Badge id by name ($TARGET_MACHINE) 
while [ 1 ];do
    RESPONSE=$(curl -s -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/badges?page=${PAGE}&per_page=${PER_PAGE})
    BAGDE_ID=$(echo ${RESPONSE} | jq ".[] | select(.name == \"${TARGET_MACHINE}\") | .id")
    if test "${BAGDE_ID}" != ""; then
        #DELETE_URL=`echo ${DELETE_URL} | tr -d '"'`
        break
    fi
    COUNT=$(echo ${RESPONSE} | jq '. | length')
    if [[ "$COUNT" == "" ||  "$COUNT" -lt "${PER_PAGE}" ]]; then
        break
    fi
    PAGE=$((PAGE+1))
done

if test "${BAGDE_ID}" != "";then
    # Update image url
    curl -X PUT -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" -d "image_url=${IMG_URL}" ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/badges/${BAGDE_ID}
else
    # Create Badge
    curl -X POST -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" -d "name=${TARGET_MACHINE}&link_url=${LINK_URL}&image_url=${IMG_URL}" ${BADGE_URL}
fi


