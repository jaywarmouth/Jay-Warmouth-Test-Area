#!/bin/ksh
#
# Program Name	: cardh21.sh
# Description   : cardh21 Eligibility 
#                 Command line arguments:
#                   -c Client Abbrev. (su)
#                   -d date of file (mmdd or mmdd.###)
#                   -f Full File flag
#                 Explaination of ELIG_TYPE:
#                   0 - Input is CARDH21 file (su)
#                 Index of Clients:
#                   su - SummaCare (sys35,sys45)
# Author	: Linda S. Jefferis
# Date		: 11/07/96
# Modifications : 12/26/96 Added subroutines - LSJ
#                 02/10/97 Fixed subroutines - LSJ
#                 02/26/97 Added Parse_env logic and OBJ_DIR logic - LSJ
#                 04/14/97 Removed group05 logic - LSJ
#                 05/21/97 Changed Butler to sys06 - LSJ
#                 05/21/97 Changed Summa to elig. type 0 - LSJ
#                 05/22/97 Added prm as elig. type 1 - LSJ
#                 06/10/97 Took out prm logic - LSJ
#                 05/07/98 Added PRT_DIR logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT=/usr/lnk/elig_in_1
FG4AUD_DIR="/usr/lnk/tmp"
CARDH21_DIR="/usr/lnk/tmp"
CAWRK_DIR="/usr/lnk/tmp"
PRT_DIR="/usr/lnk/po/misc"
DATE="null"
CLIENT="null"
FULL_FILE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh21.sh [-c su] [-d <mmdd> or <mmdd.###>] [-f]

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
     "su")
			  ;;
     *)  usage
	 ;;
   esac
}

#
# Set variables
#
set_variables()
{
   if [ ${CLIENT} = "null" ]
   then
     usage
   else
     case ${CLIENT} in
       "su")
          FNAME_1="SUM"
          SYS="35"
          RPT_NAME="35"
          ;;
     esac
   fi 
}

#
# Set elig type
#
get_elig_type()
{
  case ${CLIENT} in
    "su")
       ELIG_TYPE=0
       ;;
  esac
}

#
# Submit cardh21 program
submit_cardh21()
{
  if [ ${DATE} = "null" ]
  then
    echo "DATE="${DATE}
    usage
  else
     case ${ELIG_TYPE} in
       "0")
          if test -s ${ELIG_DIR}/${CLIENT}e${DATE}
          then
            if test -s ${CARDH21_DIR}/CARDH21${FNAME_1}
            then
              CARDH21TAP=${CARDH21_DIR}/CARDH21${FNAME_1}
      	      FG4AUD=${FG4AUD_DIR}/${FNAME_1}
              export CARDH21TAP FG4AUD
      	      runcobol ${OBJ_DIR}/cardh21
	      rm -f ${CARDH21TAP}
              rm -f ${FG4AUD}
              mv ${ELIG_OUT}/${CLIENT}e${DATE} ${ELIG_OUT}/sys0${SYS}
	      lpp ${PRT_DIR}/PRINT-21-${RPT_NAME}
            else
              echo
              echo "###MESSAGE###"
              echo "${CARDH21_DIR}/CARDH21${FNAME_1} is zero or doesn't exist"
              echo "Fix it and rerun cardh21 script"
              exit 1
            fi
          else
            mv ${ELIG_OUT}/${CLIENT}e${DATE} ${ELIG_OUT}/sys0${SYS}
          fi
          if [ ${CLIENT} = "su" ]
          then
            mv ${ELIG_OUT}/${CLIENT}g${DATE} ${ELIG_OUT}/sys0${SYS}
            rm -f ${ELIG_DIR}/${CLIENT}e${DATE}
            rm -f ${ELIG_DIR}/${CLIENT}g${DATE}
            rm -f ${ELIG_DIR}/scel${DATE}.zip
            rm -f ${ELIG_DIR}/scgp${DATE}.zip
          fi
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
    -f) FULL_FILE=1 
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Set Internal Variables
set_variables

# Get the Elig. Type
get_elig_type

# Submit Cardh21
submit_cardh21 

exit 0
