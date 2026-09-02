#!/bin/ksh
#
# Program Name	: compu09.sh 
# Description	: Launches COBOL runtime according to input parameters
# Author	: Anthony DePinto
# Date		: 4-18-96
# Modifications : 6-27-96 LSJ  Added -s option for days status figures
#                 04/23/97 LSJ Added env_var & OBJ_DIR logic
#                 04/23/97 LSJ Removed proc_audit logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
DATE=`date +%m%d`
PAGER=0
STATUS=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: compu09.sh {-p} | {-s}             

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
# Submit compu09 runtime
submit_compu09()
{  
   if [ ${PAGER} = 1 ]
   then
#     exec runcompu09 ${OBJ_DIR}/compu09 -s 01
     runcobol ${OBJ_DIR}/compu09 -s 01
   elif [ ${STATUS} = 1 ]
   then
#     exec runcompu09 ${OBJ_DIR}/compu09 -s 0001
      runcobol ${OBJ_DIR}/compu09 -s 0001
   else
#     exec runcompu09 ${OBJ_DIR}/compu09 -s 0
      runcobol ${OBJ_DIR}/compu09 -s 0
   fi
}

# Trap brak signal for audit trail
trap_break()
{
  exit 0
}

#
# Main routine
#
trap "trap_break" 2

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) PAGER=1 
	;;
    -s) STATUS=1 
	;;
    *) usage
       ;;
  esac
  shift
done

# Parse environment variables
parse_env

submit_compu09

exit 0
