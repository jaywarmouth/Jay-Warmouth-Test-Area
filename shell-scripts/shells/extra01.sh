#!/bin/ksh
#
# Program Name	: extra01.sh
# Description   : Create Sample/Test Environment    
#                 Command Line Arguments:
#                   -t Create Test Data Flag
#                   -g <32 Char.> Group range to process
# Author	: Debbie Wilson
# Date		: 08/05/99 
# Modifications : 04/04/2001 - Added logic for removing files  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
TEST_DATA=0
GROUP="null"
FILE_LIST="/usr/lnk/demo/EXTRA00MAS.SAMP"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: extra01.sh [-t] [-g <group range>] 

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

#
# Remove samp/test files
remove_files()
{
	echo
	echo "--> Removing sample/test files..."
	OIFS=$IFS
	IFS=${CR}
	for LINE in `cat ${FILE_LIST}`
	do
	   IFS=$OIFS
	   P2=`echo ${LINE} | awk '{print $2}'`
	   if test -a ${P2}
	   then
	      rm -f ${P2}
	      if test $? -ne 0
	      then
		echo "-*> There was an ERROR while removing ${P2}"
	      fi
	   else
	      echo
	      echo "--> ${P2} DOES NOT EXIST"
	      echo
	   fi
	   IFS=$CR
	done
	IFS=$OIFS
}

# Submit extra01 program
submit_extra01()
{
	echo
	echo "--> Starting the extra01 program..."
	echo "    CLAIM00MAS=${CLAIM00MAS}"
        echo ${DATE}
        runcobol ${OBJ_DIR}/extra01 -s ${TEST_DATA} -a ${GROUP}  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_DATA=1
	FILE_LIST="/usr/lnk/demo/EXTRA00MAS.TEST"
        ;;
    -g) shift                 
        if [ $# -le 0 ]
        then
          usage
        fi
        GROUP=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
CLAIM00MAS=/usr/clm_10/CLWRK00MAS.60530
export CLAIM00MAS

echo "Create Sample/Test Environment"
date

remove_files

submit_extra01

date

exit 0
