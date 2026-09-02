#!/bin/ksh
#
# Program Name	: zip-cl106.sh
# Description	: Zips the *.PCX" files created from the claim106 run
#		  Command Line Arguments:
#		  -d <mmddccyy> - period ending date
#		  -w Week-cycle flag
# Author	: Linda S. Jefferis
# Date		: 03/21/2001
# Modifications : 01/16/2003 - Changes for switch from CD to Web transfer 
#		: 08/08/2005 - Added week-cycle flag
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 11/29/2005 - Changes for new system names  (LSJ)
#               : 02/14/2006 - Change /usr/bin/logname to computers@pdmi.com
#		: 03/26/2006 - Added copy of zip file to ftp-tmp for SXC  (LSJ)
#		: 04/18/2006 - Added email for SXC  (LSJ)
#		: 06/19/2006 - Removed copy of file for SXC  (LSJ)
#		: 09/25/2006 - Changes for 4-digit system number conversion  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
ZIP_PROG="/usr/bin/zip"
TR_DIR="firefly:/usr/lnk/wt/ph-04"
#TR_DIR_2="/usr/lnk/shares/SXC"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/bin/mail"
WEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-cl106.sh -d <p/e date - mmddccyy> -w
	-w  week-cycle flag  (optional)

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
    -w) WEEK=1
	;;
  esac
  shift
done

cd ${PO_DIR}
if [ $WEEK = 1 ]
then
   find sys???? -follow -name "???CL????A-W.PCX" -print | ${ZIP_PROG} wk-${DATE}.zip -p -@
   scp ${PO_DIR}/wk-${DATE}.zip ${TR_DIR}
   #cp ${PO_DIR}/wk-${DATE}.zip ${TR_DIR_2}
   echo "The week file, wk-${DATE}.zip, is available for downloading. Please delete the file once it has been downloaded." | ${MAIL_PROG} -s "WEEK FILE NOTIFICATION(Pharm. Horizons)" ${MAIL_TO} 
   #echo "The week file, wk-${DATE}.zip.pgp, is available." | ${MAIL_PROG} -s "SXC WEEK FILE NOTIFICATION" ${MAIL_TO} 
else
   find sys???? -follow -name "???CL????A-[O,P].PCX" -print | ${ZIP_PROG} ${DATE}.zip -p -@
   scp ${PO_DIR}/${DATE}.zip ${TR_DIR}
   #cp ${PO_DIR}/${DATE}.zip ${TR_DIR_2}
   echo "The bi-weekly file, ${DATE}.zip, is available for downloading. Please delete the file once it has been downloaded." | ${MAIL_PROG} -s "BI-WEEKLY FILE NOTIFICATION(Pharm. Horizons)" ${MAIL_TO}
   #echo "The bi-weekly file, ${DATE}.zip, is available." | ${MAIL_PROG} -s "SXC BI-WEEKLY FILE NOTIFICATION" ${MAIL_TO}
fi

# Parse environment variables
#parse_env

exit 0
