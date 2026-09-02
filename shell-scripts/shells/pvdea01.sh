#!/bin/ksh
#
# Description   : UPDATE PVDEA00MAS file.    
#                 Command line arguments:
# 		  -i <HMSDEAIN01 filename> 
# Author	: Joe Novicky
# Date		: 10/24/2013
# Modifications : 05/26/2015 - TT:2244-55 Input file argument 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
IN_FLAG=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pvdea01.sh 

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit pvsdea01 program
submit_pvdea01( )
{
     runcobol ${OBJ_DIR}/pvdea01 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        IN_FLAG=1
        IN_FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $IN_FLAG = 0 ]
then
	usage
else
	HMSDEAIN01=$IN_FILE
	export HMSDEAIN01	
fi

echo "Update PVDEA00MAS from HMSDEAIN01"         
date
echo "EXPORT PATHS:"
echo "   HMSDEAIN01=$HMSDEAIN01"
echo "   PVDEA00MAS=$PVDEA00MAS"
submit_pvdea01
date

exit 0
