#!/bin/ksh
#
# to run: restack12.sh -b 20130206
#
# Program Name	: restack12.sh 
# Description   : Claim Restack Analysis Report 
#                 Command line arguments:
#		  -b <restack date> - date of restacking event to be reported (required)
#                 Switches:
#                    none
# Author	: Peggy Voytilla
# Date		: 12/07/2012
# Modifications : 10/08/2013 - Add DMROUT file
#		: 01/22/2015 - Remove cthornton@pdmi.com jmasluk@pdmi.com mpaulus@pdmi.com from Over/Under Report email and add diozzi@pdmi.com (TT4805-9)(DME)
#		: 01/22/2015 - Remove rclark@pdmi.com cthornton@pdmi.com from DMR File email and added diozzi@pdmi.com and jlanzo@pdmi.com (tt4805-9)(DME)
#		: 01/23/2015 - Correct Script by adding a date variable for current date. (TT:4805-9)(DME)
#		: 01/29/2015 - add coding to copy restack files to husk. (TT:4905-9)(DME)
#		: 03/12/2015 - replace individual emails with restack@pdmi.com
#		: 03/19/2018 - TT18341-1; CLLOC00MAS assignment
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RUN="/usr/rmcobol/terminfo-d0.cfg"
RSTK_DATE="null"
DATETM=`date +%Y%m%d%H%M%S`
TEMP_DIR="/usr/lnk/tmp"
MAIL_PROG="/usr/bin/mutt"
RSTK_DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack12.sh [-b <restack date>]

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

	
# Submit restack12 program
submit_restack12()
{
      runcobol ${OBJ_DIR}/restack12 -a ${RSTK_DATE} 
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	RSTK_DATE=$1
	;;

  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

CLLOC00MAS=/usr/lnk/claims/CLLOC-RESTACK; export CLLOC00MAS
RESTK00IDX=${TEMP_DIR}/RESTACK12-IDX
REPORTIDX=${TEMP_DIR}/REPORTIDX
 export RESTK00IDX REPORTIDX

REPORTFILE=${TEMP_DIR}/RESTACK12-REPORT-${DATETM}.csv
 export REPORTFILE
DMROUT=${TEMP_DIR}/RESTACK12-DMR-${DATETM}.txt
export DMROUT


date
echo "Claim Restack Analysis Report Files:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLLOC00MAS=$CLLOC00MAS"
echo "   CLMRS00MAS=$CLMRS00MAS"
echo "   RESTK00IDX=$RESTK00IDX"
echo "   RESTK00MAS=$RESTK00MAS"
echo "   REPORTFILE=$REPORTFILE"
echo "   DMROUT=$DMROUT"
submit_restack12
date

echo "Attached is report from restack12 process." | ${MAIL_PROG} -s "Restack12 - Over/Under Report" -a ${REPORTFILE} restack@pdmi.com
echo "Attached is DMR file from restack12 process." | ${MAIL_PROG} -s "Restack12 - DMR File" -a ${DMROUT}  restack@pdmi.com

rm -f ${RESTK00IDX}
rm -f ${REPORTIDX}

scp ${TEMP_DIR}/RESTACK12-* husk:/usr/lnk/shares/ftp-tmp/restack

exit 0
