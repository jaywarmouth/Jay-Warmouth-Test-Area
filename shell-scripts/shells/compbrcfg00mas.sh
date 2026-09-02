#!/bin/sh
#
# to run: compbrcfg00mas.sh
#
# Program Name  : COMPBRCFG00MAS.CBL
# Author        : Kosalai. K
# Date          : 08/19/2025
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
OBJ_DIR="/usr/lnk/obj"
DATETM=`date +%Y%m%d-%H%M%S`

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


# Submit COMPBRCFG00MAS program
submit_COMPBRCFG00MAS()
{
     runcobol ${OBJ_DIR}/COMPBRCFG00MAS

}


#
# Main routine
#
parse_env
#
OLDBRCFG00MAS=$1
  export OLDBRCFG00MAS

BRCFG00MAS=${BRCFG00MAS}
  export BRCFG00MAS 

LOADTIMES=/usr/lnk/grp/LOADTIMES
export LOADTIMES

  BRCFG00MASDIF=/usr/lnk/wt/benefit-wt/BRCFG0-DIFF-${DATETM}
  export BRCFG00MASDIF

echo Compare BRCFG00MAS FILE
date
echo 
echo "   LOADTIMES=${LOADTIMES}"
echo "   OLDBRCFG00MAS=${OLDBRCFG00MAS}"
echo "   BRCFG00MAS=${BRCFG00MAS}"
echo "   BRCFG00MASDIF=${BRCFG00MASDIF}"


submit_COMPBRCFG00MAS
date

exit 0
                                                                                       
