#!/bin/sh
#
# Program Name	: gdrsconvert.sh
# Description   : Convert GDRSDB0MAS 
#                
# Date		: 12/07/2017
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

usage: gdrsconvert.sh 

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


# Submit gdrsconvert program
submit_gdrsconvert()
{
      runcobol ${OBJ_DIR}/gdrsconvert  
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

GDRSD00MASO=${GDRSD00MAS}
  export GDRSD00MASO 
GDRSD00MASN=${GDRSD00MAS}-NEW
  export GDRSD00MASN
GDRSDERR=/tmp/GDRSDERR    
  export GDRSDERR
echo "Convert GDRSD00MAS"
date
echo "GDRSD00MASO=${GDRSD00MASO}"
echo "GDRSD00MASN=${GDRSD00MASN}"
echo "GDRSDERR=${GDRSDERR}"
submit_gdrsconvert
echo  "   RET_CODE=$RETVAL "

date

exit $RETVAL
