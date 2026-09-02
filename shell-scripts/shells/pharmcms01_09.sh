#!/bin/ksh
#
# Program Name  : pharmcms01_09.sh  
# Description   : CMS Medicare PART D Pharmacy Cost File Creation          
#               : 2009 version
#                 Command line arguments:
# Author        : Debbie Wilson    
# Date          : 07/09/08
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/tst
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pharmcms01_09.sh 

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


# Submit pharmcms01 program   
submit_pharmcms01()
{
      runcobol ${OBJ_DIR}/pharmcms01_09 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

DRUGWRKMAS=/usr/lnk/wrk/2009_medd/DRUGWRKMAS.cms.2009
export DRUGWRKMAS

date
submit_pharmcms01         
date

exit 0
