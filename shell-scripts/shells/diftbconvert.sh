#!/bin/sh
#
# Program Name	: DIFTBCONVERT.CBL
# Description   : Convert DIFTB00MAS 
#                 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: diftbconvert.sh 

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


# Submit diftbconvert program
submit_diftbconvert()
{

     runcobol ${OBJ_DIR}/DIFTBCONVERT
	RETVAL=$?

}


# Main routine#

# Check command line validity, call usage if incorrect

 
# Parse environment variables
parse_env

# Assign alternate environment variables
  
DIFTB00MASN=${DIFTB00MAS}-NEW
  export DIFTB00MASN

DIFTB00MASO=${DIFTB00MAS}               
  export DIFTB00MASO

MSGFILE=/tmp/MSGFILE-DIFTB-${DATETM}.txt
export MSGFILE


echo "LOAD DIFTB00MAS NEW FILE"

date
echo "DIFTB00MASO=${DIFTB00MASO}"
echo "DIFTB00MASN=${DIFTB00MASN}"
echo "MSGFILE=${MSGFILE}"

submit_diftbconvert
echo "RET_CODE=$RETVAL"

date

exit ${RETVAL}
