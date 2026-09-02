#!/bin/ksh
#
# Program Name  : phdem01.sh
# Description   : Drug Type 25,32,33,34 Update
# Author        : Debbie Wilson   
# Date          : 08/20/98
# Modifications : 08/22/2006 - Added HOSTNAME logic  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug006.sh  

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


# Submit drug006 program
submit_drug006()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drug006  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
DRUGWRKMAS=/usr/lnk/drug/DRWRK00MAS.dps           
export DRUGWRKMAS 

echo "DRUG006"
echo "HOSTNAME=$HOSTNAME"
date
submit_drug006
date

exit 0
