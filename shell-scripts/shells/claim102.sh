#!/bin/sh
#
# Program Name	: claim102.sh
# Description	: Writes and/or Deletes Claims.
#                 Command Line Arguments:
#                   -w Write flag
#                   -d Delete flag
#                   -u Update locator flag
#                   -b <16 Char.> Batch range to process
#                   -i <filename> Input filename
#                   -o <filename> Output filename (needs 30-characters)
#                   -n New file flag <CLLOC file name>  (needs 16-char.)
# Author	: Linda Jefferis
# Date		: 02/25/97
# Modifications : 04/16/97 Added logic for locator update flag  (LSJ)
#                 08/21/97 Logic for a CLLOC00WRK file  (LSJ)
#                 11/04/97 Logic added for -n and -f options (CH)
#                 11/26/97 Merged -f option into -n and added logic for using another cfg file on runcobol when -n option is on.  (LSJ)
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 01/19/2006 - Removed logic for special cfg file on runcobol  (LSJ)
#		: 03/24/2006 - Added new logic for cfg file  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
BATCH="null"
WRITE_FLAG=0
DELETE_FLAG=0
LOC_FLAG=0
ADD_NEW_FILE=0
INPUT_FILE="null"
OUTPUT_FILE="null"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
MAIL_RPT="/usr/lnk/misc/claimsdel_log"
MAIL_TO="kkarthikarajan@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
CONFIG=/usr/rmcobol/terminfo-d0.cfg

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim102.sh [-w] [-d] [-u] [-b <batch range>] [-i <input file>] [-o <output file 30-char.>] [-n <file number 16-char.>] 

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
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -w) WRITE_FLAG=1
        ;;
    -d) DELETE_FLAG=1
        ;;
    -u) LOC_FLAG=1
        ;;
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        else
          BATCH=$1
        fi
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        else
          INPUT_FILE=$1
        fi
        ;;
    -n) shift
        if [ $# -le 0 ]
        then
          usage
        else
          FILE_NUMBER=$1
          ADD_NEW_FILE=1
        fi
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        else
          OUTPUT_FILE=$1
        fi
        ;;
  esac
  shift
done
        

# Parse environment variables
parse_env

# Assign alternate environment variables

CHGFILEFLAG=N; export CHGFILEFLAG

if [ ${INPUT_FILE} != "null" ]
then
   CLAIM00MAS=${INPUT_FILE}
   export CLAIM00MAS
fi
CLWRK00MAS=${OUTPUT_FILE}
export CLWRK00MAS

echo "claim102 - Write/Delete a batch range(from CLAIM00MAS to CLWRK00MAS)"
date
echo "HOSTNAME=${HOSTNAME}"
echo "USER=$USER"
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLWRK00MAS=$CLWRK00MAS"

if [ ${BATCH} = "null" ]
then
   usage
elif [ ${OUTPUT_FILE} = "null" ]
   then
      usage
   else
      runcobol ${OBJ_DIR}/claim102 -C ${CONFIG} -s ${WRITE_FLAG}${DELETE_FLAG}${LOC_FLAG}${ADD_NEW_FILE} -a ${BATCH}${FILE_NUMBER}${OUTPUT_FILE}
fi

date

if [ ${LOC_FLAG} = 1 ]
then
   BEG_BATCH=`echo ${BATCH} | cut -c1-8`
   END_BATCH=`echo ${BATCH} | cut -c9-16`
   echo "" > ${MAIL_RPT}
   echo "ON "${HOSTNAME} >> ${MAIL_RPT}
   echo "" >> ${MAIL_RPT}
   echo "The following batch range has been moved to "${OUTPUT_FILE} >> ${MAIL_RPT}
   echo "     "${BEG_BATCH}" - "${END_BATCH} >> ${MAIL_RPT}
   echo "" >> ${MAIL_RPT}
   echo "The CLAIM00MAS file now starts with:  "${END_BATCH} >> ${MAIL_RPT}
   cat ${MAIL_RPT} | ${MAIL_PROG} -s "claim102 - Claims Deletion Procedure" ${MAIL_TO}
fi

exit 0
