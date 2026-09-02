#!/bin/sh
#
# Program Name	: phdem05.sh
# Description   : Create phdem-rpt for pharmacy and escalation team.
#                 No Switches:
# Author	: Janice Lanzo 
# Date		: 1/30/2015
# Modifications : 03/18/2015 - modify script to run in production as a JAMS Job. (TT:12468-3) (DME)
#		: 03/31/2015 - update email code to not use variables so can be processed in jams.(TT:12468-3) (DME)
#		: 04/7/2015 - found coding issue placed variables back in for emails. (TT:12468-3)(DME)
#		: 01/16/2015 -  Remove the "escalationteam@pdmi.com" email address (TT:13915-22; DME)
#		: 01/12/2020 - Change "a2ps" to "enscript"
#
# 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="pharmacypayables@pdmi.com"
MAIL_CC="operations@pdmi.com"
DATE=`date +%Y%m%d`
FILE_DIR="/usr/lnk/tmp"

# Routines Used:

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phdem05.sh

ENDOFUSAGE
  exit 1
}

#
# Email report
email()
{
echo ${PHDEMRPT}
enscript -rBj -a2- -o - ${PHDEMRPT} | ps2pdf - ${PHDEMRPT}.pdf
echo "The report of PHDEM Sep Chk/Ind Code records to be updated is attached." | ${MAIL_PROG} -s "PHDEM Report" -c ${MAIL_CC} ${MAIL_TO} -a ${PHDEMRPT}.pdf
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

#	
# Submit phdem05 program
submit_phdem05()
{
      runcobol ${OBJ_DIR}/phdem05
}

#
# Main routine
#
#Check command line validity, call usage if incorrect

#Parse environment variables
parse_env

# Assign alternate environment variables

PHDEM00MAS=${FILE_DIR}/phdem-sep-chck-ind
   export PHDEM00MAS


PHDEMRPT=/tmp/${DATE}-phdem-rpt
   export PHDEMRPT

   echo "PHDEM00MAS SEPARATE CHECK FILE LISTING"
   date
   echo "EXPORT PATHS:"
   echo "   PHDEM00MAS=${PHDEM00MAS}"
   echo "   PHDEMRPT=${PHDEMRPT}" 
   submit_phdem05
   date

#email Report
email

#remove file
rm -f ${PHDEMRPT}

exit 0
