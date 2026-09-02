#!/bin/ksh
#
# Program Name  : phnet06.sh
# Description   : FLAG 205 REJ OVERRIDE FOR NETWORKS
# Author        : Christina Harris
# Date          : 11/24/97
# Modifications : 02/24/2006 - Added umask command temporarily  (LSJ)
#		: 05/18/2006 - Removed PRINT_DIR and took USER off runcobol command  (LSJ)
#		: 05/18/2006 - Changed lp to print_phnet.sh  (LSJ)
#		: 03/20/2007 - Removed run of print_phnet.sh; helpdesk doesn't use the printouts  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SHELL_DIR="/usr/lnk/shell"
USER=""
CHAIN_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet06.sh -a ["username"] 

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


# Submit phnet06 program
submit_phnet06()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet06 -s ${CHAIN_RUN}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USER=$1
        ;;
    -s) CHAIN_RUN=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env
FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD 


# Assign alternate environment variables
submit_phnet06


exit 0
