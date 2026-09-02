#!/bin/ksh
#
# Program Name	: check01.sh
# Description   : Check Bank Date Update 
#                 Command line arguments:
#                 -a user name
#                 -f filename to read
# Author	: Dave Tucci
# Date		: 05/21/97
# Modifications : 05/21/97 - LSJ - Added env_var & OBJ_DIR logic
#		: 06/20/2002 - LSJ - Added some displays
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
RPT_DIR="/usr/lnk/rpt"
BANK001MAS=""
HEADER=""
USER=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: check01.sh -a ["username"] -f ["pathname&filename"]

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


# Submit check01 program
submit_check01()
{
        runcobol ${OBJ_DIR}/check01 -a ${USER}'            '${HEADER}
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BANK001MAS=$1
        HEADER=`basename ${BANK001MAS}`
        export BANK001MAS
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=/usr/lnk/audit/CHKAUD
export FG4AUD


echo Check Bank Date Update
date
echo
echo " FG4AUD=$FG4AUD"
echo " Input Filename: ${BANK001MAS}"
submit_check01 
date

exit 0
