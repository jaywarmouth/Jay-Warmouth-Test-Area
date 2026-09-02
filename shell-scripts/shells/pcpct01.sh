#!/bin/ksh
#
# Program Name	: pcpct01_newcycle.sh
# Description   : Update PCP County File for Summa 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -m Set run month <ccyymm>                   
#                 -e Set membership run
#                 -c Set claims run
# Author	: Deborah L. Wilson
# Date		: 03/30/00
# Modifications : 09/01/2005 - Added "umask 002" command  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
MONTH=0
MEMBERSHIP=0
CLAIMS=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pcpct01.sh [-s] [-e] [-c] [-m <ccyymm>]

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

# Submit pcpct01 program
submit_pcpct01()
{
        runcobol ${OBJ_DIR}/pcpct01 -s ${SKIP_SORT}${MEMBERSHIP}${CLAIMS} -a ${MONTH}
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
    -e) MEMBERSHIP=1
        ;;
    -c) CLAIMS=1
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

umask 002

# Assign alternate environment variables

echo "PCP County File Update for Suma"
date
submit_pcpct01 
date

exit 0
