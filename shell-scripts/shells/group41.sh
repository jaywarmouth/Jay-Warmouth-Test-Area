#!/bin/sh
#
# Program Name	:group41.sh 
# Description   : Reads GROUP00MAS and creates GRPLIFELIM text file for use in archive limit procedure.
#                 Command line arguments
#                 -t Test mode (no GROUP00MAS file rewrites)
#		  -o <GRPLIFELIM file name> - Optional, default location/name:
#			/usr/lnk/log/GRPLIFELIM-yyyymmdd.txt
# Author	: Linda S. Jefferis 
# Date		: 06/09/2017
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
TEST_MODE=0
RETVAL=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group41.sh -t -o <GRPLIFELIM file>
	Both command line arguments are optional:
	-o <GRPLIFELIM file name> - Optional, default location/name:
                       /usr/lnk/log/GRPLIFELIM-yyyymmdd.txt

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

	
# Submit group41 program
submit_group41()
{
      runcobol ${OBJ_DIR}/group41 -a ${TEST_MODE} 
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
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

if [ $FILE_FLAG = 1 ]
then
	GRPLIFELIM=$FILE
else
	GRPLIFELIM=/usr/lnk/log/GRPLIFELIM-${DATE}.txt
fi
export GRPLIFELIM

   echo "Create GRPLIFELIM text file"
   date
   echo "EXPORT PATHS:"
   echo "   GROUP00MAS=$GROUP00MAS"
   echo "   GRPLIFELIM=$GRPLIFELIM"
   submit_group41
   date

exit $RETVAL
