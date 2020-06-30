#!/bin/sh

ORG="vertiv-it-systems"
BRANCH=""
SCRIPT_NAME=${0##*/} 
REPO=$(echo ${SCRIPT_NAME} | sed 's/^.*_//g' | sed 's/\.sh$//g' )


# Print help.
print_help()
{
    echo ""
    echo "This script helps to clone repository from ghe.int.vertivco.com server"
    echo "  Usage: $(basename $0) [options] (folder name)"
    echo "  option: "
    echo "     -r [repository] "
    echo "         default repository name is xxx; the xxx is from this scirpt's name create_xxxx.sh"
    echo "     -o [organizations] "
    echo "         default Organizations is vertiv-it-systems"
    echo "     -b [branch] "
    echo "         default branch is master"
    echo ""
    echo ""
    echo ""
}
optarg="0"
while getopts 'b:o:r:[hH]' OPT; do
    case $OPT in
        r)
            REPO="$OPTARG"
            optarg=`expr ${optarg} + 2`
            ;;
        o)
            ORG="$OPTARG"
            optarg=`expr ${optarg} + 2`
            ;;
        b)
            BRANCH="$OPTARG"
            optarg=`expr ${optarg} + 2`
            ;;
        [Hh])
            print_help
            exit 0
            ;;
        ?)
            print_help
            exit 1
            ;;
    esac
done

REPO_URL="https://github.com/${ORG}/${REPO}.git"
#REPO_URL="git@github.com:${ORG}/${REPO}.git"

if [[ $# -gt ${optarg} ]]; then
    FOLDER_NAME="${@: -1}"
    echo "clone ${REPO_URL} to $FOLDER_NAME"
    if [[ ${BRANCH} != "" ]]; then
        echo "switch branch to ${BRANCH}" 
        git clone -b ${BRANCH} ${REPO_URL} ${FOLDER_NAME} 
    else
        git clone ${REPO_URL} ${FOLDER_NAME} 
    fi
    ## if folder name includes platform name execute getlayer.sh
    cd ${FOLDER_NAME}
    PLATFORM_SUPPORT_LIST=$(find ${CP_SSTATECACHE_PATH} -maxdepth 1 -type d -name "build-*" | awk -F 'build-' '{print $NF}' | tr '\n' ' ')
    for platform in ${PLATFORM_SUPPORT_LIST}
    do
        if test "${FOLDER_NAME#*${platform}}" != "${FOLDER_NAME}" ; then
            ./getlayers.sh ${platform}
			break
        fi
    done
    cd --
else 
    echo "Please enter folder name"
fi

