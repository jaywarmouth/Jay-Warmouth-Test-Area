#!/bin/sh
#
# Program Name	: restack16.sh
# Description   : Report Restack TDS Differences
#                 Command line arguments:
#                   -a alternate record type (run date in format ccyymmdd)

#                 Switches:
#                   none

# Author	: Dave Rudawsky 
# Date		: 11/26/2014
#
# Modifications : 12/03/2014 - Made modifcations for directory and added coding to email drug spent report. (TT:12334-11)(DME) 
#		: 01/21/2015 - Modify the report name from RSTCK-COMPARE-<DATE> to RSTCK-DRGSPNT-<DATE> and add diozzi@pdmi.com to email(TT:4805-9)(DME)
#		: 03/12/2015 - change indivual emails to restack@pdmi.com (DME)
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
REC_TYPE=0
DATE=`date +"%Y%m%d"`
#Maybe needed for possible multiple runs in a day.
#TIME=`date +"%H%M%S"`
MAIL_PROG="/usr/bin/mutt"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack16.sh -a <ccyymmdd>
	
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

	
# Submit restack16 program
submit_restack16()
{
   if [ ${REC_TYPE} = 1 ]
     then
        runcobol ${OBJ_DIR}/restack16 -a ${ARGUMENT}
     else
        runcobol ${OBJ_DIR}/restack16 
   fi
}

#Email Drug Spent Report
email_rpt()
{
if  test -s ${DRGSPNT}
then
	a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${DRGSPNT} | ps2pdf - ${DRGSPNT}.pdf
	echo "Attached is the RSTDS-COMPARE report" |${MAIL_PROG} -a ${DRGSPNT}.pdf -s "RESTACK DRUG SPENT" -c operations@pdmi.com restack@pdmi.com
	scp ${DRGSPNT}* husk:/usr/lnk/shares/ftp-tmp/restack
else
	echo "RSTDS-COMPARE report is zero or does not exist. Aborting process."
	exit 99
fi
}


#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        ARGUMENT=$1
	REC_TYPE=1
	;;
#    -t) TEST_MODE=1
#        ;;
  esac
  shift
done


# Parse environment variables
parse_env

DRGSPNT="/usr/lnk/wrk/RSTK-DRGSPNT-${DATE}"
   export DRGSPNT

   echo "Restack TDS Difference Report"
   date
   echo "EXPORT PATHS:"
   echo "   RESTK00MAS=$RESTK00MAS"
   echo "   CARDH00MAS=$CARDH00MAS"
   echo "   RSTDS-COMPARE=${DRGSPNT}"
   
   submit_restack16
   date

   email_rpt

exit 0
