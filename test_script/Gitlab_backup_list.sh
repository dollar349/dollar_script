#!/bin/bash

current_path=$(pwd)
BACKUP_LIST=("https://gitlab.com/vertiv-co/its/embedded/cobra/cobra-dev.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/inc-dev.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/inc-home.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/inc-home.wiki.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/blueplate-dev.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/BluePlate.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/BluePlate.wiki.git" \
             "https://gitlab.com/vertiv-co/its/developers/dowang-vertiv/obmc_qemu_static.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/aci-ci-template.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/aci-ci-template.wiki.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/cobra-sip.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/inc-data-dictionary-read-only.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/cobra-redfish-sip-settings.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/icb-agent.git" \
             "https://gitlab.com/vertiv-co/its/embedded/common/redfish-schemas.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/ipsl-home.git" \
             "https://gitlab.com/vertiv-co/its/embedded/cobra/ipsl-home.wiki.git" \
             "https://gitlab.com/vertiv-co/its/embedded/team-space/customersolutions.wiki.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/meta-blueplate-apps.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/meta-blueplate-platform.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/blueplate-redfish.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/blueplate-ipmi-handler.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/aci-ipmi.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/blueplate-redfish-advanced.git" \
             "https://gitlab.com/vertiv-co/its/embedded/aci/blueplate-peci.git" \
              )


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

#curl -s -H "PRIVATE-TOKEN:${ACCESS_TOKEN}" "${API_V4_URL}/groups/${GROUP_ID}/projects" | jq '.[].web_url' >> ${BACKUP_LIST}
for i in ${BACKUP_LIST[@]}
do
    m=${i#https://gitlab.com/vertiv-co/its/}
    f=${m%/*.*}
    mkdir -p ${current_path}/${f} && cd ${current_path}/${f}
    git clone --bare ${i}
done
