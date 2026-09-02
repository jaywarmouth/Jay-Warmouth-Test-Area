#!/bin/ksh
# to run: scssconvert.sh
#
#
# Program Name	: SCSSCONVERT
# Description   : Convert SCSS000MAS for change in length of SCSS-MAS-NUMBER
#                 Command Line Arguments: None
#                 
# Author	: Diana Homoly
# Date		: 10/26/2018
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var

OBJ_DIR="/usr/lnk/obj"

DATETM=`date +%Y%m%d-%H%M%S`
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: SCSSCONVERT
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


# Submit SCSSCONVERT program
submit_SCSSCONVERT()
{
     runcobol ${OBJ_DIR}/SCSSCONVERT

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

SCSS000MASO=${SCSS000MAS}
  export SCSS000MASO
  
SCSS000MASN=${SCSS000MAS}-NEW
  export SCSS000MASN

DATAERROR=/tmp/SCSS000MAS-DATAERROR-${DATETM}
  export DATAERROR

LOADTIMES=/usr/lnk/tmp/loadtimesdh
  export LOADTIMES
echo "CONVERT SCSS000MAS NEW FILE"



date
echo "SCSS000MASO=${SCSS000MASO}"
echo "SCSS000MASN=${SCSS000MASN}"
echo "DATAERROR=${DATAERROR}"
echo "LOADTIMES=${LOADTIMES}"             

submit_SCSSCONVERT

date

exit 0
