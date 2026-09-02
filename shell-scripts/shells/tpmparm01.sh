#!/bin/sh
#
# Description   : REFORMAT TPM MASTER FILE.        
#                 Command line arguments
#                 Switches:
#                 -t Test mode
# Author	: John Shrigley   
# Date		: 5/13/2016 
# Modifications :  
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILEDIR=/usr/lnk/tmp
FILE_FLAG=0
TEST_MODE=0
RETVAL=0
DATETM=`date +%Y%m%d_%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tpmparm01.sh [-t]

ENDOFUSAGE
  exit 1
}


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

	
# Submit verifyfl program
# To run shell in debug mode add D to end of runcobol statement below 
submit_tpmparm01()
{
      runcobol ${OBJ_DIR}/tpmparm01 -s ${TEST_MODE}
        RETVAL=$?  
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
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

TPM00MAS=/usr/lnk/grp/TPM00MAS-NEW
  export TPM00MAS
PARMFILE=/usr/lnk/wt/oper-wt/misc/TPA/hpsTPA.txt
  export PARMFILE
SPONSLIST=/usr/lnk/wt/oper-wt/misc/TPA/SponsorTPA.txt
  export SPONSLIST
TPM00CSV=/usr/lnk/wt/oper-wt/misc/TPA/TPM00CSV-${DATETM}.txt
  export TPM00CSV
####
   echo "REFORMAT TPM-MASTER FILE"                   
   date
   echo "EXPORT PATHS:"
   echo "   TPM00MAS=$TPM00MAS"
   echo "   SPONSLIST=$SPONSLIST"
   echo "   PARMFILE=$PARMFILE"
   echo "   TPM00CSV=$TPM00CSV"
   submit_tpmparm01   
   echo  "RET_CODE=$RETVAL "
   date

exit $RETVAL
