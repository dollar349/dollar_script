#!/bin/bash

print_help()
{
    echo ""
    echo "This script helps to Restart Global Protect VPN"
    echo "  Usage: $(basename $0) [options] ..."
    echo "  Example: ./$(basename $0)"
    echo "  option: "
    echo "    -h "
    echo "        print help"
    echo "    -l "
    echo "        list all processes related with GlobalProtect VPN"

}

while getopts 'Hhl' OPT; do
    case $OPT in
        l)
            LIST="true"
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

KILL_PROCESS()
{
    pids=$(ps aux | grep globalprotect | grep ${1} | grep -v 'grep' | awk '{print $2}')
    if [ -z "$pids" ]; then
    echo "No ${1} processes found."
    else
    echo "Killing ${1} processes: $pids"
    sudo kill -9 $pids
    fi
}

if test "${LIST}" == "true";then
    ps aux | grep global
    exit 0
fi

KILL_PROCESS PanGPUI
sleep 1
KILL_PROCESS PanGPA
sleep 1
KILL_PROCESS PanGPS
sleep 1