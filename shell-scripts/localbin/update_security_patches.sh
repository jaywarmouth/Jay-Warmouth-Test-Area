#!/bin/sh


usage()
{
	echo "$0 no-reboot|REBOOT"
	echo "no-reboot - server will no be rebooted after patches are applied"
	echo "REBOOT - server will be rebooted if necessary after patches applied"
	exit 1
}

reboot_as_needed="X"

if [ "$1" == "REBOOT" ]
then
	reboot_as_needed="1"
	echo "System will be rebooted if needed"
fi

if [ "$1" == "no-reboot" ]
then
	reboot_as_needed="0"
	echo "System will not be rebooted"
fi


if [ "$reboot_as_needed" == "X" ]
then
	usage
	exit 1
fi


/usr/bin/yum -y update --security

/usr/bin/needs-restarting -r
restart="$?"

if [ "$reboot_as_needed" -eq "1" -a "$restart" -eq "1" ]
then
	shutdown -r 
fi
