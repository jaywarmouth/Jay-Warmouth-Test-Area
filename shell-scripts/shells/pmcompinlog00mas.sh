#!/bin/sh
#
# to run: pmcompinlog00mas.pm [-D]
#
# Program Name  : pmcompinlog00mas.pm
# Author        : Patrick Murphy  
# Date          : 10/07/2019
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
DATETM=`date +%Y%m%d-%H%M%S`
DEBUG=" "

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


# Submit pmcompinlog00mas program
submit_pmcompinlog00mas()
{
     runcobol ${OBJ_DIR}/PMCOMPINLOG00MAS ${DEBUG}
	RETVAL=$?
}


#
# Main routine
#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -D) DEBUG="D"
        ;;
  esac
  shift
done

OLDINLOG00MAS=/usr/upd/grp/INLGWRKMAS-W
  export OLDINLOG00MAS

INLOG00MAS=/usr/upd/grp/INLGWRKMAS-NEW-W                
 export INLOG00MAS 

INLOG00MASDIF=/usr/lnk/wt/oper-wt/misc/INLOG00MAS-DIFF-WEEK-${DATETM}.txt
  export INLOG00MASDIF

LOADTIMES=/usr/lnk/tmp/LOADTIMES
  export LOADTIMES


echo CREATE HPMS FILE
date
echo ""
echo "   OLDINLOG00MAS=${OLDINLOG00MAS}"
echo "   INLOG00MAS=${INLOG00MAS}"
echo "   INLOG00MASDIF=${INLOG00MASDIF}"

submit_pmcompinlog00mas


echo "Return Code = $RETVAL"

exit $RETVAL
