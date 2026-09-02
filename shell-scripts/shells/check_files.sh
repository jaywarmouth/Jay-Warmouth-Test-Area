#!/bin/ksh
# Program Name	: check_files.sh
# Description	:
# Author	:
# Date		:
# Modifications : 10/24/2005 - Changes for Linux  (LSJ)
#		: 11/30/2005 - Removed PAGE_HOST references  (LSJ)
#		: 02/23/2006 - Changes for addition of compu12.sh and new script name  (LSJ)
#		: 03/02/2006 - changed email from computers@pdmi.com to operator@pdmi.com  (LSJ)
#		: 04/28/2008 - Added an exit of procedure if a recover process already running
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
HOST=`/usr/lnk/shell/get_hostname.sh`
SUBJECT="$HOST check_files"
PAGE_PROG="/usr/local/bin/pageuser.sh"
PAGE_MSG="Problem with automatic check_files recover"
PAGEUSER="linda"
#PAGEUSER_2="kathy"
MAILUSER="operations@pdmi.com"
MAIL_PROG="/bin/mail"
ERR_MSG_FILE="/tmp/err_msgs"
DROP_DIR="/usr/lnk/wrk"
CHECK_RPT="/tmp/check_files_rpt"
CHECK_ERR="/tmp/check_files_errors"
FOUND=0
OUT_LOG="/tmp/check_files_log"
RECOVER_PROG="/usr/rmcobol/recover1"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: check_files.sh 

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
# Determine File Path
get_file_path()
{
	OLDIFS=${IFS}
	IFS=${CR}
	for FN in `cat ${ENV_FILE}`
	do
		NAME=`echo $FN | awk -F= '{ print $1 }'`
                NAME_PATH=`echo $FN | awk -F= '{ print $2 }'`
		if [ $NAME = $FILE ]
		then
			FOUND=1
			FILE_PATH=$NAME_PATH
		fi
		IFS=${CR}
	done
	if [ $FOUND = 0 ]
	then
		send_page
	fi
	IFS=${OLDIFS}
}

			
#
# Send page
send_page()
{
	$PAGE_PROG "$SUBJECT" "$PAGE_MSG" $PAGEUSER
	#$PAGE_PROG "$SUBJECT" "$PAGE_MSG" $PAGEUSER_2
	echo $PAGE_MSG | ${MAIL_PROG} -s $SUBJECT $MAILUSER 
	exit 1
}

#
check_error_list()
{
	DUP_FILE=0
	for fname in `cat ${ERR_MSG_FILE}`
	do
		if [ $fname = $FILE ]
		then
			DUP_FILE=1
		fi	
	done
}

#
# Recover procedure
run_recover()
{
	echo "$FILE" >> ${ERR_MSG_FILE}
        get_file_path
        ${RECOVER_PROG} ${FILE_PATH} ${DROP_DIR}/drop-$FILE -L ${DROP_DIR}/log-$FILE -Q -Y
        if test $? -ne 0
        then
		send_page
        fi
	date >> ${OUT_LOG}
        echo "File errors with:" >> ${OUT_LOG}
        cat $ERR_MSG_FILE >> ${OUT_LOG}
        cat ${DROP_DIR}/log-$FILE >> ${OUT_LOG}
	rm -f ${DROP_DIR}/log-$FILE
        echo "" >> ${OUT_LOG}
}

#
# Clean up
cleanup()
{
	rm -f ${ERR_MSG_FILE}
	rm -f ${CHECK_RPT}
	rm -f ${CHECK_ERR}
	rm -f ${OUT_LOG}
}

#
# Main routine
#

ps -e | grep recover
if [ $? -eq 0 ]
then
        exit 1
fi

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env
parse_env

${SHELL_DIR}/compu11.sh > ${CHECK_RPT} 2>&1
${SHELL_DIR}/compu12.sh >> ${CHECK_RPT} 2>&1
grep "ERROR ON" ${CHECK_RPT} > ${CHECK_ERR}
if test -s ${CHECK_ERR}
then
   OLDIFS=$IFS
   IFS=${CR}
   for line in `cat ${CHECK_ERR}`
   do
      	FILE=`echo $line | awk '{ print $3 }'`
	if test -s ${ERR_MSG_FILE}
	then
        	check_error_list
		if [ $DUP_FILE = 0 ]
		then
			run_recover
		fi
	else
		run_recover
	fi
   done
   IFS=${OLDIFS}
   
   ${MAIL_PROG} -s "$SUBJECT" $MAILUSER < ${OUT_LOG}

fi

cleanup

exit 0
