#!/bin/ksh
#
# Program Name  : gener05.sh
# Description   : GENER00MAS load
# Author        : David Tucci
# Date          : 11/19/97
# Modifications : 12/31/97 - Changed gener05 report to get emailed  (LSJ)
#		: 04/13/2006 - Changed logic for emailing report  (LSJ)
#		: 05/03/2006 - Removed email when file is empty (LSJ)
#		: 05/03/2006 - Changed MAIL_TO from cjohnson to benefits  (LSJ)
#		: 08/22/2006 - Added HOSTNAME logic  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
RPT_GENER05=/usr/lnk/misc/PRINT-GENER05
MAIL_TO="benefits@pdmi.com"
MAIL_PROG=/bin/mail
MAIL_SUBJ="Weekly Medispan - GENER05"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gener05.sh 

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


# Submit gener05 program
submit_gener05()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/gener05

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Update Gener00mas/GPI"  
echo "HOSTNAME=$HOSTNAME"
date

submit_gener05

if test -s ${RPT_GENER05}
then
   cat ${RPT_GENER05} | ${MAIL_PROG} -s ${MAIL_SUBJ} ${MAIL_TO}
fi

date

exit 0
