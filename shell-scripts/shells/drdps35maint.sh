#!/bin/ksh
#
# Program Name  : drdps35maint.sh
# Description   : DPS Type cd 35 Add/Term Maintenance
# Author        : Debbie Wilson    
# Date          : 09/10/99
# Modifications : 02/26/2006 - Added umask command temporarily  (LSJ)                
#
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

usage: drdps35maint.sh 

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


# Submit drdps35maint program
submit_drdps35maint()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drdps35maint 

}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables
DRUGWRKMAS=/usr/lnk/drug/DRWRK00MAS.dps
export DRUGWRKMAS 
date

umask 000

submit_drdps35maint
date

exit 0
