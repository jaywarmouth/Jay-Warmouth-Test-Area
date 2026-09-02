#!/bin/sh


#       Name: sl  
#       By  : Steven Randlett
#       Date: 11/14/02
#       Purpose: shows lines.
#
#
#


usage()
{
echo "USAGE: $0 sw16|sw40|all"

}

#
# MAIN
#

LINETYPE="$1"
ACTION="$2"
TMPFILE1="/tmp/sl.tmp1.$$"
TMPFILE2="/tmp/sl.tmp2.$$"
SW40_LINEINFO="/usr/local/logs/linedrv/switch40/switch40.lineinfo"
SW16_LINEINFO="/usr/local/logs/linedrv/switch16/switch16.lineinfo"
OIFS="$IFS"
CR="
"

if [ "$LINETYPE" = "" ]
then
	LINETYPE="all"
fi

LHOST=`/bin/hostname -s`


trap 'rm -f $TMPFILE1 $TMPFILE2' 0





if [ "$DMODE" = "1" ]
then
	OPTS="-17"
else
	OPTS="-16"
fi

if [ "$LINETYPE" = "" ]
then
	usage
	exit 1

elif [ "$LINETYPE" = "sw16" ]
then
if [ "$LHOST" = "prod10" ]
then
	GREP_SYS="172.16.110.16:10200|0.0.0.0:10200"
else
	GREP_SYS="172.16.110.17:10200|0.0.0.0:10200"
fi

LINEINFO_FILE=$SW16_LINEINFO

elif [ "$LINETYPE" = "sw40" ]
then
if [ "$LHOST" = "prod10" ]
then
	GREP_SYS="172.16.110.16:10300|0.0.0.0:10300"
else
	GREP_SYS="172.16.110.17:10300|0.0.0.0:10300"
fi

LINEINFO_FILE=$SW40_LINEINFO

elif [ "$LINETYPE" = "all" ]
then
	/usr/local/bin/sl.sh sw16
	/usr/local/bin/sl.sh sw40
	exit 0
else
	usage
	exit 1
fi
#set -x
	/bin/netstat -nap | egrep "${GREP_SYS}" >$TMPFILE1
#set +x

	IFS="$CR"
	for line in `cat $TMPFILE1`
	do
		IFS="$OIFS"
		con=`echo $line | awk '{ print $6 }'`
		tpid=`echo $line | awk '{ print $7 }'`
		tbox_and_port=`echo $line | awk '{ print $5 }'`
		tbox=`echo $tbox_and_port | awk -F: '{ print $1 }'`
		cpid=`echo $tpid | awk -F/ '{ print $1 }'`
		if [ "$cpid" = "" ]
		then
			cpid="0"
		fi
		if [ "$con" = "" ]
		then
			con="Unknown"
		fi

		case $tbox 
		in
			172.16.110.26)
				tbox="110.26"
			;;
			172.16.101.26)
				tbox="101.26"
			;;
			172.16.101.30)
				tbox="101.30"
			;;
			172.16.100.163)
				tbox="100.163"
			;;
		esac
		

		echo "$cpid $con $tbox" >>$TMPFILE2
		IFS="$CR"
	done
	rm -f $TMPFILE1	
	IFS="$CR"
	for line in `cat $LINEINFO_FILE`
	do
		IFS="$OIFS"
		echo -e -n "$line\t">>$TMPFILE1
		pid=`echo $line | awk '{ print $2 }'`
		IFS="$CR"
		con="UNKNOWN"
		box="UNKNOWN"
		if [ "$pid" = "-1" ]
		then
			con="DISCONNECTED"
			pid="UNUSED_PID_TO_MAKE_GREP_HAPPY"
		fi
#set -x
		for tline in `cat $TMPFILE2|grep $pid`
		do
#set +x
			IFS="$OIFS"
			tpid=`echo $tline | awk '{ print $1 }'`
			tcon=`echo $tline | awk '{ print $2 }'`
			tbox=`echo $tline | awk '{ print $3 }'`
			if [ "$tpid" = "$pid" ]
			then
				con="$tcon"
				box="$tbox"
				break
			fi 

			IFS="$CR"
		done
		IFS="$OIFS"
		echo -e "$con\t${box}">>$TMPFILE1

		IFS="$CR"
	done
	echo -e "Line\t\tPID\tQueue\tTimeStamp\t\tStatus\t\tSource"
	cat $TMPFILE1
