#!/bin/ksh
#
# Program Name  : drug069.sh
# Description   : Medispan Supplemental Name File Load
#		  Command Line Arguments:
# Author        : Mike Paulus
# Date          : 09/23/08
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug069.sh 

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


# Submit drug069 program
submit_drug069()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drug069

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "DRUG - Supplemental Name Files Update"
echo ""
echo "HOSTNAME=$HOSTNAME"
echo ""
echo "MEDNAMETAP=$MEDNAMETAP"
echo "MEDNDCTAP=$MEDNDCTAP"
echo "MEDVALTAP=$MEDVALTAP"
echo "MEDNAM0MAS=$MEDNAM0MAS"
echo "MEDNDC0MAS=$MEDNDC0MAS"
echo "MEDVAL0MAS=$MEDVAL0MAS"
date
submit_drug069
date

exit 0
