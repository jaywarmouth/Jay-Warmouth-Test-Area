#!/bin/ksh
#
# Program Name	: group01.sh
# Description   : Claims to Tape Transfer for HRRX
#                 Command line arguments:
#                 -t System Number (Must be 4 characters long)
#                 -s System Number & Sponsor Number (Must enter 4 character System number and 8 character Sponsor number). 
# Author	: Dave Tucci
# Date		: 04/15/2000
# Modifications : 
#                 Add Sponsor Level Switch (04/29/03 - JM )
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SYS_LEVEL=0
SPO_LEVEL=0
SYS_NBR=0000
SPO_NBR=00000000

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group01.sh [-t <system number>] [-s <system number><sponsor number>]

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

#
# Submit group01 program
submit_group01()
{
  runcobol ${OBJ_DIR}/group01 -s ${SYS_LEVEL}${SPO_LEVEL} -a ${SYS_NBR}${SPO_NBR} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS_LEVEL=1
        SYS_NBR=$1
        ;;
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SPO_LEVEL=1
	ARGUMENT=$1
	SYS_NBR=`echo $ARGUMENT | cut -c1-4`
	SPO_NBR=`echo $ARGUMENT | cut -c5-12`
	echo "SYS_NBR=$SYS_NBR"
	echo "SPO_NBR=$SPO_NBR"
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

submit_group01 
date

exit 0
