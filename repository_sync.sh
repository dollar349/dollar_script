#!/bin/bash
GITHUB_URL="https://ghe.int.vertivco.com"
MYACCOUNT="dowang"

declare -A ORG_ARRAY
ORG_ARRAY[meta-blueplate-apps]="ETA"
ORG_ARRAY[meta-blueplate-platform]="ETA"
ORG_ARRAY[blueplate-dev]="ETA"
ORG_ARRAY[blueplate-redfish]="ETA"
ORG_ARRAY[serial-over-websocket]="ETA"
ORG_ARRAY[obmc-console]="FOSS"

#ORG_ARRAY=([meta-blueplate-apps]="ETA" \
#           [meta-blueplate-platform]="ETA" \
#           [blueplate-dev]="ETA" \
#           [blueplate-redfish]="ETA" \
#           [obmc-console]="FOSS" \
#           )

REPO=$1

if test "$REPO" = "";then
    select opt in "${!ORG_ARRAY[@]}"
    do
        if [[ $opt == "" ]]; then
            echo "Bye Bye!"
            exit 1
        fi
        REPO=${opt}
        break;
    done
fi

if test "${ORG_ARRAY[${REPO}]}" = "";then
    echo "Cannot get Organizations for this repository"
    exit 1
fi

tmp_folder="${REPO}_$((RANDOM))"
git clone ${GITHUB_URL}/${MYACCOUNT}/${REPO} ${tmp_folder} && cd ${tmp_folder}
git remote add up ${GITHUB_URL}/${ORG_ARRAY[${REPO}]}/${REPO} && git fetch up
git rebase up/master && git push 
cd .. && echo "delete tmp folder ${tmp_folder}" && rm -rf ${tmp_folder}
