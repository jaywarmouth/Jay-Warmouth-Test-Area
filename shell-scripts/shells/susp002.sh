#!/bin/sh
#
# Program Name  : susp002.sh
# Description   : Post Paid Date to Susp000mas       
#		  -d <ccyymmdd> - Optional paid date, by default uses current date
#		  -h - help flag to show command usage
# Author        : Deborah Wilson  
# Date          : 01/27/00
# Modifications : 03/29/2000 - Added lpp of /usr/pdm/po/misc/PRINT-SUSP002  (LSJ)                
#		: 09/07/2000 - Added copy of SUSP000MAS before processing  (LSJ)
#		: 09/18/2009 - Changes for switch to new check run process with TRIGGERMAS file
#		: 12/15/2009 - Changed lp of PRINT-SUSP002 to scp  (LSJ)
#		: 10/05/2010 - Added convert of PRINT-SUSP002 to PDF and email
#		: 11/11/2019 - Change "a2ps" to "enscript"
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/misc
USER=""
BAK_DIR="/usr/upd/grp"
PAID_DATE=0
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
MAIL_CC="finance@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: susp002.sh [-d <ccyymmdd>]
	-d <ccyymmdd> - optional paid/check date to use. By default it uses the current date. 

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


# Submit susp002 program
submit_susp002()
{
        runcobol ${OBJ_DIR}/susp002 -a ${PAID_DATE}

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
        PAID_DATE=$1
        ;;
    -h) usage
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

cp ${TRIGGERMAS}.null ${TRIGGERMAS}
cp ${SUSP000MAS} ${BAK_DIR}/SUSP000MAS.sav

echo "SUSP002 -- POST PAID DATE TO RELEASED CLAIMS ON SUSP000MAS"
date
submit_susp002
date

cp ${TRIGGERMAS} ${TRIGGERMAS}.sav
cp ${PRINT_DIR}/PRINT-SUSP002 ${BAK_DIR}/PRINT-SUSP002.sav
enscript -rBj -f Courier9 -o - ${PRINT_DIR}/PRINT-SUSP002 | ps2pdf - ${PRINT_DIR}/PRINT-SUSP002.pdf
echo "Check Run Release Report" | ${MAIL_PROG} -s "Check Run - SUSP002" -c ${MAIL_CC} ${MAIL_TO} -a ${PRINT_DIR}/PRINT-SUSP002.pdf 


exit 0
