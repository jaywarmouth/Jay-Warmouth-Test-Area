#!/bin/ksh
#
# Program Name	: audit04.sh
# Description	: 
# Author	: Linda S. Jefferis
# Date		: 06/19/97
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SW=0
DATE=`date +%y%m%d`
MAXVALUE=30

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: audit04.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables


i=1
while [ $i -le ${MAXVALUE} ]
do
  if [ ${SW} = 1 ]
  then
     runcobol ${OBJ_DIR}/audit04 -s 1
  else
     runcobol ${OBJ_DIR}/audit04 -s 0
  fi
  cp /usr/pdm/AUDIT00CUR AUDIT00CUR_$i
  cp /usr/pdm/AUDIT00CTL-${DATE} AUDIT00CTL-${DATE}_$i
  let i=i+1
  sleep 300
done


exit 0
