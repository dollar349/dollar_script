#!/bin/bash
GetGitAccessToken()
{
    local git_credentials=""
    local token_tmp=""
    local GIT_URL=${1}
    local ACCESS_TOKEN=""
    if [ ! -f ${HOME}/.git-credentials ]; then
        echo "${HOME}/.git-credentials not found."
        return 1
    fi

    git_credentials="$(cat ${HOME}/.git-credentials | grep -v '^#' | grep ${GIT_URL} | head -n 1)"

    if test "x${git_credentials}" = "x"; then
        echo "Credentials for ${GIT_URL} not found."
        return 1
    fi

    token_tmp="$(echo ${git_credentials} | awk -F '@' '{print $1}' | awk -F '//' '{print $NF}')"

    if test "${token_tmp}" = ""; then
         echo "Access token for ${GIT_URL} not found."
         return 1
    fi

    if [ $(echo "${token_tmp}" | grep -i ":" | wc -w) -gt 0 ]; then
        # remove username.
        ACCESS_TOKEN="$(echo ${token_tmp} | awk -F ':' '{print $NF}')"
    else
        ACCESS_TOKEN="${token_tmp}"
    fi
    echo ${ACCESS_TOKEN}
    return 0
}