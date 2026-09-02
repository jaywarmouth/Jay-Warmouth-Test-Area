#!/bin/ksh
#
# Program Name	: pharm02.sh
# Description   : Update National Network
# Author	: Kim Konyshak
# Date		: 09/11/96
# Modifications :
#
#                 01/23/97 - CMS - TOOK OUT EXPORT OF COPAY00MAS=/usr/pdm/claims/COPAY00NEW
#                 06/19/97 - LSJ - Added env_var & OBJ_DIR logic
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pharm02.sh [-o pharm|phtab|netwk|dispf]

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
# Validate -o options
validate_skip()
{  case ${SKIP} in
     "pharm" | "phtab" | "netwk" | "dispf" )
                                           ;;
     *)  usage
         ;;
   esac
}

# Submit pharm02 program
submit_pharm02()
{
   if [ ${SKIP} = "null" ]
   then
        runcobol ${OBJ_DIR}/pharm02 -s 0000
   else
     case ${SKIP} in
       "pharm")
        runcobol ${OBJ_DIR}/pharm02 -s 0111
          ;;
       "phtab")
        runcobol ${OBJ_DIR}/pharm02 -s 1011
          ;;
       "netwk")
        runcobol ${OBJ_DIR}/pharm02 -s 1101
          ;;
       "dispf")
        runcobol ${OBJ_DIR}/pharm02 -s 1110
          ;;
     esac
   fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SKIP=$1
        validate_skip
        ;;
  esac
  shift
done

# Parse environment variables
parse_env


echo Update National Network
date
echo "EXPORT PATHS:"
echo "   DISPE00MAS=$DISPE00MAS"
submit_pharm02 
date

exit 0
