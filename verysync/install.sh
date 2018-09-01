#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

if [ -L "/koolshare/init.d/S97verysync.sh" ]; then
    #老版本的启动链接
    #新版本使用脚本逻辑/etc/init.d/S97verysync.sh
    rm -rf "/koolshare/init.d/S97verysync.sh"
fi

cp -r /tmp/verysync/* $KSROOT/
chmod a+x $KSROOT/verysync/verysync
chmod a+x $KSROOT/scripts/verysync_*
chmod a+x $KSROOT/init.d/S97verysync.sh

# add icon into softerware center
dbus set softcenter_module_verysync_install=1
dbus set softcenter_module_verysync_version=0.1
dbus set softcenter_module_verysync_name=verysync
dbus set softcenter_module_verysync_title="微力同步"
dbus set softcenter_module_verysync_description="自己的私有云"
rm -rf $KSROOT/install.sh

# if [ ! -L "/koolshare/init.d/S97verysync.sh" ]; then
#     ln -sf "/koolshare/scripts/verysync_config.sh" "/koolshare/init.d/S97verysync.sh"
# fi

dbus set verysync_version=`/koolshare/verysync/verysync -version|awk '{print $2}'`

# sh $KSROOT/scripts/verysync_config.sh start
