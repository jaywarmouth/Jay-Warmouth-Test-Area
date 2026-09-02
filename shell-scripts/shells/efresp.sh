#!/bin/ksh
#
# Program Name	: efresp.sh 
# Description   : View operational data from Eagle Force log file
#			
# Author	: Steve Randlett (mangled script provided by Linda)
# Date		: 09/14/2016
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_FLAG=1
OUTPUT_FILE="/tmp/.efresp.txt.$$"
TMPFILE="/tmp/.efresp.tmp.$$"
RUNTYPE="today"
RETVAL=0
total_runtime_ms="0"
record_count="0"
min_runtime_ms="9999"
max_runtime_ms="0"
RECORD_LOOK_BACK="50"
ef_errors="0"
ef_timeouts="0"
result_yy="0"
result_yn="0"
result_nn="0"
result_ny="0"
QUIET="0"
RUNDATE="`date +%F`"
KEEP_OUTPUT_FILE="0"
SHOW_DETAIL="1"
SHOW_AS_VARIABLES="0"

CR="
"
OIFS="$IFS"

source /etc/profile

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: efresp.sh [-l records] [-q] [-d rundate] [-r filename] [-v] [-h]
-l - review previous x records, records = 0 display all records
-q - quiet - no header or summary info
-d - rundate in YYYYMMDD.  Defaults to today
-r - raw data dump
-s - summary info only
-v - display data as variables
-h - help

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}


}

# Submit efssrb01 program
submit_efssrb01()
{
     runcobol ${OBJ_DIR}/efssrb001 -a ${RUNTYPE} >/dev/null 2>&1
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -l) shift
        if [ $# -le 0 ]
       then
          usage
        fi
	RECORD_LOOK_BACK="$1"
	;;
    -d) shift
        if [ $# -le 0 ]
       then
          usage
        fi
	RUNDATE="$1"
	;;
    -r) shift
        if [ $# -le 0 ]
       then
          usage
        fi
	OUTPUT_FILE="$1"
	KEEP_OUTPUT_FILE="1"
	;;
     -q) 
	QUIET="1"
	;;
     -s) 
	SHOW_DETAIL="0"
	;;
     -h) 
	usage
	;;
     -v) 
	SHOW_AS_VARIABLES="1"
	SHOW_DETAIL="0"
	QUIET="1"
	;;
	*)
	echo " "
	echo "Invalid option '$1'"
	usage
	;;
  esac
  shift
done

# Parse environment variables
parse_env

if [ $RUNTYPE = 0 ]
then
        usage
        exit 1
fi

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   	EFSSRB001=${OUTPUT_FILE}
   	export EFSSRB001
fi

today_datecard_date=`date +%F --date "$RUNDATE"`




#DATECARD=/usr/lnk/log/today-DATECARD.txt
DATECARD=/tmp/.efresp.datecard.$$
export DATECARD

echo "  FULL" >$DATECARD
echo "  yesterday      -VC-001-001" >>$DATECARD
echo "  last7days      -VC-007-001" >>$DATECARD
echo "  today          -HD---------${today_datecard_date}-0000-00-00" >>$DATECARD 

rm -f "$OUTPUT_FILE"

submit_efssrb01

IFS="$CR"


touch $OUTPUT_FILE
touch $TMPFILE

if [ "$RECORD_LOOK_BACK" -eq "0" ]
then
	RECORD_LOOK_BACK="9999999999"
fi

if [ "$QUIET" -eq "0" ]
then
	echo "Result|Whitelist|HTTP|TimeStamp|Time(ms)|Claim|MemberID" >>$TMPFILE
