#!/bin/sh
#
# Program Name	: SITECONVERT 
# Description   : Convert SITE0000MAS for changes in file
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: SITECONVERT
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


# Submit SITECONVERT program
submit_siteconvert()
{
     runcobol ${OBJ_DIR}/SITECONVERT 
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

SITE000MASO=${SITE000MAS}
export SITE000MASO
  
SITE000MASN=${SITE000MAS}-NEW
  export SITE000MASN


DATAERROR=/tmp/SITEWRK-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/tmp/loadtimes-siteconvert
  export LOADTIMES

echo "CONVERT SITE000MAS NEW FILE"

date
echo "SITE000MASO=${SITE000MASO}"
echo "SITE000MASN=${SITE000MASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_siteconvert

date
echo "  RET_CODE=$RETVAL"

exit ${RETVAL}
