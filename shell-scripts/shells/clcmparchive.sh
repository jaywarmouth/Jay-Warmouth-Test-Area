#!/bin/sh
#
# Script Name	:  clcmparchive.sh
# Program Name	:  clcmparchive.cbl
# Description   : Archive  CLCMP00MAS file 
#                 
# Author	: Ferdinand Lim
# Date		: 08/18/2026
# Modifications : 
# T03011 - 08/25/2026 - FL - clcmparchive.cbl - PDMI 2026 - PROJ-65383 [COBOL F6] CLCMP00MAS Archive -(TD-16327) - TBD

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

##  enter last batch needed for archive
BATCHRANGE="XL31Z999"


RETVAL=0
DATE=$(date +%Y%m%d)

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage:  clcmparchive.sh -a <batchrange>
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


# Submit  clcmparchive program
submit_clcmparchive()
{
     runcobol ${OBJ_DIR}/clcmparchive -a ${BATCHRANGE}
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

 CLCMP00MASA=${CLCMP00MAS}-ARCHIVE-${DATE}
# CLCMP00MASA=/home/flim/test/CLCMP00MAS-ARCHIVE-${DATE}
export  CLCMP00MASA

 CLCMP00MASO=${CLCMP00MAS}
# CLCMP00MASO=/home/flim/test/CLCMP00MAS
export  CLCMP00MASO


echo "ARCHIVE  CLCMP00MAS NEW FILE"

date

echo " CLCMP00MASA=${CLCMP00MASA}"
echo " CLCMP00MASO=${CLCMP00MASO}"
submit_clcmparchive

date

exit ${RETVAL}
