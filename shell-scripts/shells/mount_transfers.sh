#!/bin/sh

server="unknown"

ip=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | awk -F. '{ print $1 "." $2 "." $3 }'`

case $ip in 
 "172.16.102"|"172.16.101")
 	server="file20"
	;;
"172.16.110"|"172.16.109"|"172.16.108"|"172.16.111")
	server="file10"
	;;

*)
	echo "unknown"
	;;
esac	
	
	


/usr/bin/smbmount  //${server}/ClientFiles /media/transfers -o username="pdmboardman\ClientFiles",password="cf2009access",uid=11,gid=130,fmask=664,dmask=775
