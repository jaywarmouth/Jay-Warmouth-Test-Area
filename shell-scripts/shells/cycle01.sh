#!/bin/ksh
#
# Program Name	: cycle01.sh 
# Description   : Calculate new cycle dates and update the CYCLE00MAS file.
#                 Command line arguments:
#                  -c cycletype    must be P, T, W, X, or FULL.                 
#                 
# Author	: Dave Rudawsky
# Date		: 04/01/2015
# Modifications : 04/08/2015 added cycle-type    
#               : 05/15/2015 updates for production version of script (LSJ).
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLETYPE="null"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cycle01.sh [-c cycletype]

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

	
# Submit cycle01 program
submit_cycle01()
{
      runcobol ${OBJ_DIR}/cycle01 -a ${CYCLETYPE}   
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLETYPE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ $CYCLETYPE = "null" ]
then
	usage
fi

echo "Backup of $CYCLE00MAS"
bak $CYCLE00MAS

echo "Calculate cycle dates and update the CYCLE00MAS file"
date
submit_cycle01
date


exit 0
