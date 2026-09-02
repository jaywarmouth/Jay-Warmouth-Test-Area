#!/bin/sh





if [ "$1" = "-a" ]
then
	rm /etc/stoplogin

elif [ "$1" = "-d" ]
then
	/usr/bin/touch /etc/stoplogin
else

echo "Usage: login_access.sh -a|-d"
echo "-a allow remote users access"
echo "-d deny  remote users access"
echo ""

fi
