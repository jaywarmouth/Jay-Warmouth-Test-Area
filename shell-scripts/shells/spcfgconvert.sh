#!/bin/sh
#
# Program Name	: SPCFGCONVERT 
# Description   : Convert SPCFG000MAS for changes in file
#                 Command Line Arguments: None
#                 
# Author	: Debbe Kitmiller
# Date		: 10/25/2019
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: SPCFGCONVER
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


 # Submit SPCFGCONVERT program
submit_spcfgconvert()
{
     runcobol ${OBJ_DIR}/SPCFGCONVERT 
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

SPCFG00MASO=${SPCFG00MAS}
export SPCFG00MASO
  
SPCFG00MASN=${SPCFG00MAS}-NEW
  export SPCFG00MASN


DATAERROR=/tmp/SPCFGWRK-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/tmp/loadtimes-teamconvert
  export LOADTIMES

echo "CONVERT SPCFG000MAS NEW FILE"

date
echo "SPCFG00MASO=${SPCFG00MASO}"
echo "SPCFG00MASN=${SPCFG00MASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_spcfgconvert
echo  "   RET_CODE=$RETVAL " 

date

exit ${RETVAL}
