#!/bin/ksh
#
# Program Name	: drprc13.sh
# Description   : Update  "DRUG000MAS Update". Type 32 Records  DRUG000MAS File
#		  
# Date		: 10/07/25

# Modifications : mm/dd/yy (XXX) 


# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drprc13.sh -i <alternate PARMFILE>

ENDOFUSAGE
  exit 1
}


# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    ${OLDIFS}=IFS
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

# Submit  program
submit_drprc13()
{
        runcobol ${OBJ_DIR}/drprc13 
	RETVAL=$?
}


#
# Main routine
#

# Parse environment variables
parse_env


RPTDRPRC13=/usr/lnk/misc/NADAC-DRUGMAS-UPDT-REPORT
export RPTDRPRC13

echo "NADAC type 32 record update on DRUG000MAS"
echo "ASSIGNED FILES:"
echo "DRUG000MAS=${DRUG000MAS}"
echo "NADACUPDT=${NADACUPDT}"
echo "FG4AUD=${FG4AUD}"

date
submit_drprc13
date

exit ${RETVAL}
