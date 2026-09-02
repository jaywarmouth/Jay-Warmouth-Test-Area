#!/bin/sh
#
# to run: compgroup00mas.sh [-D]
#
# Program Name  : compgroup00mas.sh
# Author        : kosalai  
# Date          : 11/18/2025
# UpDate        : 
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
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


# Submit compgroup00mas program
submit_compgroup00mas()
{
     runcobol ${OBJ_DIR}/COMPGROUP00MAS
 RETVAL=$?
        echo "Return Code = $RETVAL"

}


#
# Main routine
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

#
# OLD GROUP00MAS file
GROUP00MASO=/usr/lnk/grp/GROUP00MAS.20251118
  export GROUP00MASO

# NEW GROUP00MAS file
GROUP00MASN=/usr/lnk/grp/GROUP00MAS
 export GROUP00MASN

# OLD / NEW GROUP00MAS Differences file
GROUP00MASDIF=/usr/lnk/wt/benefit-wt/GROUP00MAS-DIFF-${DATETM}
  export GROUP00MASDIF


date
echo ""
echo "   GROUP00MASO=${GROUP00MASO}"
echo "   GROUP00MASN=${GROUP00MASN}"
echo "   GROUP00MASDIF=${GROUP00MASDIF}"

submit_compgroup00mas


exit 0
