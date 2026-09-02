#!/bin/ksh
#
# Program Name	: clms_prrx.sh
# Description	: Transfer data files for ProActive-GHCC
#               : Command Line Arguments:
#                       -p <ccyymmdd> Date for filename
# Author	: Linda Jefferis
# Date		: 01/20/2010
# Modifications : 08/16/2010 - Added copy of all files to prrx-03 as per request from Laura at PRRX.
#		: 08/30/2010 - As per email request from ProActive, removed all copies to ghhc web transfers.  (LSJ)
#		: 01/20/2014 - Added prrx-07 to file copies. (DME)
#		: 05/27/2014 - Add logic for files sent 23rd versus EOM
#		: 05/11/2015 - Distribution change - TT:12790-4
#		: 06/01/2015 - updated WT_DIR3
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes/PROACTIVE
MAIL_TO="Laura.Weigand@VeritasLTC.com"
MAIL_CC="operations@pdmi.com"
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
WT_DIR1="/usr/lnk/wt/prrx-03"
WT_DIR2="/usr/lnk/wt/prrx-07"
WT_DIR3="/usr/lnk/wt/prrx-sftp"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_prrx.sh [-p <ccyymmdd>] 
	where <ccyymmdd> is current p/e date.

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}



#
# Main routine
#

#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_DATE=$1
        ;;
  esac
  shift
done

parse_env

PE_DAY=`echo ${FILE_DATE} | cut -c7-8`

echo 
echo "--> Copying files..."

case ${PE_DAY} in
   "23") GRP_LIST=/usr/lnk/log/prat-grps-23rd.txt
	;;
   "28" | "30" | "31")
	GRP_LIST=/usr/lnk/log/prat-grps-eom.txt
	;;
   *) echo "-*> the entered date, ${FILE_DATE} appears to be wrong."
	usage
	;;
esac

for GRP in `cat ${GRP_LIST}`
do
	cp ${FILE_LOC}/*${GRP}* ${WT_DIR1}
	cp ${FILE_LOC}/*${GRP}* ${WT_DIR2}
	cp ${FILE_LOC}/*${GRP}* ${WT_DIR3}
done
 
echo "-=> Finished."

exit 0
