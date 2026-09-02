#!/bin/ksh
#
# Program Name  : pdbat01_weekcycle.sh
# Description   : Upload Batches To PDBAT00MAS
#                 COmmand line arguements:
#                 -c Type of Cycle (pay, twice, week, tweek)
# Author        : Jim Masluk
# Date          : 09/01/2000
# Modifications : 05/05/2005 - Changes for new week-cycle  (LSJ)
#		: 11/02/2010 - Changes for new tweek cycle  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
CYCLE="null"
OFF=0
PAY=0
TWICE=0
WEEK=0
TWEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdbat01.sh [-c pay|twice|week|tweek]

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

# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "pay")
        PAY=1
        ;;
     "twice")
        TWICE=1
        ;;
     "week")
        WEEK=1
        ;;
     "tweek")
        TWEEK=1
        ;;
    *)  usage
         ;;

   esac
}


# Submit pdbat01 program
submit_pdbat01()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
        runcobol ${OBJ_DIR}/pdbat01 -s ${OFF}${PAY}${TWICE}${WEEK}${TWEEK}
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;

  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "PDBAT00MAS=$PDBAT00MAS"
echo "SYSTE00MAS=$SYSTE00MAS"

date
submit_pdbat01
date

exit 0
