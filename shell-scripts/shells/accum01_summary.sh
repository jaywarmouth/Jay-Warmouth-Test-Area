#!/bin/sh
#
# Program Name	: accum01_summary.sh
# Description	: Client Summary notification for accum01 file update
#		  Command Line Arguments:
#		  -c Client Abbrev. 
#		  -f <filename> 
#		  -d <alternate date - mm-dd-yyyy

#
# Variables Used:
DATE=`date +%m-%d-%Y`
LOG=/tmp/accumsummary.log
MAIL_PROG="/usr/bin/mutt"
MAIL_CC="operations@pdmi.com"
CONFIG_FILE=/usr/lnk/elig_in/accum01.cfg
CR="
"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum01_summary.sh [-c <client abbrev>] [-f <filename>] 

ENDOFUSAGE
  exit 1
}



# Set Variables
set_variables()
{
   if [ ${CLIENT} = "null" ]
   then
     usage
   fi
}

# Separate stats
find_stats()
{
   ADDED=`grep "TOTAL ADDED" ${FILE} | cut -c 1-24`
   CHANGED=`grep "TOTAL ADDED" ${FILE} | cut -c 26-49`
   READ=`grep "TOTAL ADDED" ${FILE} | cut -c 53-75`
}


# Check Config
check_config()
{
   IFS="$CR"
   FOUND=0
   for line in `cat $CONFIG_FILE | grep -v "^#"`
   do
        IFS="$OIFS"
        fid=`echo $line | awk -F: '{ print $1 }'`

        if [ "$CLIENT" = "$fid" ]
        then
                FOUND="1"
                parse_record
        fi
   done
   if [ "$FOUND" -ne 1 ]
   then
        echo "Client ID $CLIENT not found in database."
        exit 1
   fi
}

#
# Parse configuration record
parse_record()
{
        CLIENT_NAME=`echo $line | awk -F: '{ print $2 }'`
        SYS=`echo $line | awk -F: '{ print $3 }'`
        IN_FLG=`echo $line | awk -F: '{ print $4 }'`
        RPT_REF=`echo $line | awk -F: '{ print $6 }'`
        EMAILTO=`echo $line | awk -F: '{ print $9 }'`
}
	
#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	CLIENT=$1
	;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	FILE=$1
	;;
    -d) shift
	        if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
 esac
  shift
done


umask 002

set_variables


if test -s ${FILE}
then
   echo "PDMI, INC." > ${LOG}
   echo "Reference Information: ${FILE}" >> ${LOG}
   echo "" >> ${LOG}            
   echo "Date File Updated: "${DATE} >> ${LOG}
   echo "" >> ${LOG}

   check_config

   find_stats

   echo ${ADDED} >> ${LOG}
   echo ${CHANGED} >> ${LOG}
   echo ${READ} >> ${LOG}
   echo "" >> ${LOG}
   cat ${LOG} | ${MAIL_PROG} -s "${CLIENT_NAME} - Accumulator File Update Notification" -c ${MAIL_CC} ${EMAILTO}
else
   echo "${FILE} does not exist" 
   usage
fi

exit 0
