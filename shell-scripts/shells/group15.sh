#!/bin/ksh
#
# Program Name  : group15.sh
# Description   : Find duplicate alt group numbers within same sys & spo
#		  Command Line Arguments:
#		  -u (URX, AMS, S85) - Sets switch to check AMS, S85, or URX for duplicates against all systems
# Author        : D. Tucci
# Date          : 09/06/99
# Modifications : 08/31/01 - Added switch to check all systems (JM).
#               : 11/05/03 - Added option of AMS or URX to all systems switch (KR).
#		: 02/24/2006 - Added umask command temporarily  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
ALL_SYSTEMS=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group15.sh [-u AMS|URX|S85] 

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

#
# Validate -u options
validate_all_systems()
{  case ${ALL_SYSTEMS} in
     "URX" | "AMS" | "S85")
         ;;
     *)  usage
         ;;
   esac
}


# Submit group15 program
submit_group15()
{
    echo ${DATE}
    case ${ALL_SYSTEMS} in
      "0")
      	runcobol ${OBJ_DIR}/group15 -s 0000       
	;;
      "URX")
        runcobol ${OBJ_DIR}/group15 -s 1100      
        ;; 
      "AMS")
        runcobol ${OBJ_DIR}/group15 -s 1010     
        ;;
      "S85")
        runcobol ${OBJ_DIR}/group15 -s 1001     
        ;;
    esac
    lp /usr/lnk/po/misc/PRINT-GROUP15
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -u) shift
        if [ $# -le 0 ]
        then
          usage
        fi  
        ALL_SYSTEMS=$1
        validate_all_systems
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

umask 000

date

submit_group15
date


exit 0
