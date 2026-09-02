#!/bin/ksh
#
# Program Name  : grpgrprb01.sh
# Description   : Warehouse GRPGRPXMAS File Extract
# Author        : Kosalai k
# Date          : 05/19/2026
#                 Command line arguments:
#                 -f Complete update(Full-run)
#                 Note: program will do a full run with or
#                       without the flag.
#                 -p Partial

# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
OUTPUT_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: grpgrprb01.sh [-f] [-p]

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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


# Submit grpgrprb01 program
submit_grpgrprb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/grpgrprb01
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "GRPGRPXMAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   GRPGRPXMAS=${GRPGRPXMAS}"
echo "   GRPGRPRB001=${GRPGRPRB001}"
submit_grpgrprb01
date

exit 0
