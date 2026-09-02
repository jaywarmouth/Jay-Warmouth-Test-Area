#!/bin/ksh
#
# Program Name	: benefit55.sh
# Description   : Update BEN55WKMAS Benefit Claim file     
#                 Command line arguments:
#                 -s Skip sort flag
#                 -m Set run month <ccyymm>                   
# Author	: Deborah L. Wilson
# Date		: 02/13/01
# Modifications : 08/17/2001 - Added remove and print of PRINT-BENEFIT55  (LSJ)
#		: 09/01/2005 - Added "umask 002" command  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
MONTH=0
MISC_DIR="/usr/lnk/misc"
PRINTFILE="PRINT-BENEFIT55"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: benefit55.sh [-s] [-m <ccyymm>]

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

# Submit benefit55 program
submit_benefit55()
{
        runcobol ${OBJ_DIR}/benefit55 -s ${SKIP_SORT} -a ${MONTH}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -m) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        MONTH=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

umask 002

echo "Benefit 55 Claim Work file Update"
date

submit_benefit55

date


exit 0
