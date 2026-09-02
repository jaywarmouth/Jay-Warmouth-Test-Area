#!/bin/ksh
#
# Program Name	: test_traffic01.sh
# Description	: Procedure run and submit test traffic01
#		  Command Line Arguments:
#		  -f <filename> - filename for resubmit procedure
# Author	: Linda S. Jefferis
# Date		: 10/21/2002
# Modifications : 11/30/2010 - changed /tmp/test_traffic01.rpt to ${HOME}/test_traffic01.rpt

#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SHELL="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
LINE_NUM="71"
QUEUE="98"
SW_SET="01010"
LOCKFILE="/tmp/test_traffic01.lock"
RESUBMIT_PROG="/usr/local/bin/resubmit"
SHELL_PID=$$
TEST_ENV="/usr/lnk/test/env_var.c4t"
USER=`/usr/bin/logname`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: test_traffic01.sh [-f <submit filename>]

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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

    echo "-=> Finished."

}

#
# Check if the test traffic01 is currently running
check_runstatus()
{
	if test -a ${LOCKFILE}
	then
	  echo ""
	  echo "***** A TEST traffic01 IS CURRENTLY RUNNING *****"
	  sleep 5
	  exit 1
	else
	  touch ${LOCKFILE}
	fi
}

#
# Submit test traffic01
submit_traffic01()
{
	runcobol ${OBJ_DIR}/traffic01 -k -s ${SW_SET} -a ${QUEUE} > ${HOME}/test_traffic01.rpt &
	PID=$!	
	echo "SHELL PID: $$\tCOBOL PID: ${PID}\tUSER: ${USER}" >> ${LOCKFILE}
}

#
# Run Resubmit
run_resubmit()
{
	C04_STATUS=`ps -ef |grep ${PID} |grep -v "grep ${PID}"`
	STATUS=$?
	if [ ${STATUS} -eq "0" ]
	then
	  trap cleanup_2 0
	  ${RESUBMIT_PROG} ${LINE_NUM} ${QUEUE} ${FNAME}
	else
  	  echo "*** traffic01 IS NOT RUNNING\n*** THEREFORE THE TESTING PROCESS CANNOT BE COMPLETED\n*** PLEASE SEE PROGRAMMING OR SYS. ADMIN."
	  cleanup_1
	fi
}

#
cleanup_1()
{
	rm -f ${LOCKFILE}
	exit 0
}

#
cleanup_2()
{
	kill ${PID}
	if [ "$?" -ne "0" ]
	then
	  echo "UNABLE TO KILL test_traffic01. NOTIFY SYS ADM"
	  sleep 5
	  exit 1
	fi
	cleanup_1
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FNAME=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env
ENV_FILE=${TEST_ENV}
parse_env

check_runstatus

trap cleanup_1 0
submit_traffic01

run_resubmit

exit 0
