#!/bin/ksh
#
# Program Name	: cardh13.sh
# Description   : Cardh13 Eligibility 
#                 Command line arguments:
#                 -c Client Abbrev. (bas | gi)
#                 -d date of file (mmdd)
# Author	: Linda S. Jefferis
# Date		: 11/05/96
# Modifications : 07/28/97 - LSJ - Removed prm logic
#                 07/28/97 - LSJ - Added env_var & OBJ_DIR logic
#                 08/07/97 - LSJ - changes for GI filename
#                 05/07/98 - LSJ - Added PRT_DIR logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT=/usr/lnk/elig_in_1
FG4AUD_DIR="/usr/lnk/tmp"
PRT_DIR="/usr/lnk/po/misc"
CLIENT="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh13.sh [-c bas|gi] [-d <mmdd>]

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
# Validate -c options
validate_client()
{  case ${CLIENT} in
     "bas" | "gi")
			  ;;
     *)  usage
	 ;;
   esac
}

# Submit cardh13 program
submit_cardh13()
{
   if [ ${CLIENT} = "null" ]
   then
     usage
   else
     case ${CLIENT} in
       "bas")
          CARDH13TAP=${ELIG_DIR}/bas${DATE}
          FG4AUD=${FG4AUD_DIR}/BAS
          export CARDH13TAP FG4AUD
          runcobol ${OBJ_DIR}/cardh13
          mv ${ELIG_OUT}/bas${DATE} ${ELIG_OUT}/sys014/bas${DATE}
          rm -f ${CARDH13TAP}
          mv ${PRT_DIR}/PRINT-13 ${PRT_DIR}/PRINT-13-BAS
          lpp ${PRT_DIR}/PRINT-13-BAS
          ;;
       "gi")
          CARDH13TAP=/usr/pdm/elig_in/CARDH13GI
          FG4AUD=${FG4AUD_DIR}/GI
          export CARDH13TAP FG4AUD
          runcobol ${OBJ_DIR}/cardh13
          rm -f ${CARDH13TAP}
          rm -f ${ELIG_OUT}/gie${DATE}
          rm -f /home/ams/ams-tr/gie${DATE}.flt
          mv ${ELIG_OUT}/gie${DATE} ${ELIG_OUT}/sys002
          mv ${PRT_DIR}/PRINT-13 ${PRT_DIR}/PRINT-13-02
          lpp ${PRT_DIR}/PRINT-13-02
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLIENT=$1
        validate_client
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

echo Cardh13 Eligibility
date
submit_cardh13 
rm ${FG4AUD}
date

exit 0
