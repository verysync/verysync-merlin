#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export verysync_`

# stop first
sh $KSROOT/scripts/verysync_config.sh stop

# remove dbus data in softcenter
confs=`dbus list verysync_|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf $KSROOT/verysync
rm -rf $KSROOT/scripts/verysync*
rm -rf $KSROOT/init.d/S97verysync.sh
rm -rf /etc/rc.d/S97verysync.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_verysync.asp
rm -rf $KSROOT/res/icon-verysync.png
rm -rf $KSROOT/res/icon-verysync-bg.png

# remove dbus data in syncthing
dbus remove softcenter_module_verysync_home_url
dbus remove softcenter_module_verysync_install
dbus remove softcenter_module_verysync_md5
dbus remove softcenter_module_verysync_version
dbus remove softcenter_module_verysync_name
dbus remove softcenter_module_verysync_title
dbus remove softcenter_module_verysync_description
