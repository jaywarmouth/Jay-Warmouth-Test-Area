#!/bin/sh


#       Name: linedriver_status.sh
#       By  : Steven Randlett
#       Date: 2020-07-23
#       Purpose: Get status of linedrivers
#
#


usage()
{
echo "USAGE: $0 line"
echo "where line is sw10, sw16, sw40, sw70, sw90, or all"
}

#
# MAIN
#

LINETYPE="$1"

if [ "$LINETYPE" == "" ]
then
	LINETYPE="all"
fi


PDM_PATH=/usr/local/bin
PDM_SHELL=/usr/lnk/shell
PDM_LOG=/usr/local/logs
PDM_CONFIG=/usr/local/etc
LHOST=`/bin/hostname -s`

MT01G="`dig +short mirth-traffic01-green.pdmboardman.local`"
MT02G="`dig +short mirth-traffic02-green.pdmboardman.local`"

MT01B="`dig +short mirth-traffic01-blue.pdmboardman.local`"
MT02B="`dig +short mirth-traffic02-blue.pdmboardman.local`"




get_status()
{
linetype="$1"

case $linetype in
"sw10") 
	portnumber="10410"
	;;
"sw16") 
	portnumber="10200"
	;;
"sw40")
	portnumber="10300"
	;;
"sw70")
	portnumber="10700"
	;;
"sw90")
	portnumber="10900"
	;;
*)
	echo "Unknown linetype $linetype"
	exit 1
	;;
esac


listener_count=`netstat -nap |grep $portnumber | grep tcplinedrv | grep LISTEN | wc -l`

if [ "$listener_count" -eq "1" ] 
then
	echo "$linetype listener: UP"
else
	echo "$linetype listener: DOWN"
fi
	mt01g_count=`netstat -nap | grep $portnumber | grep tcplinedrv | grep ESTABLISHED | grep "$MT01G" |  wc -l`
echo "$linetype established connections mirth-traffic01-green: $mt01g_count"

	mt02g_count=`netstat -nap | grep $portnumber | grep tcplinedrv | grep ESTABLISHED | grep "$MT02G" |  wc -l`
echo "$linetype established connections mirth-traffic02-green: $mt02g_count"

	mt01b_count=`netstat -nap | grep $portnumber | grep tcplinedrv | grep ESTABLISHED | grep "$MT01B" |  wc -l`
echo "$linetype established connections mirth-traffic01-blue: $mt01b_count"

	mt02b_count=`netstat -nap | grep $portnumber | grep tcplinedrv | grep ESTABLISHED | grep "$MT02B" |  wc -l`
echo "$linetype established connections mirth-traffic02-blue: $mt02b_count"

	established_count=`netstat -nap | grep $portnumber | grep tcplinedrv | grep ESTABLISHED |  wc -l`
echo "$linetype established connections: $established_count"

	closing_count=`netstat -na | grep $portnumber |  egrep -v "ESTABLISHED|LISTEN" |  wc -l`


echo "$linetype closing connections: $closing_count"


}


if [ "$LINETYPE" = "" ]
then
	usage
	exit 1

elif [ "$LINETYPE" = "sw16" ]
then

get_status $LINETYPE


elif [ "$LINETYPE" = "sw40" ]
then
get_status $LINETYPE


elif [ "$LINETYPE" = "all" ]
then
get_status "sw10" | column -t -s:
echo -en "\n"
get_status "sw16" | column -t -s:
echo -en "\n"
get_status "sw40" | column -t -s:
echo -en "\n"
get_status "sw70" | column -t -s:
echo -en "\n"
get_status "sw90" | column -t -s:


else
	usage
	exit 1
fi


