#!/bin/ksh
#
# Program Name	: convgr01.sh 
# Description   : Conversion Process For New Group Format
#                 Command line arguments:
# Author	: Kim Konyshak
# Date		: 07/15/97
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/pdm/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/programs/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convgr01.sh

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

# Submit convgr01 program
submit_convgr01()
{
      runcobol ${OBJ_DIR}/convgr01
}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables
GROUP00NEW=/usr/clm_06/GROUP00NEW
GROUP00MAS=/usr/pdm/tmp/GROUP00MAS
export GROUP00MAS GROUP00NEW

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   GROUP00MAS=$GROUP00MAS"
echo "   GROUP00NEW=$GROUP00NEW"
submit_convgr01  
date

exit 0
