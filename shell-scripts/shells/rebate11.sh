#!/bin/ksh
#
# Program Name	: rebate11.sh
# Description   : Update field on CLAIM00MAS with manufacturer code for rebates.
#                 Command line arguments:
#                 -s Skip Sort
#                 -t System Number  (Must be 4 characters long)
#                 -x Sponsor Number (Must be 8 characters long)
#                 -m <manuf. abbrev.> 
# Author	: James Masluk      
# Date		: 11/28/00
# Modifications :
#                 09/03/02 - Changed Sponsor Number to 8 characters long.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
MAN=""
SYS=0000
SPO=00000000
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebate11.sh [-s] [-t <sys#>] [-x <spo#>] [-m <manuf>]
	-s  skip sort flag (optional)
	<sys#> is the 4-digit system number (required)
	<spo#> is the 8-digit sponsor number (required)
	<manuf> is the manufacturer's abbrev. code in Uppercase (required)
   example:  rebate11.sh -t 0048 -x 00000283 -m AVENT

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


# Submit rebate11 program
submit_rebate11()
{
  runcobol ${OBJ_DIR}/rebate11 -s ${SKIP_SORT} -a ${SYS}${SPO}${MAN}'          '  
}
#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 4 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS=$1
        ;;
    -x) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SPO=$1
        ;;
    -m) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        MAN=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Rebate Files - REBATE11"
echo "MANUFACTURER:  ${MAN}"
date
submit_rebate11   
date

exit 0
