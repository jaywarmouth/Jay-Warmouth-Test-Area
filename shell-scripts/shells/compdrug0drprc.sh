#!/bin/sh
#
# to run: COMPDRUG0DRPRC.sh
#
# Program Name  : COMPDRUG0DRPRC.sh   
# Author        : GREG V
# Date          : 05/14/2024
#
#  THIS IS A "SPECIAL" COMPARE THAT USES THE DRUG000MAS FILE AND DRGPRC0MAS FILE
#  THE DIFFERENT PRICING OCCURS FILES ARE COMPARED BETWEEN THE DRUG000MAS AND
#  DRUPRC0MAS FILES TO VERIFY THERE AR NO DIFFERENCES.


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


# Submit COMPDRUG0DRPRC program

  submit_COMPDRUG0DRPRC()
     {

      runcobol ${OBJ_DIR}/COMPDRUG0DRPRC

     }


#
# Main routine
#
# DRUG000MASO=/usr/devl/users/gvernon/WORK/DRUG000MAS-OLD
  DRUG000MAS=/usr/lnk/drug/DRUG000MAS
  export DRUG000MAS

  DRGPRC0MAS=/usr/lnk/drug/DRGPRC0MAS
  export DRGPRC0MAS

  DRGPRC0MASDIF=/usr/lnk/wrk/DRGPRC0MAS-DIFF-${DATETM}
  export DRGPRC0MASDIF


echo "SPECIAL COMPARE FOR  DRUG000MAS & DRGPRC0MAS FILES"
date
echo ""
echo "   DRUG000MAS=${DRUG000MAS}"
echo "   DRGPRC0MAS=${DRGPRC0MAS}"
echo "   DRGPRC0MASDIF=${DRGPRC0MASDIF}"

submit_COMPDRUG0DRPRC

date

exit 0
