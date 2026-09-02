#!/bin/ksh
#
# Program Name	: wkly_crdhms01.sh
# Description	: Creation and transfer of data file for HMS
# Author	: Linda S. Jefferis
# Date		: 08/10/2010
# Modifications : 01/08/2013 - Updated email distribution 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%Y%m%d`
CRDHMS01TAP="/usr/lnk/tapes/CRDHMS01TAP-$DATE"
SEND_FILE="/usr/lnk/shares/ftp-tmp/PDMIELIG.$DATE.txt"
SHELL_DIR=/usr/lnk/shell
RPT_DIR=/usr/lnk/rpt
TR_PROG=/usr/lnk/shell/secure_transfer.sh
TR_ID=HMS
MAIL_PROG=/bin/mail
MAIL_TO="knichols@hms.com"
MAIL_CC="operations@pdmi.com"
OPTUMMEDSUB=/usr/lnk/wt/oper-wt/sftpexport/OptumMedSub

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wkly_crdhms01.sh 

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
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

find /usr/lnk/tapes -follow -name "CRDHMS01TAP-*" -mtime +14 -exec rm {} \;

${SHELL_DIR}/crdhms01.sh > ${RPT_DIR}/crdhms01 2>&1

cat ${RPT_DIR}/crdhms01
RECNT=`grep "TOTAL MEMBERS SENT:" ${RPT_DIR}/crdhms01 | awk '{ print $4 }'`

echo ""
echo ""
echo "--> Transferring data file"
cp ${CRDHMS01TAP} ${SEND_FILE}

# File to Optum-MedSub
cp ${SEND_FILE} ${OPTUMMEDSUB}

${TR_PROG} ${TR_ID} ${SEND_FILE}
RETVAL="$?"
if [ "$RETVAL" -ne "0" ]
then
	echo "-*> Error with transfer of data file"
else
	echo "--> Transfer of file completed"
	echo -e "The weekly PDMI-HMS data file has been uploaded.\n\nRecord Count = $RECNT" | ${MAIL_PROG} -s "Weekly PDMI-HMS File Upload" -c ${MAIL_CC} ${MAIL_TO}
	rm -f ${SEND_FILE}
fi


exit 0
