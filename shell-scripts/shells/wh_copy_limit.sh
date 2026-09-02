#!/bin/ksh
#
# Program Name	: wh_copy_limit.sh
# Description	: Copy of LIMIT00MAS file for Warehouse 
# Author	: Linda S. Jefferis
# Date		: 03/29/2006
# Modifications : 11/30/2006 - Addition of ohlimpc007 procedure  (LSJ)
#		: 08/29/2008 - Added ohlimpc008 procedure  (LSJ)
#		: 12/29/2009 - Added scp  (LSJ)
#		: 04/16/2010 - Changes for FILE10/FILE20 output location and date suffix on extract file name.
#		: 09/23/2010 - Temporarily added scp to prod21
#		: 01/12/2011 - Removed scp to prod21
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG=/bin/mail
MAIL_TO="warehouse@pdmi.com ljefferis@pdmi.com"
PAGE_PROG="/usr/local/bin/pageuser.sh"
PAGEUSER="linda"
SUBJECT="Monthly Limit Copy"
ERR_MSG="COPY FAILED"
FLEX="/usr/lnk/flexgen"
EXTRACT_FILE="/usr/lnk/sqlimports/misc/limit-eob"
EXTRACT_FILE_2="/usr/lnk/sqlimports/misc/limit-eob-test"
ZIP_PROG="/bin/gzip"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
DATE=`date -d "yesterday $(date +%Y%m)01" +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_copy_limit.sh 

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
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        ${ZIP_PROG} ${FNAME}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
        fi
else
        echo "${FNAME} does not exist"
fi
}



#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

rm -f ${LIMIT00MAS}-WH
cp ${LIMIT00MAS} ${LIMIT00MAS}-WH
if test $? -eq 0
then
   rm -f ${EXTRACT_FILE}
   cd ${FLEX}
   ${FLEX}/ohlimpc007.cs
   REC_CNT=`wc -l ${EXTRACT_FILE} | awk '{print $1}'`
   mv ${EXTRACT_FILE} ${EXTRACT_FILE}-${DATE}
   FNAME=${EXTRACT_FILE}-${DATE}
   file_transfer   
   echo "Monthly Copy and Extract of LIMIT00MAS completed. Record count is ${REC_CNT}." | ${MAIL_PROG} -s "Monthly Limit File Extract" ${MAIL_TO}

   #rm -f ${EXTRACT_FILE_2}
   #${FLEX}/ohlimpc008.cs
else
   $PAGE_PROG "$SUBJECT" "$ERR_MSG" $PAGEUSER
   echo "Monthly Copy of LIMIT00MAS failed" | ${MAIL_PROG} -s "Monthly Limit File Extract" ${MAIL_TO}
fi

exit 0
