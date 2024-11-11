#!/bin/bash
# Author: Dollar.Wang
# Email: dollar@acsgconsults.com
# Date: 2024-10-31

SCRIPT_NAME=$(basename $0)
RULE_FILE="/etc/udev/rules.d/fix-tty-usb.rules"

print_help()
{
    echo ""
    echo "This script helps to create a specific name for a ttyUSB device."
    echo "  Usage:"
    echo "    * Create a name for a device:"
    echo "       ./$(basename $0) ttyUSB0 My_Console" 
    echo "    * Check the current rules."
    echo "       ./$(basename $0) -c" 
    echo "    * Check the in-use device."
    echo "       ./$(basename $0) -s" 
    echo " "
}

case "$1" in
    ""|"-h"|"-H")
        print_help
        exit 0
        ;;
    "-c")
        CHECK_RULE="Y"
        ;;
    "-s")
        CHECK_IN_USE="Y"
        ;;
esac

# Check the ${RULE_FILE}
if test -f ${RULE_FILE};then
    # The rules file exist
    if grep -q "${SCRIPT_NAME}" "${RULE_FILE}"; then
        if ! test -r "${RULE_FILE}" || ! test -w "${RULE_FILE}"; then
            # No Read/Write privilege
            echo change mod for file ${RULE_FILE}
            sudo chmod 766 ${RULE_FILE}
        fi
    else 
        echo "!! The file ${RULE_FILE} already exist !! and not create by this script"
        exit 1
    fi
else
    if test "${CHECK_RULE}" = "Y" -o "${CHECK_IN_USE}" = "Y";then
        echo "There were no rules on this machine before."
        exit 1
    fi
    # Create this file for the first time
    sudo touch ${RULE_FILE} && sudo chmod 766 ${RULE_FILE}
    echo "# This file create by ${SCRIPT_NAME}" > ${RULE_FILE}
fi

# Get current exist table
declare -A NAME_ARRAY
declare -A SERIAL_ARRAY
ID_SERIAL_STRING="{ID_SERIAL_SHORT}=="
SYMLINL_STRING="SYMLINK\+="
## Read ${RULE_FILE} line by line then create "NAME_ARRAY" & "SERIAL_ARRAY"
while IFS= read -r line; do
    test "${line:0:1}" = "#" && continue
    # if this line not include "ID_SERIAL_SHORT}==" string then continue
    test "${line#*${ID_SERIAL_STRING}}" = "${line}" && continue
    # if this line not include "SYMLINK+=" string then continue
    test "${line#*${SYMLINL_STRING}}" = "${line}" && continue
    
    serial_short=$(echo "$line" | grep -oP "${ID_SERIAL_STRING}\"\K[^\"]+")
    symlink=$(echo "$line" | grep -oP "${SYMLINL_STRING}\"\K[^\"]+")
    NAME_ARRAY[${symlink}]=${serial_short}
    SERIAL_ARRAY[${serial_short}]=${symlink}
done < "${RULE_FILE}"

if test "${CHECK_RULE}" = "Y";then
    for i in "${!SERIAL_ARRAY[@]}"; do
        echo "Serial Num [$i]: ${SERIAL_ARRAY[$i]}"
    done
    exit 0
fi

# Check the in-use device
if test "${CHECK_IN_USE}" = "Y";then
    for i in "${!NAME_ARRAY[@]}"; do
        if test -c "/dev/${i}";then
            TTYUSB_NUM=$(ls -l /dev/${i} | awk '{print $NF}')
            echo "[${NAME_ARRAY[${i}]}] /dev/${i} --> ${TTYUSB_NUM}"
        fi
    done
    exit 0
fi

# Check machine required tools (udevmem)
has() {
    type "$1" >/dev/null 2>&1
}
if ! has udevadm;then
    echo "Try to install udev tool by the following command!"
    echo "  $ sudo atp install udev"
    exit 1
fi

TTY_USB_DEVICE=${1}
TARGET_NAME=${2}

if test "${TARGET_NAME}" = "";then
    echo "!!!   Please specific a name   !!!"
    print_help
    exit 1
fi
# Check input file is a tty device?
if test ! -c "${TTY_USB_DEVICE}";then
    if test "${TTY_USB_DEVICE}" != "/dev/*";then
        TTY_USB_DEVICE="/dev/$1"
        if test ! -c "${TTY_USB_DEVICE}";then
            echo "not a device"
            exit 1
        fi
    fi
fi

get_dev_serial_short() {
    dev=$1
    udevadm info $1 | grep ID_SERIAL_SHORT | awk -F'=' '{print $NF}'
}

# Get Device serial number 
DEVICE_SERIAL=$(get_dev_serial_short ${TTY_USB_DEVICE})


# Check if this name is already in use.
if test "${NAME_ARRAY[${TARGET_NAME}]}" != ""; then
    echo "The \"${TARGET_NAME}\" alrady use by device [${NAME_ARRAY[${TARGET_NAME}]}]"
    exit 1
fi

# Check if this serial number already has a defined name.
if test "${SERIAL_ARRAY[${DEVICE_SERIAL}]}" = ""; then
    # New serial number. Append new rule to ${RULE_FILE}
    echo "SUBSYSTEM==\"tty\", ENV{ID_SERIAL_SHORT}==\"${DEVICE_SERIAL}\" SYMLINK+=\"${TARGET_NAME}\" ACTION==\"add\", TAG+=\"systemd\"" >> ${RULE_FILE}
else
    # Already define a name
    echo "The ${DEVICE_SERIAL} already define a name [${SERIAL_ARRAY[${DEVICE_SERIAL}]}]"
    read -p "Would you like to change it? (y/n): " ans
    if test "$ans" = "y" -o "$ans" = "Y" ; then
        TMP_FILE=".Rule_$((RANDOM))"
        sed "/${DEVICE_SERIAL}/s/\(SYMLINK+=\"\)[^\"]*\(\"\)/\1${TARGET_NAME}\"/" ${RULE_FILE} > ${TMP_FILE} && cat ${TMP_FILE} > ${RULE_FILE}
        rm -rf ${TMP_FILE} 
    else 
        echo "The ${DEVICE_SERIAL} still use the name [${SERIAL_ARRAY[${DEVICE_SERIAL}]}]"
        exit 0
    fi
fi