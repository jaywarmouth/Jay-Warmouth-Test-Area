#!/bin/ksh
#
# Program Name	: cardh09.sh
# Description	: Alternate Cardholder Key Load
# Author	: Linda S. Jefferis
# Date		: 10/31/96
# Modifications : 06/19/97 - LSJ - Added env_var & OBJ_DIR logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
DATE=`date +%m%d%y`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh09.sh 

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

#
# Main routine
#

# Parse environment variables
parse_env

CARDH00MAS=/usr/lnk/crd_01/CAWRK00SUMA
CARDH09KEY=/usr/lnk/grp/CARDH09KEY.suma
export CARDH00MAS CARDH09KEY

echo Alternate Cardholder Key Load
date
rm ${CARDH09KEY}
runcobol ${OBJ_DIR}/cardh09
date
#echo $DATE > ${RPT_DIR}/cardh09_status

exit 0
