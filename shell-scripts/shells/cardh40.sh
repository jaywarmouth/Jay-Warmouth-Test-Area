#!/bin/ksh
#
# Program Name	: cardh40.sh
# Description	: Cardholder count by zip-codes.
#                 Command Line Arguments:
#                 -s select run type (pdm,lin,sys,spo,grp)
# Author	: Dave Tucci
# Date		: 12/06/96
# Modifications : 04/22/97 Changed how command line arguments are entered (LSJ)
#                 04/22/97 Added env_var & OBJ_DIR logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
RUN_TYPE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh40.sh -s [-pdm|lin|sys|spo|grp]

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
# Validate -s options
validate_run_type()
{  case ${RUN_TYPE} in
     "pdm" | "lin" | "sys" | "spo" | "grp")
                          ;;
     *)  usage
         ;;
   esac
}

# Submit cardh40 program
submit_cardh40()
{
   if [ ${RUN_TYPE} = "null" ]
   then
     usage
   else
     case ${RUN_TYPE} in
       "pdm")
          runcobol ${OBJ_DIR}/cardh40 -s 10000
          ;;
       "lin")
          runcobol ${OBJ_DIR}/cardh40 -s 01000
          ;;
       "sys")
          runcobol ${OBJ_DIR}/cardh40 -s 00100
          ;;
       "spo")
          runcobol ${OBJ_DIR}/cardh40 -s 00010
          ;;
       "grp")
          runcobol ${OBJ_DIR}/cardh40 -s 00001
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
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RUN_TYPE=$1
        validate_run_type
        ;;
  esac
  shift
done

# Parse environment variables
parse_env


# SWITCH 1 - pdm - ALL PDM ZIPS
# SWITCH 2 - lin - SYSTEM LINK
# SWITCH 3 - sys - SYSTEM NUMBER
# SWITCH 4 - spo - SPONSOR NUMBER
# SWITCH 5 - grp - GROUP NUMBER

date

# Submit the program
submit_cardh40

#rm -f /usr/pdm/ZIP4000MAS

date

exit 0
