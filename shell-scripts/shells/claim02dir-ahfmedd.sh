#!/bin/ksh
#
# Program Name	: claim02dir-ahfmedd.sh
# Description	: Claims Entry
#                 Command line arguments:
#                 -s Switches <########>
#                 -a System # <####>
#                 -n NABP # <usually 000000 or 999999>
#                 -p Processor Batch Key <A-Z>
#                 -c User class <A,B,C,D>
#                 -u Username
#		  -z Demo run
# Author	: Linda S. Jefferis
# Date		: 09/26/2016
# Modifications : 
#		: Version of claim02dir with special CLLOC00MAS assigned file.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SW="00000000"
SYS="null"
NABP="null"
PROC="null"
USER="null"
USERCLASS="null"
DEMO=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim02dir-ahfmedd.sh [-s <######>] [-a <sys#>] [-n <napb#>] [-p <processor letter>] [-c <userclass>] [-u <username>] [-z]

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
# Validate -c options
validate_userclass()
{  case ${USERCLASS} in
     "A" | "B" | "C" | "D" )
                          ;;
     *)  usage
         ;;
   esac
}


# Submit claim02dir program
submit_claim02dir()
{
   umask 111
   if [ ${SYS} = "null" -o ${NABP} = "null" -o ${PROC} = "null" -o ${USERCLASS} = "null" -o ${USER} = "null" ]
   then
     usage
   else
       runcobol ${OBJ_DIR}/claim02dir -s ${SW} -a ${SYS}${NABP}${PROC}${USERCLASS}${USER}'           '
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
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SW=$1
        ;;
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS=$1
        ;;
    -n) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        NABP=$1
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PROC=$1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USERCLASS=$1
        validate_userclass
        ;;
    -u) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USER=$1
        ;;
    -z) DEMO=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign Alternate variables
if [ ${DEMO} = 1 ]
then
   ENV_FILE=/usr/lnk/demo/env_var.demo
   parse_env
fi

CLLOC00MAS=/usr/lnk/claims/CLLOC-AHFMEDD
export CLLOC00MAS

# submit claim02dir
submit_claim02dir

exit 0
