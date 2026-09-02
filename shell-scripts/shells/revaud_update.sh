#!/bin/ksh
#
# Program Name	: revaud_update.sh
# Description	: Updates NON-Y2K REVAUD file to Y2K REVER00MAS.
#                 Command line arguments:
#                 -d Date of audit file (mmddyy) - Required
#                 -p Audit path to read from - Required (e.g. /usr/ncr3550/audit)
#                 -u Assign alternate update switches (#######) - Optional
#                    If this option is not used it assumes 01000000 where:
#                    SWITCH 1 - OVERIDE
#                    SWITCH 2 - REVERSAL
#                    SWITCH 3 - EXCEPTION
#                    SWITCH 4 - CLAIM
#                    SWITCH 5 - LIMIT
#                    SWITCH 6 - CLAIM80
#                    SWITCH 7 - FULL UPDATE
#                    SWITCH 8 - CARDI
# Author	: Linda Jefferis
# Date		: 04/01/99
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
AUDIT_PATH="none"
DATE="none"
SW="01000000"
FNAME="REVAUD."

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: revaud_update.sh -d [mmddyy] -p [<path>] -u [#######]

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


# Check Required options
check_options()
{
   if [ ${DATE} = "none" ]
     then
       usage
   fi
   if [ ${AUDIT_PATH} = "none" ]
     then
       usage
   fi
}
   
#
# Submit claim96
submit_claim96()
{
        AUDIT20MAS=${AUDIT_PATH}/${FNAME}${DATE}
        export AUDIT20MAS
	#runcobol ${OBJ_DIR}/claim96 -s ${SW}
	runcobol ${OBJ_DIR}/convrev01
}
   
#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        AUDIT_PATH=$1
        ;;
    -u) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SW=$1
        ;;
  esac
  shift
done

# Check required options
check_options

# Parse environment variables
parse_env

# Submit the program
submit_claim96

exit 0
