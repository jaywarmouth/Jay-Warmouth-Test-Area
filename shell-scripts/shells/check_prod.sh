#!/bin/sh

########################################
#
# Checks to ensure we are logged in as root.
#
#
check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
		ROOTUSER=0
	else
		ROOTUSER=1
        fi
}




check_for_root

OIFS="$IFS"


echo " "
for TLINE in 91 92 93 94 95 96 97 
do
	tmp=`ps -ef | grep "runcobol /usr/lnk/obj/traffic01 -C /usr/rmcobol/terminfo.compu04 -k -s 0[0-1][0-1]0[0-1] -a $TLINE" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -n -e "Traffic $TLINE: DOWN   \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -n -e "Traffic $TLINE: up     \t"
	else
		echo -n -e "Traffic $TLINE: WARN ($tmp)\t"
	fi


	tmp=`ps -ef | grep "/usr/lnk/shell/traffic01.scr -q $TLINE" | grep -v grep | wc -l`
	if [ "$tmp" -eq "0" ]
	then
		echo -e  "Traffic SCR $TLINE: DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "Traffic SCR $TLINE: up    \t"
	else
		echo -e  "Traffic SCR $TLINE: WARN ($tmp)\t"
	fi


done



	echo " "
	tmp=`ps -ef | grep "/usr/local/bin/tcpclaim -f /usr/local/pub/webclaim.cfg" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "Webclaims             : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "Webclaims             : up    \t"
	else
		echo -e  "Webclaims             : WARN ($tmp)\t"
	fi

	tmp=`ps -ef | grep "/usr/pdm/linedrv/linedriver_logger /tmp/lines/linedriver_logger/linedriver_logger" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "Linedriver Logger     : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "Linedriver Logger     : up    \t"
	else
		echo -e  "Linedriver Logger     : WARN ($tmp)\t"
	fi

echo " "
	tmp=`ps -ef | grep "runcobol /usr/lnk/obj/elgrt02 -s 0 -a 80" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "ELGRT COBOL           : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "ELGRT COBOL           : up    \t"
	else
		echo -e  "ELGRT COBOL           : WARN ($tmp)\t"
	fi

	tmp=`ps -ef | grep "/usr/local/bin/tcpfileclaim -f /usr/local/pub/realtime_tcpfileclaim2.cfg" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "ELGRT C DAEMON        : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "ELGRT C DAEMON        : up    \t"
	else
		echo -e  "ELGRT C DAEMON        : WARN ($tmp)\t"
	fi

	echo " "
	tmp=`ps -ef | grep "/usr/tst/obj/elgrt_tst -s 1 -a 83" | grep -v grep | wc -l`


	if [ "$tmp" -eq "0" ]
	then
		echo -e  "ELGRT TEST COBOL      : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "ELGRT TEST COBOL      : up    \t"
	else
		echo -e  "ELGRT TEST COBOL      : WARN ($tmp)\t"
	fi

	tmp=`ps -ef | grep "/usr/local/bin/tcpfileclaim -f /usr/local/pub/realtime_tcpfileclaim_test.cfg" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "ELGRT TEST C DAEMON   : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "ELGRT TEST C DAEMON   : up    \t"
	else
		echo -e  "ELGRT TEST C DAEMON   : WARN ($tmp)\t"
	fi

	echo " "
	tmp=`ps -ef | grep "runcobol /usr/lnk/obj/clmrt01 -s 0000 -a 6867" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "CLMRT COBOL           : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "CLMRT COBOL           : up    \t"
	else
		echo -e  "CLMRT COBOL           : WARN ($tmp)\t"
	fi

	tmp=`ps -ef | grep "bash -c nohup /usr/local/bin/tcpsendwebsrv -f /usr/local/pub/tcpsendwebsrv.cfg" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "CLMRT C DAEMON        : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "CLMRT C DAEMON        : up    \t"
	else
		echo -e  "CLMRT C DAEMON        : WARN ($tmp)\t"
	fi

	tmp=`ps -ef | grep "/bin/sh /usr/lnk/shell/tcpsendwebsrv_auto.sh" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "CLMRT C AUTO RESTARTER: DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "CLMRT C AUTO RESTARTER: up    \t"
	else
		echo -e  "CLMRT C AUTO RESTARTER: WARN ($tmp)\t"
	fi


	echo " "

	tmp=`ps -ef | grep "/usr/local/bin/tcp2queue -f /usr/local/pub/tcp2queue_rxhub.cfg" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "RxHUB C Program       : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "RxHUB C Program       : up    \t"
	else
		echo -e  "RxHUB C Program       : WARN ($tmp)\t"
	fi


	tmp=`ps -ef | grep "runcobol /usr/lnk/obj/etraf01 -s 0 -a 800" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "RxHUB COBOL Program   : DOWN  \t"
	elif [ "$tmp" -eq "1" ]
	then
		echo -e  "RxHUB COBOL Program   : up    \t"
	else
		echo -e  "RxHUB COBOL Program   : WARN ($tmp)\t"
	fi

	echo " "




	tmp=`ps -ef | grep "/usr/local/bin/helpdesk" | grep -v grep | wc -l`

	if [ "$tmp" -eq "0" ]
	then
		echo -e  "HELPDESK C DAEMON     : DOWN  \t"
	else
		echo -e  "HELPDESK C DAEMON     : up    \t"
	fi


#set -x
# These vars are only used for text output.  The program
# uses the PGFILE state to determine if a page should go out.
TOTAL_C_SW40=12
TOTAL_C_SW16=24
SW40_DAEMON="DOWN"
SW16_DAEMON="DOWN"

if [ "$ROOTUSER" = "1" ]
then

UP_SW40=`/usr/pdm/linedrv/sl.sh sw40 | grep ESTABLISHED | wc -l`

if [ "$UP_SW40" -ne "$TOTAL_C_SW40" ]
then
# Added code to try to reduce false positivies from netstat
# anomolies
	sleep 3
	UP_SW40=`/usr/pdm/linedrv/sl.sh sw40 | grep ESTABLISHED | wc -l`
fi
fi


junk=`netstat -na | grep "0.0.0.0:10093" | grep "LISTEN"` 	
if [ ! "$junk" = "" ]
then
	SW40_DAEMON="up"
fi

if [ "$ROOTUSER" = "1" ]
then
UP_SW16=`/usr/pdm/linedrv/sl.sh sw16 | grep ESTABLISHED | wc -l`

if [ "$UP_SW16" -ne "$TOTAL_C_SW16" ]
then
# Added code to try to reduce false positivies from netstat
# anomolies
	sleep 3
	UP_SW16=`/usr/pdm/linedrv/sl.sh sw16 | grep ESTABLISHED | wc -l`
fi

fi

junk=`netstat -na | grep "0.0.0.0:10095" | grep "LISTEN"` 	
if [ ! "$junk" = "" ]
then
	SW16_DAEMON="up"
fi


echo " "

if [ "$ROOTUSER" = "1" ]
then
	echo -e "Switch16 linedrivers: $UP_SW16 of $TOTAL_C_SW16 up.\t Daemon: $SW16_DAEMON"
	echo -e "Switch40 linedrivers: $UP_SW40 of $TOTAL_C_SW40 up.\t Daemon: $SW40_DAEMON"
else
	echo -e "Switch16 linedrivers: Line Status N/A (must be root)\tDaemon: $SW16_DAEMON"
	echo -e "Switch40 linedrivers: Line Status N/A (must be root)\tDaemon: $SW40_DAEMON"

fi





echo " "
