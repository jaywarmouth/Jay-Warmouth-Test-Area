#!/bin/ksh
#
# Program Name  : drugcms02_08.sh  
# Description   : CMS Medicare PART D Pricing File Creation                
#               : 2008 version
#                 Command line arguments:
# Author        : Debbie Wilson    
# Date          : 04/04/07
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

usage: drugcms02_08.sh 

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


# Submit drugcms02 program   
submit_drugcms02()
{
      runcobol ${OBJ_DIR}/drugcms02_08
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
#DRUGWRKMAS=/usr/upd/drug/DRUGWRKMAS.cms

DRUGWRKMAS=/usr/lnk/wrk/2008_medd/DRUGWRKMAS.cms.2008
export DRUGWRKMAS

date
submit_drugcms02          
date

exit 0
