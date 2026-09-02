#!/bin/ksh
#
# Program Name  : team01.sh
# Description   : Update Cardholders with blank CRD-TEAM-MEMBER to UNK SYS=73 
#		  Command Line Arguments: No
#                 
# Author        : Lucy A. Caraballo
# Date          : 01/06/2016
# Modifications : 01/08/2016 - Prepare Script for Production. (DME)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: team02.lc 

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


# Submit team02 program
submit_team02()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/team02  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables
TEAM02CSV=/usr/lnk/tmp/TEAM02CSV
export TEAM02CSV
FG4AUD=${CRDAUDFG}; export FG4AUD

echo "UPDATE TEAM MEMBER TO UNK ON CARDH00MAS file"
date
echo "EXPORT PATHS:"
echo "   CARDH00MAS=${CARDH00MAS}"
echo "   TEAM02CSV=$TEAM02CSV"
echo "	 FG4AUD=${FG4AUD}"
submit_team02
date

exit 0
