#!/bin/sh
ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")

SERVER_IP="10.162.243.143"
PRJ_NAME="aci"
MACHINE=""
MACHINE_LIST=$(curl -s http://${SERVER_IP}/${PRJ_NAME}/dailybuild/advanced/ | grep -oE 'href="([^"]+/)?[^/]+/"' | awk -F\" '{print $2}' | sed 's/\///g')
DAY_SELECT=""
DEBUG=""
# Check tftp_update.sh script exist
if test ! -f ${SCRIPTPATH}/tftp_update.sh; then
    echo "tftp_update.sh not found"
    exit 1
fi

print_help()
{
    echo ""
    echo "This script helps to update daily-builds firmware to your target."
    echo "  Usage: $(basename $0) -I \${target IP} -P \${PASSWORD} [options] ..."
    echo "  Example: ./$(basename $0) -I 10.162.247.34 -P 1"
    echo "  option: "
    echo "    -M [Machine]"
    echo "        Give this option will not pop up Machine select menu"
    echo "    -s "
    echo "        The default image uses the latest daily-build, this option can select another day"
    echo "    -U [USER]"
    echo "        admin as by default"
    echo "    -A"
    echo "        Update 2nd Flash"
    echo "    -r"
    echo "        reset to default"
    
}

while getopts 'M:I:P:U:rAhosd' OPT; do
    case $OPT in
        M)
            MACHINE=$OPTARG
            ;;
        d)
            DEBUG="Y"
            ;;
        s)
            DAY_SELECT="Y"
            ;;
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

if test "${IP}" = "" ;then
    echo "Please provide the target IP address by [-I \${target IP}]"
    exit 1
fi

if test "${PASSWD}" = "" ;then
    echo "Please provide the Password for ${user} by [-P \${PASSWORD}]"
    exit 1
fi

if test "${MACHINE}" = "" ;then
    echo "Please select machine : "
    select opt in ${MACHINE_LIST}
    do
        MACHINE=${opt}
        if test "${opt}" = "" ; then
        echo "bye bye!"
        exit 1
        continue;
        fi
        break;
    done
fi

if test "${MACHINE_LIST#*${MACHINE}}" = "${MACHINE_LIST}" ; then
    echo "${MACHINE} not support!!"
    exit 1
fi

TFTP_SERVER_IP=${SERVER_IP}
if test "${DAY_SELECT}" = "";then
    TFTP_PATH="${PRJ_NAME}/dailybuild/advanced/${MACHINE}/today"

    # Get the correct date from today's image folder
    IMAGE_DATE=$(curl -s http://${SERVER_IP}/${TFTP_PATH}/ | grep -oE  'image_date_[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{4}' | sed 's/image_date_//' | head -1)
    if test "${IMAGE_DATE}" = "";then
        echo "Cannot find any date folder in path [http://${SERVER_IP}/${TFTP_PATH}/], so exit"
        exit 1
    fi
else
    # Let user select image
    DAY_LIST=$(curl -s http://${SERVER_IP}/${PRJ_NAME}/dailybuild/advanced/${MACHINE}/ | grep -oE 'href="[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{4}' | sed 's/href="//')
    echo "Please choose which day's image to run firmware udate:"
    select opt in ${DAY_LIST}
    do
        IMAGE_DATE=${opt}
        if test "${opt}" = "" ; then
        echo "bye bye!"
        exit 1
        continue;
        fi
        break;
    done
    TFTP_PATH="${PRJ_NAME}/dailybuild/advanced/${MACHINE}/${IMAGE_DATE}"
fi
# Get the correct image name from today's image folder
IMAGE_NAME=$(curl -s http://${SERVER_IP}/${TFTP_PATH}/ | grep -oE 'obmc-phosphor-image[^"<]+[mmc|mtd].tar"' | sed 's/"//g')
if test "${IMAGE_NAME}" = "";then
    echo "Cannot find image in path [http://${SERVER_IP}/${TFTP_PATH}/], so exit"
    exit 1
fi

echo "##########################################"
echo "# Daily build's image info                "
echo "#    Date is ${IMAGE_DATE}                "
echo "#    Image name is ${IMAGE_NAME}          "
echo "##########################################"
echo "Do you agree? (y/n)"
read ans
if test "${ans}" = "y" -o "${ans}" = "Y";then
    if test "${DEBUG}" != "";then
        echo ${SCRIPTPATH}/tftp_update.sh -i ${TFTP_SERVER_IP}/${TFTP_PATH}/${IMAGE_NAME} -P ${PASSWD} -I ${IP} ${EXTRA_OPTION}
    else
        ${SCRIPTPATH}/tftp_update.sh -i ${TFTP_SERVER_IP}/${TFTP_PATH}/${IMAGE_NAME} -P ${PASSWD} -I ${IP} ${EXTRA_OPTION}
    fi
else
    exit 0
fi
