#!/bin/ksh
#
# Program Name	: drug023.sh
# Description   : GEAP package & price update       
#                 Command line arguments:
#                 -s Switches <######>
# Author	: Debbie Wilson
# Date		: 08/18/98
# Modifications : 08/22/2006 - Added HOSTNAME logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SW="00000000"
PRINT_DIR=/usr/lnk/misc
USER=""
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug023.sh [-s <######>]

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


# Submit drug023 program
submit_drug023()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drug023 -s ${SW}
 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SW=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "GEAP package & price update"
echo "HOSTNAME=$HOSTNAME"
date
submit_drug023
date

exit 0
