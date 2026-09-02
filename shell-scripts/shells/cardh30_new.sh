#!/bin/sh
#
# Program Name	: cardh30_new.sh
# Description   : Non-matched cardholder report
#                 Command line arguments:
# Author	: Dave Tucci
# Date		: 07/24/97
# Modifications : 
#                 09/23/97 - CMH - Add code for 29sc version of program.
#		: 11/16/00 - LSJ - changed /usr/pdm file path to /usr/lnk
#		: 07/23/03 - a new 39 layout added
#		: 12/08/2005 - Added umask  (LSJ)
#		: 12/14/2015 - TT14032-1 enhancements to eliminate the flexgen/cardh30v2.<clientID> processes.
#		: 02/10/2017 - TT14032-1 additional changes.
#		: 03/02/2017 - update FDATE assignment to handle aue<mmdd>-full type files.
#		: 7/31/2018 - add size check of report before emailing.
#		: 09/28/2018 - Remove benefits@pdmi.com address
#		: 11/08/2019 - Change "a2ps" to "enscript"
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE=""
#LAYOUT=""
LAYOUT="29     "
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
#PRINT_DIR="/media/test/TC05/change_output"
PRINT_DIR="/usr/lnk/elig_out"
PRINT_FILE="CARDH30RPT"
DTETM=`date +%Y%m%d-%H%M%S`
#CONFIG_FILE="/media/test/TC05/change_output/elig.cfg"
CONFIG_FILE="/usr/lnk/elig_in/elig.cfg"
#FILEDIR="/media/test/TC05/change_output"
FILEDIR="/usr/lnk/elig_in"
HOST_SYS=`hostname -s`
RETVAL=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh30_new.sh -f clientIDmmdd

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

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

    echo "-=> Finished."

}

#
# Parse config. record
parse_record()
{
        SYS=`echo $line | awk -F: '{ print $3 }'`
        ELIG_TYPE=`echo $line | awk -F: '{ print $4 }'`
        GRP_FLG=`echo $line | awk -F: '{ print $5 }'`
        RPT_NAME=`echo $line | awk -F: '{ print $6 }'`
        PROGRAM=`echo $line | awk -F: '{ print $7 }'`
        PROC_FLG=`echo $line | awk -F: '{ print $8 }'`
}

#
# Search elig.cfg file 
parse_config()
{ 
IFS="$CR"
FOUND=0
for line in `cat $CONFIG_FILE | grep -v "^#"`
do
        IFS="$OIFS"
        fid=`echo $line | awk -F: '{ print $1 }'`

        if [ $CLIENTID = $fid ]
        then
                FOUND=1
                parse_record
        fi
done
if [ $FOUND = 0 ]
then
        echo "Client ID $CLIENTID not found in database."
        exit 1
fi
}

# Submit cardh30 program
submit_cardh30()
{
        PRINT_PATH="${PRINT_DIR}/CARDH30RPT"
        runcobol ${OBJ_DIR}/cardh30 -a ${SYS}${LAYOUT}${PRINT_PATH}
	RETVAL=$?
}

# Provide report
send_report()
{
   RPTSIZE=`stat -c%s ${PRINT_DIR}/${PRINT_FILE}`
   if [ ${RPTSIZE} -gt 99 ]
   then
	/usr/bin/enscript -RBgj --non-printable-format=space -o - ${PRINT_DIR}/${PRINT_FILE} | ps2pdf - ${PRINT_DIR}/${DTETM}-${PRINT_FILE}-${FILE}.pdf
	if [ ${HOST_SYS} = "prod10" ]
	then
		echo "Attached is the Non-matched report for ${FILE}" | ${MAIL_PROG} -s "Non-Matched Report" ${MAIL_TO} -a ${PRINT_DIR}/${DTETM}-${PRINT_FILE}-${FILE}.pdf 
	else
		echo "Attached is the Non-matched report for ${FILE}" | ${MAIL_PROG} -s "*** TESTING Non-Matched Report ***" ${MAIL_TO} -a ${PRINT_DIR}/${DTETM}-${PRINT_FILE}-${FILE}.pdf
	fi
	mv ${PRINT_DIR}/${DTETM}-${PRINT_FILE}-${FILE}.pdf /usr/lnk/wt/oper-wt/accumeliglogs/${HOST_SYS}-${DTETM}-${PRINT_FILE}-${FILE}.pdf
   fi
   rm -f ${PRINT_DIR}/${PRINT_FILE}
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
	FILE=$1
	CLIENTID=`echo ${FILE} | cut -c1-2`
	FDATE=`echo ${FILE} | cut -c4-`
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables



umask 000

parse_config

case $ELIG_TYPE in
  "1")
	CARDH29TAP=${FILEDIR}/${CLIENTID}e${FDATE}.lin
	;;
  "2" | "3" | "8")
	CARDH29TAP=${FILEDIR}/${CLIENTID}e${FDATE}
	;;
    *) 
	echo "Incorrect ELIG_TYPE for this process"
	exit 1
	;;
esac
export CARDH29TAP
  
submit_cardh30 
if [ $RETVAL = 0 ]
then
	send_report
else
	RETVAL=99
fi

date

exit $RETVAL
