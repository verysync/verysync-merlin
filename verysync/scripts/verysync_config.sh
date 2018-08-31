#!/bin/sh
#2017/05/05 by kenney
#version 0.2

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export verysync_`
conf_Path="$KSROOT/verysync/config"
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

start_verysync(){
    export GOGC=30
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
    dbus set verysync_webui=$weburl
    echo_date verysync启动成功，pid：$VSPID


}
stop_verysync(){
    killall verysync
    sleep 1
    dbus set verysync_webui="-"
}

case $ACTION in
start)
    if [ "$verysync_home" = "" ]; then
        logger "[软件中心]: 微力同步 您还未设置应用数据目录"
        exit 1
    fi
    mkdir -p "$verysync_home"
    if [[ $? -ne 0 ]]; then
        logger "[软件中心]: 微力同步 您设置的应用数据目录${verysync_home}/.verysync 无法创建，请检查路径的有效性"
        exit 1
    fi

	if [ "$verysync_enable" = "1" ]; then
        logger "[软件中心]: 启动微力同步"
        create_conf
        get_ipaddr
        start_verysync
    else
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
    logger  '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
