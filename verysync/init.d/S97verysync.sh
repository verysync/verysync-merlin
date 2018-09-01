#!/bin/sh
#2017/05/05 by verysync
#version 0.2

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

export HOME=/root

hdd=`dbus get verysync_home`

if [[ "$hdd" == "" ]]; then
    exit 1
fi

verysync_home="$hdd/.verysync"

i=0
while [[ $i -le 1000 ]]; do
    if [ ! -d "$verysync_home" ]; then
        echo "waiting mount point $verysync_home";
        sleep 1
        i=`expr $i + 1`
    else
        . /koolshare/scripts/verysync_config.sh
        break
    fi
done &
