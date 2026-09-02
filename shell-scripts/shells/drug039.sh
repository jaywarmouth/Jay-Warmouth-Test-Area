#!/bin/ksh
#
# Program Name	: drug039.sh
# Description   : Drug Update of Type Code 50's GPI's
# Author	: Dave Tucci
# Date		: 03/09/2000
# Modifications : 08/22/2006 - Added HOSTNAME logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug039.sh 

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

# Submit drug039 program
submit_drug039()
{
   runcobol ${OBJ_DIR}/drug039
}


#
# Main routine
#

# Parse environment variables
parse_env

echo "Drug Update by GPI for Michigan Formulary (tc50)"
echo "HOSTNAME=$HOSTNAME"
date
submit_drug039   
date

exit 0
