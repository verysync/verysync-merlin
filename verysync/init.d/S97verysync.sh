#!/bin/sh /etc/rc.common
#
# Copyright (C) 2016 verysync <admin@verysync.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

START=98
STOP=15

source /koolshare/scripts/base.sh
eval `dbus export verysync_`

start(){
	[ "$verysync_enable" == "1" ] && sh /koolshare/scripts/verysync_config.sh start
}

stop(){
	sh /koolshare/scripts/verysync_config.sh stop
}
