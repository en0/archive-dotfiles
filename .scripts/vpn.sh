#!/usr/bin/env bash

ACTION=$1
USER=$(basename ~)
PROFILE_PATH="/home/${USER}/.ovpn_conf"
RUN_FILE="/var/run/${USER}_ovpn.run"
LOG_FILE="/var/log/${USER}_ovpn.log"

function usage {
    echo "Syntax: $0 [ start NAME | stop | status | list ]"
}

function is_running {
    OVPN_PID="$(ps -C openvpn -o pid=)"
    if [ -z "${OVPN_PID}" ]
    then
        echo 0
    fi
    echo $OVPN_PID
}

function extend_dns {
    if [ ! -e "${1}/resolve.conf" ]
    then
        return
    fi

    NEW_ENTRYS=$(mktemp)
    OLD_ENTRYS=$(mktemp)

    cat /etc/resolv.conf > $OLD_ENTRYS

    while read line
    do
        echo "$line # OVPN_ENTRY" > $NEW_ENTRYS
    done < "${1}/resolve.conf"

    sudo sh -c "cat $NEW_ENTRYS $OLD_ENTRYS > /etc/resolv.conf"

    rm $NEW_ENTRYS $OLD_ENTRYS
}

function unextend_dns {
    ORIG_ENTRYS=$(mktemp)
    grep -v "# OVPN_ENTRY" /etc/resolv.conf > $ORIG_ENTRYS
    sudo sh -c "cat $ORIG_ENTRYS > /etc/resolv.conf"
    rm $ORIG_ENTRYS
}

function abort {
    echo "ABORT: $1" >&2
    exit 1
}

function start_vpn {

    if [[ $(is_running) > 0 ]]
    then
        abort "openvpn is already running."
    fi

    PROFILE=$1
    if [ -z "$PROFILE" ]
    then
        usage >&2
        exit 1
    fi

    CONFIG_PATH="${PROFILE_PATH}/${PROFILE}"
    CONFIG=$(find $CONFIG_PATH -name "*.ovpn")

    if [ ! -e "${CONFIG}" ]
    then
        abort "Profile ${PROFILE} not found."
    fi

    cd $CONFIG_PATH
    echo "starting profile ${PROFILE}"
    sudo sh -c "openvpn --config $CONFIG 1> $LOG_FILE 2>&1" &
    sleep 3
    OVPN_PID=$[$(is_running)]
    sudo sh -c "echo ${OVPN_PID} > $RUN_FILE"
    if [[ $OVPN_PID > 0 ]]
    then
        echo "Success."
        extend_dns $CONFIG_PATH
    else
        echo "ERROR: Something whent wrong."
    fi
}

function stop_vpn {
    OVPN_PID="$(is_running | grep $(cat $RUN_FILE))"
    echo $OVPN_PID
    if [ -z "${OVPN_PID}" ]
    then
        abort "ERROR: Cannot find pid $(cat $RUN_FILE)"
    fi

    unextend_dns
    sudo kill $OVPN_PID
    sudo rm $RUN_FILE
}

function list_vpn {
    echo VPN Profiles
    echo ------------------------------
    for i in $(ls -d ${PROFILE_PATH}/*)
    do
        echo $(basename $i)
    done 
    echo ""
}

function status_vpn {

    OVPN_PID=$(is_running)
    EXPECTED_PID=$(cat $RUN_FILE)

    if [[ $OVPN_PID > 0 ]]
    then
        echo "VPN running with PID ${OVPN_PID}."
        if [[ $OVPN_PID != $[EXPECTED_PID] ]]
        then
            echo "WARNING: Expected PID ${EXPECTED_PID}."
        fi
    else
        echo "VPN is not running."
    fi
}

if [ -z "${ACTION}" ]
then
    usage >&2
    exit 1
fi

case $ACTION in
-h)
    usage
    ;;
start)
    start_vpn $2
    ;;
stop)
    stop_vpn
    ;;
list)
    list_vpn
    ;;
status)
    status_vpn
    ;;
unextend)
    unextend_dns /home/ilaird/.ovpn_conf/fw01-udp-1194-ilaird
    ;;
*)
    echo "Unknown option $1" >&2
    usage >&2
    exit 1
    ;;
esac
