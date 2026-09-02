#!/bin/sh

site="0"

ip=`/sbin/ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | awk -F. '{ print $1 "." $2 "." $3 }'`

case $ip in 
 "172.16.102"|"172.16.101")
 	site="2"
	;;
"172.16.110"|"172.16.109"|"172.16.108"|"172.16.111")
	site="1"
	;;

*)
# Unknown!
	site="0"
	;;
esac	

echo $site

if [ "$site" = "0" ]
then
	exit 1
fi

exit 0
