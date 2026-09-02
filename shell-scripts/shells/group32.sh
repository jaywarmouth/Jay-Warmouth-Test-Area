#!/bin/sh
#
# Program Name	: group32.sh 
# Description   : Create new GROUP STRUCTURES USING INPUT PARAMETERS
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no GROUP00MAS file rewrites)
#		  -i <input filename> - optional, default is:
#			/usr/lnk/wt/oper-wt/misc/GROUP32-PARMFILE.txt
# Author	: Lucy A. Caraballo 
# Date		: 8/12/2015
# Modifications : 8/20/2015 - Production version updates (TT:14121-1)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
TEST_MODE=0
DATETM=`date +%Y%m%d-%H%M`
OPSDIR=/usr/lnk/wt/oper-wt/misc

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group32.lc [-t]

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

	
# Submit group32 program
submit_group32()
{
	runcobol ${OBJ_DIR}/group32 -s ${TEST_MODE} 
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
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

FG4AUD=${GRPAUD}
  export FG4AUD
         
GROUP32CSV=${OPSDIR}/GROUP32CSV-${DATETM}.txt
   export GROUP32CSV

if [ ${FILE_FLAG} = 1 ]
then
	PARMFILE=$FILE
else
	PARMFILE=
fi
export PARMFILE


   echo "UPDATE GROUP00MAS FILE BASED OFF INPUT PARAMETERS"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   GROUP00MAS=$GROUP00MAS"
   echo "   PARMFILE=$PARMFILE"
   echo "   GROUP32CSV=$GROUP32CSV" 
   submit_group32
   date

exit 0
