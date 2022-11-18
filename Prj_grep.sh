#!/bin/sh
ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")

source ${SCRIPTPATH}/_GET_PROJECT_INFO.sh
if test "${PRJ_INFO}" != "OK" ; then
    echo "Project path not found"
    exit 1
fi
find ${PRJ_PATH} -type f -name "*" -o -path "${PRJ_PATH}/build-*" -prune | grep -v "^${PRJ_PATH}/build-" | grep -v ".svn" | xargs grep -Hn "$1" --color