#!/bin/sh
ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")

EXTRA_OPTION=""

VERTIV_MACHINE_FILE=".MACHINE"

# Check tftp_update.sh script exist
if test ! -f ${SCRIPTPATH}/tftp_update.sh; then
    echo "tftp_update.sh not found"
    exit 1
fi

if test ! -f ${SCRIPTPATH}/_GET_PROJECT_INFO.sh; then
    echo "_GET_PROJECT_INFO.sh not found"
    exit 1
fi

source ${SCRIPTPATH}/_GET_PROJECT_INFO.sh
if test "${PRJ_INFO}" != "OK" ; then
    echo "Project path not found"
    exit 1
fi

# Check image exist
if test ! -f ${PRJ_IMAGE}; then
    echo "${PRJ_IMAGE} not found"
    exit 1
fi

print_help()
{
    echo ""
    echo "This script helps to run tftp_update.sh (copid this project's image to /tftpboot/\${USER})"
    echo "Image will use : ${PRJ_IMAGE}"
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

TFTP_SERVER_IP=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
if [ "${TFTP_SERVER_IP}" = "" ];then
    echo "Cannot get server IP!"
    echo "Cmd: \"ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}'\""
    exit 1
fi

mkdir -p /tftpboot/${USER} 2>/dev/null
if [ $? != "0" ];then
    echo "Cannot create folder [/tftpboot/${USER}]"
    exit 1
fi

# Copy image to /tftpboot
cp ${PRJ_IMAGE} /tftpboot/${USER}/.

IMAGE_NAME=$(echo ${PRJ_IMAGE} | awk -F '/' '{print $NF}')

# Execute push_update.sh
${SCRIPTPATH}/tftp_update.sh -i ${TFTP_SERVER_IP}/${USER}/${IMAGE_NAME} -P ${PASSWD} -I ${IP} ${EXTRA_OPTION}