fi
for rec in `cat $OUTPUT_FILE | /usr/local/bin/fix2delim -sb 124 -1 /usr/local/pub/efresp.f2d | awk -F\| '{ print $18 "|" $19 "|" $22 "|" $25 "|" $26 "|" $20 "|" $6 "|" $1 "|" $8 }'| tail -${RECORD_LOOK_BACK}`
do
	IFS="$OIFS"

	result=`echo "$rec" | cut -d\| -f 1`
	except=`echo "$rec" | cut -d\| -f 2`
	status=`echo "$rec" | cut -d\| -f 3`
	starttime=`echo "$rec" | cut -d\| -f 4`
	endtime=`echo "$rec" | cut -d\| -f 5`
	info=`echo "$rec" | cut -d\| -f 6`
	med=`echo "$rec" | cut -d\| -f 7`
	bnc=`echo "$rec" | cut -d\| -f 8`
	member_id=`echo "$rec" | cut -d\| -f 9`

	if [ "$result" = "YES" -a "$except" = "NO" ]
	then
		result_yn="`expr $result_yn + 1`"
	fi

	if [ "$result" = "YES" -a "$except" = "YES" ]
	then
		result_yy="`expr $result_yy + 1`"
	fi

	if [ "$result" = "NO" -a "$except" = "YES" ]
	then
		result_ny="`expr $result_ny + 1`"
	fi

	if [ "$result" = "NO" -a "$except" = "NO" ]
	then
		result_nn="`expr $result_nn + 1`"
	fi


	if [ "$status" = "" ]
	then
		status="TMOUT"
	fi

	if [ "$status" = "200" ]
	then
		status="OK ($status)"
	fi
	if [ "$status" = "400" ]
	then
		status="PDMI BAD DATA ($status)"
	fi
	if [ "$status" = "500" ]
	then
		status="EF SRVR ERR ($status)"
	fi

	info_status="`echo $info | cut -c 1-13`"

	if [ "$info_status" = "DEFAULT USED:" ]
	then
		if [ "$info" = "DEFAULT USED:" ]
		then
			ef_timeouts="`expr $ef_timeouts + 1`"
		else
			ef_errors="`expr $ef_errors + 1`"
		fi
	fi

	starttime_ts=`echo $starttime | cut -c 15-16`
	endtime_ts=`echo $endtime | cut -c 15-16`

	starttime_date=`echo $starttime | cut -c 1-8`
	endtime_date=`echo $endtime | cut -c 1-8`

	starttime_time="`echo $starttime | cut -c 9-10`:`echo $starttime | cut -c 11-12`:`echo $starttime | cut -c 13-14`"
	endtime_time="`echo $endtime | cut -c 9-10`:`echo $endtime | cut -c 11-12`:`echo $endtime | cut -c 13-14`"

	pretty_starttime=`date +"%F %T" --date "${starttime_date} ${starttime_time}"`.${starttime_ts}0
	starttime_seconds=`date +%s --date "${starttime_date} ${starttime_time}"`.${starttime_ts}
	endtime_seconds=`date +%s --date "${endtime_date} ${endtime_time}"`.${endtime_ts}

	runtime_ms=`echo "scale=0; (($endtime_seconds - $starttime_seconds) * 1000)/1" | bc`

	total_runtime_ms="`expr $runtime_ms + $total_runtime_ms`"
	record_count="`expr $record_count + 1`"

	if [ "$min_runtime_ms" -gt "$runtime_ms" ]
	then
		min_runtime_ms="$runtime_ms"
	fi
	if [ "$max_runtime_ms" -lt "$runtime_ms" ]
	then
		max_runtime_ms="$runtime_ms"
	fi

#	echo -e "$result\t$except\t$status\t$pretty_starttime\t$runtime_ms\t$bnc\t$member_id"
		echo -e "$result|$except|$status|$pretty_starttime|$runtime_ms|$bnc|$member_id" >>$TMPFILE

	IFS="$CR"
done

	result_ynp=`echo "scale=1;($result_yn * 100) / $record_count" | bc`
	result_yyp=`echo "scale=1;($result_yy * 100) / $record_count" | bc`
	result_nyp=`echo "scale=1;($result_ny * 100) / $record_count" | bc`
	result_nnp=`echo "scale=1;($result_nn * 100) / $record_count" | bc`

	ef_errors_p=`echo "scale=1;($ef_errors * 100) / $record_count" | bc`
	ef_timeouts_p=`echo "scale=1;($ef_timeouts * 100) / $record_count" | bc`

	avg_runtime_ms="`expr $total_runtime_ms / $record_count`"

	if [ "$SHOW_DETAIL" -eq "1" ]
	then
		cat $TMPFILE | column -t -s\|
	fi

if [ "$QUIET" -eq "0" ]
then
	echo  " "
	echo "Total Records       : ${record_count} "
	echo "Runtimes min/max/avg: ${min_runtime_ms}ms/${max_runtime_ms}ms/${avg_runtime_ms}ms"
	echo "EF Timeouts         : $ef_timeouts (${ef_timeouts_p}%)"
	echo "EF Errors           : $ef_errors (${ef_errors_p}%)"
	echo "Yes/No Result       : $result_yn (${result_ynp}%)"
	echo "Yes/Yes Result      : $result_yy (${result_yyp}%)"
	echo "No/Yes Result       : $result_ny (${result_nyp}%)"
	echo "No/No Result        : $result_nn (${result_nnp}%)" 

fi

if [ "$SHOW_AS_VARIABLES" -eq "1" ]
then
	echo "TOTAL_RECORDS=${record_count}"
	echo "RUNTIME_MIN=${min_runtime_ms}"
	echo "RUNTIME_MAX=${max_runtime_ms}"
	echo "RUNTIME_AVG=${avg_runtime_ms}"
	echo "EF_TIMEOUTS=$ef_timeouts"
	echo "EF_ERRORS=$ef_errors"
	echo "RESULT_YES_NO=$result_yn"
	echo "RESULT_YES_YES=$result_yy"
	echo "RESULT_NO_YES=$result_ny"
	echo "RESULT_NO_NO=$result_nn"
fi


if [ "$KEEP_OUTPUT_FILE" -eq "0" ]
then
	rm -f "$OUTPUT_FILE"
fi
rm -f "$DATECARD"
rm -f "$TMPFILE"

exit $RETVAL
