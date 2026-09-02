#!/bin/ksh
#
# Program Name  : phdem01.sh
# Description   : Pharmacy Demographic Term 
# Author        : Christina Harris
# Date          : 02/13/98
# Modifications : 03/23/98 - Added new path for FG4AUD  (LSJ)
#		: 05/18/2006 - Changed lp to a run of print_phdem01 and removed USER  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SHELL_DIR="/usr/lnk/shell"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phdem01.sh  

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


# Submit phdem01 program
submit_phdem01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phdem01  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD

date
submit_phdem01
date

${SHELL_DIR}/print_phdem.sh -p 01

exit 0
