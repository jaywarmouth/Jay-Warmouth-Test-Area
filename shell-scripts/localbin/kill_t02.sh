#!/bin/sh


#       Name: kill traffic02 processes
#       By  : Steven Randlett
#       Date: 11/15/02
#       Purpose: 
#
#	Changes:  02-27-2003 - Added logic for ssc  (LSJ)
#	Changes:  06/02/2022 - Added line 10 logic (LSJ)
#		  06/06/2024 - logic for 70, 90, and extra 40 processes (LSJ)
#		  09/10/2024 - logic for 60 (LSJ)
#


usage()
{
echo "USAGE: $0 line"
echo "where line is 10, 16, 40, 60, 70, 90, dir"

}

get_pid()
{
grep_line="$1"

echo `ps -ef | grep "${grep_line}" | grep -v "grep ${grep_line}" | awk '{ print $2 }'`


}

get_parent()
{
child_pid="$1"

IFS="$CR"
for line in `ps -ef | grep "runcobol"`
do
	IFS="$OIFS"
	pid=`echo $line | awk '{ print $2 }'`
	ppid=`echo $line | awk '{ print $3 }'`

#	echo line=$line
#	echo "pid=$pid"
#	echo "ppid=$ppid"
	
	if [ "$ppid" -eq "$child_pid" ]
	then
		echo $pid 
		break
	fi
IFS="$CR"

done
IFS="$OIFS"
}

do_kill()
{
LINEID=`get_pid "${LINE1}"`
if [ "${LINEID}" != "" ]
then
        PLINEID=`get_parent "$LINEID"`
	if [ ${LINEID} = 1 ]
	then
		echo "Abort... LINEID is 1"
		exit 1
	fi
	if [ ${PLINEID} = 1 ]
	then
		echo "Abort... PLINEID is 1"
		exit 1
	fi
        echo Killing... ${LINEID} ${PLINEID}
        kill -9 ${LINEID} ${PLINEID}

fi
}

#
# MAIN
#

OIFS="$IFS"
CR="
"

LINETYPE="$1"
echo "LINETYPE=$LINETYPE"

case ${LINETYPE} in
   "10")
        LINE1="traffic02.scr -q 410"
	do_kill
        ;;
   "16")
	LINE1="traffic02.scr -q 200"
	do_kill
        LINE1="traffic02.scr -q 201"
	do_kill
	;;
   "40")
        LINE1="traffic02.scr -q 300"
	do_kill
        LINE1="traffic02.scr -q 301"
	do_kill
        LINE1="traffic02.scr -q 302"
	do_kill
        LINE1="traffic02.scr -q 303"
	do_kill
        LINE1="traffic02.scr -q 304"
	do_kill
        LINE1="traffic02.scr -q 305"
	do_kill
        LINE1="traffic02.scr -q 306"
	do_kill
        LINE1="traffic02.scr -q 307"
	do_kill
        LINE1="traffic02.scr -q 308"
	do_kill
        LINE1="traffic02.scr -q 309"
	do_kill
	;;
   "60")
	LINE1="traffic02.scr -q 600"
	do_kill
        LINE1="traffic02.scr -q 601"
	do_kill
	;;
   "70")
	LINE1="traffic02.scr -q 700"
	do_kill
        LINE1="traffic02.scr -q 701"
	do_kill
	;;
   "90")
	LINE1="traffic02.scr -q 900"
	do_kill
        LINE1="traffic02.scr -q 901"
	do_kill
	;;
   "dir")
	LINE1="traffic02.scr -q 400"
	do_kill
	LINE1="traffic02.scr -q 402"
	do_kill
	LINE1="traffic02.scr -q 404"
	do_kill
	LINE1="traffic02.scr -q 406"
	do_kill
	LINE1="traffic02.scr -q 408"
	do_kill
#    *)	usage
#	exit 1
#	;; 
esac	


