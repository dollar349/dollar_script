#!/bin/sh
ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")

CURRENT_PWD=`pwd`
TARGET_FILE="getlayers.sh"
EXTRA_OPTION=""

VERTIV_MACHINE_FILE=".MACHINE"

# Check push_update.sh script exist
if test ! -f ${SCRIPTPATH}/push_update.sh; then
    echo "push_update.sh not found"
    exit 1
fi

# Find Project real path (PRJ_PATH)
CPWD=`pwd`
while [ "${CPWD}" != '/' ];
do
    if test -f ${TARGET_FILE}; then
        PRJ_PATH=`pwd`
        break;
    fi
    cd ..
    CPWD=`pwd`  
done

# Find Build folder real path (BUILD_PATH)
_MACHINE=`cat ${PRJ_PATH}/${VERTIV_MACHINE_FILE}`
BUILD_PATH="${PRJ_PATH}/build-${_MACHINE}"

# Find machine name
CONF_FILE="${BUILD_PATH}/conf/local.conf"
MACHINE_NAME=`grep ^MACHINE ${CONF_FILE} | awk -F '=' '{print $NF}' | sed 's/^[ \t]*//g' | sed 's/^"*//g' | sed 's/"*$//g'`

# Set image path
IMAGE="${BUILD_PATH}/tmp/deploy/images/${MACHINE_NAME}/obmc-phosphor-image-${MACHINE_NAME}.static.mtd.tar"

# Check image exist
if test ! -f ${IMAGE}; then
    echo "${IMAGE} not found"
    exit 1
fi

print_help()
{
    echo ""
    echo "This script helps to run push_update.sh (update this project's output image)"
    echo "Image will use : ${IMAGE}"
    echo "  Usage: $(basename $0) -I \${target IP} -P \${PASSWORD} [options] ..."
    echo "  Example: ./$(basename $0) -I 10.162.247.34 -P 1"
    echo "  option: "
    echo "    -U [USER]"
    echo "        admin as by default"
    echo "    -A"
    echo "        Update 2nd Flash"
    echo "    -r"
    echo "        reset to default"
}

while getopts 'I:P:U:rAho' OPT; do
    case $OPT in
        I)
            IP=$OPTARG
            ;;
        P)
            PASSWD=$OPTARG
            ;;
        U)
            user=$OPTARG
            ;;
        A)
            EXTRA_OPTION+="-A "
            ;;
        r)
            EXTRA_OPTION+="-r "
            ;;
        o)  
            EXTRA_OPTION+="-o "
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

if [ "${IP}" = "" ];then
    echo "Please provide the target IP address by [-I \${target IP}]"
    exit 1
fi

if [ "${PASSWD}" = "" ];then
    echo "Please provide the Password for ${user} by [-P \${PASSWORD}]"
    exit 1
fi

# Execute push_update.sh
${SCRIPTPATH}/push_update.sh -i ${IMAGE} -P ${PASSWD} -I ${IP} ${EXTRA_OPTION}
