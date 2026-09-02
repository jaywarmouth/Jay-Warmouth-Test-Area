#!/bin/sh
#
# Program Name	: zip-cl106-month.sh
# Description	: Zips the *.PCX" files created from the month claim106 run
#		  Command Line Arguments:
#		  -d <yyyymm> - month end date
# Author	: Linda S. Jefferis
# Date		: 07/07/2006
# Modifications : 10/11/2006 - Changes for 4-digit system numbers  (LSJ) 
#		: 01/26/2007 - Added logic for secure_transfer.sh  (LSJ)
#		: 10/08/2008 - Changed logic for files run for pay and twice instead of mon  (LSJ)
#		: 06/30/2009 - Adjusted for "W" file for sys0054  (LSJ)
#		: 12/03/2009 - Add copy to /usr/lnk/wt/ph-01  (LSJ)
#		: 02/04/2010 - Fix for new WT server  (LSJ)

#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
ZIP_PROG="/usr/bin/zip"
TR_DIR="/usr/lnk/shares/SXC"
TEXT_FILE="/usr/lnk/tapes/???CL106-?-SXCTEXT"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/bin/mail"
WEEK=0
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
WT_DIR="/usr/lnk/wt/ph-01"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-cl106-month.sh -d <yyyymm>

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
while [ $# -gt 0 ]
do
  case "$1"
  in
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

# Parse environment variables
parse_env

${ZIP_PROG} -j ${PO_DIR}/sxc-${DATE}.zip ${TEXT_FILE}
find ${PO_DIR}/sys???? -name "???CL????A-[P,O,T,W].PCX" -print | ${ZIP_PROG} -j ${PO_DIR}/sxc-${DATE}.zip -@
if test -s ${PO_DIR}/sxc-${DATE}.zip
then
	${TR_PROG} SXC ${PO_DIR}/sxc-${DATE}.zip
	if test $? -ne 0
	then
		echo "-*> Encryption and transfer of file failed"
	else
		cp ${PO_DIR}/sxc-${DATE}.zip ${WT_DIR}
		echo "The file, sxc-${DATE}.zip.pgp, is available." | ${MAIL_PROG} -s "SXC FILE NOTIFICATION" ${MAIL_TO} 
	fi
		
else
	echo "-*> sxc-${DATE}.zip does not exist"
fi


exit 0
