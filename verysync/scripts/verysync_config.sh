#!/bin/sh
#2017/05/05 by verysync
#version 0.2

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export verysync_`

export HOME=/root

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

create_conf(){
    if [ ! -d $verysync_home ];then
        $KSROOT/verysync/verysync -generate="$verysync_home/.verysync" >>/tmp/verysync.log
    fi
}

lan_ip=`nvram get lan_ipaddr_rt`
weburl="http://$lan_ip:$verysync_port"
get_ipaddr(){
    if [ $verysync_wan_enable == 1 ];then
        ipaddr="0.0.0.0:$verysync_port"
    else
        ipaddr="$lan_ip:$verysync_port"
    fi
    # sed -i "/<gui enabled/{n;s/[0-9.]\{7,15\}:[0-9]\{2,5\}/$ipaddr/g}" $conf_Path/config.xml
}

setup_iptables() {
	local ports="tcp:$verysync_port tcp:22330 udp:22331"
	for item in $ports; do
		local proto=${item%:*}
		local port=${item#*:}
		local rule="INPUT -p $proto --dport $port -j ACCEPT"
		if ! iptables -C $rule >/dev/null; then
			iptables -I $rule
		fi
	done
}

setup_optimize() {
    echo 204800 > /proc/sys/fs/inotify/max_user_watches

    setup_swap
}

setup_swap() {
    local swapfile="$verysync_home/.verysync/swapfile"
    if [[ ! -f "$swapfile" -a "$verysync_swap_enable" == "1" ]]; then
        dd if=/dev/zero of="$swapfile" count=512 bs=1M
        chmod 600 "$swapfile"
        mkswap "$swapfile"
    fi

    if [[ -f "$swapfile" ]]; then
        swapon "$swapfile"
    fi
}

start_verysync(){
    export GOGC=30

    setup_iptables
    setup_optimize

    dbus set verysync_version=`/koolshare/verysync/verysync -version|awk '{print $2}'`
    $KSROOT/verysync/verysync -home="$verysync_home/.verysync" -gui-address $ipaddr >/dev/null 2>&1 &
    #cru d verysync
    #cru a verysync "*/10 * * * * sh $KSROOT/scripts/verysync_config.sh"

    sleep 1

    local i=10
	until [ -n "$VSPID" ]
	do
		i=$(($i-1))
		VSPID=`pidof verysync`
		if [ "$i" -lt 1 ];then
			echo_date "微力同步 进程启动失败！"
			close_in_five
		fi
		sleep 1
	done
    dbus set verysync_webui="$weburl"
    echo_date "verysync启动成功，pid：$VSPID"


}

stop_verysync(){
    killall verysync
    sleep 1
    dbus set verysync_webui="-"
}

update_disklist() {
    dbus set verysync_disklist=`df -h $1  | grep mnt| awk '
        BEGIN { ORS = ""; print " [ "}
        /Filesystem/ {next}
        { printf "%s{\"name\": \"%s\", \"size\": \"%s\", \"usage\": \"%s\", \"free\": \"%s\", \"mount_point\": \"%s\"}",
              separator, $1, $2, $3, $4, $6
          separator = ", "
        }
        END { print " ] " }
    '`
}

case $ACTION in
start)
    if [ "$verysync_home" = "" ]; then
        update_disklist
        logger "[软件中心]: 微力同步 您还未设置应用数据目录"
        exit 1
    fi
    mkdir -p "$verysync_home"
    if [[ $? -ne 0 ]]; then
        update_disklist
        logger "[软件中心]: 微力同步 您设置的应用数据目录${verysync_home}/.verysync 无法创建，请检查路径的有效性"
        exit 1
    fi

	if [ "$verysync_enable" = "1" ]; then
        logger "[软件中心]: 启动微力同步"
        create_conf
        get_ipaddr
        start_verysync
    else
        update_disklist
		logger "[软件中心]: 微力同步未设置开启,跳过！"
	fi
	;;
stop)
	stop_verysync
	;;
*)
    if [ "$verysync_enable" = "1" ]; then
        stop_verysync
        create_conf
        get_ipaddr
        start_verysync
	else
        stop_verysync
    fi
    update_disklist
    logger  '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
