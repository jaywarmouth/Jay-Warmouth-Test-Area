#!/bin/sh
#
# Script Name	:  cldemarchive.sh
# Program Name	:  clcmparchive.cbl
# Description   : Archive  CLDEM00MAS file 
#                 
# Author	: Patrick Murphy
# Date		: 08/26/2026
# Modifications : 
# T03008 - 2026-##-## - PM - cldemarchive.cbl - PROJ-65383 [COBOL F6] - CLDEM00MAS Archive Program -(TD-16333) - TBD

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

##  enter last batch needed for archive
#BATCHRANGE="aD31Z999"
BATCHRANGE="XL31Z999"


RETVAL=0
DATE=$(date +%Y%m%d)

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage:  cldemarchive.sh -a <batchrange>
        all input parameters are optional:
                -a <batchrange> - default is entire file (ZZ99Z999)

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


# Submit  cldemarchive program
submit_cldemarchive()
{
     runcobol ${OBJ_DIR}/cldemarchive
	RETVAL=$?
}



# Main routine#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

# Assign alternate environment variables

 CLDEM00MASR=${CLDEM00MAS}-ARCHIVE-${DATE}
# CLDEM00MASR=/home/flim/test/CLDEM00MAS-ARCHIVE-${DATE}
export  CLDEM00MASR

 CLDEM00MASN=${CLDEM00MAS}-NEW-${DATE}
# CLDEM00MASN=/home/flim/test/CLDEM00MAS-ARCHIVE-${DATE}
export  CLDEM00MASN

 CLDEM00MASO=${CLDEM00MAS}
# CLDEM00MASO=/home/flim/test/CLDEM00MAS
export  CLDEM00MASO


echo "ARCHIVE  CLDEM00MAS NEW FILE"

date

echo " CLDEM00MASR=${CLDEM00MASR}"
echo " CLDEM00MASO=${CLDEM00MASO}"
echo " CLDEM00MASN=${CLDEM00MASN}"
submit_cldemarchive

date

exit ${RETVAL}
