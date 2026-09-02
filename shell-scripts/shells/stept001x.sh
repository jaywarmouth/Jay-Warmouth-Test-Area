#!/bin/ksh
#
# Program Name	: stept001x.sh 
# Description   : Update STEPT00MAS based on input STEPTPTM file
#                 Command line arguments:
#                 -i <filename> - assign alternate input parmfile
#                 
# Author	: Debbe Adgate 
# Date		: 07/12/2016
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
DATETM=`date +%Y%m%d%H%M%S`
RETVAL=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: stept001.sh

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

	
# Submit stepcpy program
submit_stept001()
{
      runcobol ${OBJ_DIR}/stept001x              
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
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
        STEPTPRM=$FILE
else
        STEPTPRM=/usr/lnk/wt/oper-wt/PARMFILE-STEPTPRM.txt
fi
export STEPTPRM

FG4AUD=$FG4AUD
  export FG4AUD

STEPTCHGCSV=/usr/lnk/wt/oper-wt/STEPTCHGCSV-${DATETM}.txt
  export STEPTCHGCSV

echo "Update STEPT00MAS"
date
echo "EXPORT PATHS:"
echo "   STEPT00MAS=$STEPT00MAS"
echo "   STEPTPRM=$STEPTPRM"
echo "   FG4AUD=$FG4AUD"
echo "   STEPTCHGCSV=$STEPTCHGCSV"

submit_stept001
echo "RETVAL=$RETVAL"
date


exit $RETVAL
