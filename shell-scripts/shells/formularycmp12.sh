#!/bin/ksh
#
# to run: formularycmp12.sh -t -f D04FORM300TAP.base -n D14FORM300TAP.base -y 2012_medd
#
#         formularycmp12.sh -g -t -f D04FORM300TAP.eghp -n D14FORM300TAP.eghp -y 2012_medd
#
#         formularycmp12.sh -t -f I21FORM300TAP.base -n D04FORM300TAP.base -y 2012_medd
#
#         formularycmp12.sh -g -t -f I21FORM300TAP.eghp -n D04FORM300TAP.eghp -y 2012_medd
#
# Program Name	: formularycmp12.sh 
# Description   : Compare formulary files for 2 different months
#                 Command line arguments:
#		  -f <filename>  - path and filename of previous formulary file
#		  -n <filename>  - path and filename of new formulary file
#		  -t <test mode> - does not update OUTDAT file
#                 -g <sel run>   - g_off=base, g_on=eghp
#                 -y <year path> - portion of the file path that states the year
# Author	: Peggy Voytilla
# Date		: 04/07/2011
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
OLD_FILE="null"
NEW_FILE="null"
SEL_RUN=0
TEST_MODE=0
YR_PATH="9999_medd"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: formularycmp12.sh [-g] [-t] [-f <filename>] [-n <filename>] [-y <yearpath>]

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

	
# Submit formularycmp12 program
submit_formularycmp12()
{
   if [ ${SEL_RUN} = 1 ]
   then
      runcobol ${OBJ_DIR}/formularycmp12 -s ${TEST_MODE}${SEL_RUN} -a ${YR_PATH} 
   else
      runcobol ${OBJ_DIR}/formularycmp12 -s ${TEST_MODE}${SEL_RUN} -a ${YR_PATH}   
   fi
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
	if [ $# -le 0 ]
	then
	  usage
	fi
	OLD_FILE=$1
	;;
    -n) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	NEW_FILE=$1
	;;
    -g) SEL_RUN=1
	;;
    -t) TEST_MODE=1
        ;;
    -y) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        YR_PATH=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${OLD_FILE} = "null" ]
then
  usage
else
  OLDFORMIN=/usr/lnk/wrk/${YR_PATH}/${OLD_FILE}
  export OLDFORMIN
fi
if [ ${NEW_FILE} = "null" ]
then
  usage
else
  NEWFORMIN=/usr/lnk/wrk/${YR_PATH}/${NEW_FILE}
  export NEWFORMIN
fi

 IDXOLD=/usr/lnk/wrk/${YR_PATH}/FORMIDXOLD
 export IDXOLD

 IDXNEW=/usr/lnk/wrk/${YR_PATH}/FORMIDXNEW
 export IDXNEW


#Take out reference to OUTDAT0MAS when run for production
 OUTDAT0MAS=/usr/lnk/wrk/OUTDAT0PEG
 export OUTDAT0MAS

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   OLDFORMIN=/usr/lnk/wrk/$YR_PATH/$OLD_FILE"
echo "   NEWFORMIN=/usr/lnk/wrk/$YR_PATH/$NEW_FILE"

echo "   IDXOLD=/usr/lnk/wrk/$YR_PATH/FORMIDXOLD"
echo "   IDXNEW=/usr/lnk/wrk/$YR_PATH/FORMIDXNEW"

submit_formularycmp12
date


exit 0
