#!/bin/sh
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
SAMP_FLAG=0
DATE=`date +%Y%m%d`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pullgrp31pdm.sh 

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


# Submit program
submit_prog()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/pullgrp31prm   

}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables

PARMFILE=/usr/lnk/wt/oper-wt/PARMFILE-GRP31-${DATE}.txt
   export PARMFILE  
EXTRACTTST=/usr/lnk/wt/oper-wt/EXTRACTTST-${DATE}.csv
   export EXTRACTTST

echo "EXPORT PATHS:"
echo "   PARMFILE=$PARMFILE "        
echo "   EXTRACTTST=$EXTRACTTST "        

echo "Group Extract for SITE conversion"
date
submit_prog
date

exit 0
