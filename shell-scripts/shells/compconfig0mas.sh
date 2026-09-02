#!/bin/sh
#
# to run: compconfig0mas.sh [-D]
#
# Program Name  : compconfig0mas.sh
# Author        : Patrick Murphy  
# Date          : 04/22/2019
# UpDate        : 08/10/2023 / Mary Jennings
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


# Submit compconfig0mas program
submit_compconfig0mas()
{
     runcobol ${OBJ_DIR}/COMPCONFIG0MAS
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
# OLD CONFIG0MAS file
CONFIG0MASO=/usr/lnk/grp/CONFIG0MAS.20251111
  export CONFIG0MASO

# NEW CONFIG0MAS file
CONFIG0MASN=/usr/lnk/grp/CONFIG0MAS
 export CONFIG0MASN

# OLD / NEW CONFIG0MAS Differences file
CONFIG0MASDIF=/usr/lnk/wt/benefit-wt/CONFIG0MAS-DIFF-${DATETM}
  export CONFIG0MASDIF


date
echo ""
echo "   CONFIG0MASO=${CONFIG0MASO}"
echo "   CONFIG0MASN=${CONFIG0MASN}"
echo "   CONFIG0MASDIF=${CONFIG0MASDIF}"

submit_compconfig0mas


exit 0
