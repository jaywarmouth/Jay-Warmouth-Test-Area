#!/bin/ksh
#
# Program Name  : group10.sh
# Description   : Redbrick GROUP File Extract
#		  Command Line Arguments:
#		    -z sample data flag
# Author        : Dave Tucci
# Date          : 06/26/98
# Modifications : 04/04/2001 - Added sample switch  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/po/misc
USER=""
SAMP_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group10.sh [-z]

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


# Submit group10 program
submit_group10()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/group10

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -z) SAMP_FLAG=1
	;;
     *) usage
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${SAMP_FLAG} = 1 ]
then
	ENV_FILE="/usr/lnk/demo/env_var.demo"
	parse_env
fi

echo "Group Extract for Redbrick"
date
submit_group10
date

exit 0
