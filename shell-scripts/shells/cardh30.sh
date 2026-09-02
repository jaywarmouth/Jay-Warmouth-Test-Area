#!/bin/ksh
#
# Program Name	: cardh30.sh
# Description   : Non-matched cardholder report
#                 Command line arguments:
# Author	: Dave Tucci
# Date		: 07/24/97
# Modifications : 
#                 09/23/97 - CMH - Add code for 29sc version of program.
#		: 11/16/00 - LSJ - changed /usr/pdm file path to /usr/lnk
#		: 07/23/03 - a new 39 layout added
#		: 12/08/2005 - Added umask  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HEADER=""
LAYOUT=""
SYSTEM=""
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="benefits@pdmi.com"
PRINT_DIR="/usr/lnk/misc"
PRINT_FILE="CARDH30RPT"
DTETM=`date +%Y%m%d-%H%M%S`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh30.sh -s [system] -f [filename] -l [layout] 

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


# Submit cardh30 program
submit_cardh30()
{
        runcobol ${OBJ_DIR}/cardh30 -a ${SYSTEM}${LAYOUT}
}

# Provide report to Benefits
send_report()
{
	a2ps -1Bl132 -o - ${PRINT_DIR}/${PRINT_FILE} | ps2pdf - ${PRINT_DIR}/${DTETM}-${PRINT_FILE}-${SYSTEM}.pdf
	echo "Attached is the Non-matched report for ${SYSTEM}" | ${MAIL_PROG} -a ${PRINT_DIR}/${DTETM}-${PRINT_FILE}-${SYSTEM}.pdf -s "Non-Matched Report" ${MAIL_TO}
	rm -f ${PRINT_DIR}/${DTETM}-${PRINT_FILE}-${SYSTEM}.pdf
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
        HEADER=$1
        echo ${HEADER}
        ;;
    -l) shift
        LAYOUT=$1
        echo ${LAYOUT}
        case "$1"
        in 
           '13     ') CARDH13TAP=/usr/lnk/${HEADER} 
               export CARDH13TAP
               ;;
           '21     ') CARDH21TAP=/usr/lnk/${HEADER}
               export CARDH21TAP
               ;;
           '21sc   ') CARDH21SCTAP=/usr/lnk/${HEADER}
               export CARDH21SCTAP
               ;;
           '23     ') CARDH23TAP=/usr/lnk/${HEADER}
               export CARDH23TAP
               ;;
           '23lin  ') CARDH23LINTAP=/usr/lnk/${HEADER}
               export CARDH23LINTAP
               ;;
           '23lintx') CARDH23LINTXTAP=/usr/lnk/${HEADER}
               export CARDH23LINTXTAP
               ;;
           '29     ') CARDH29TAP=/usr/lnk/${HEADER}
               export CARDH29TAP
               ;;
           '29sc   ') CARDH29SCTAP=/usr/lnk/${HEADER}
               export CARDH29SCTAP
               ;;
           '39ss   ') CARDH39TAP=/usr/lnk/${HEADER}
               export CARDH39TAP
               ;;
        esac
        ;;
    -s) shift
        SYSTEM=$1
        echo ${SYSTEM}
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

umask 000

echo Group Update from Tape
date
submit_cardh30 

send_report

date

exit 0
