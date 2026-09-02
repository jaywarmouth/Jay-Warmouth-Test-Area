#!/bin/sh

usage() {
echo "USAGE: faxcontrol.sh start|stop|restart"
}

if [ "$1" = "" ]
then
	usage
	exit 1
fi


case $1 in

"start"|"restart")
	/etc/rc3.d/S95hylafax $1
	/usr/sbin/faxgetty ttyS0 &
	;;
	
stop)
	/etc/rc3.d/S95hylafax stop
	;;
*)	usage
	;;

esac



