#!/bin/ksh
#
# Program Name	: cardh06.sh
# Description   : Paper Card Production 
#                 Command line arguments:
#                 -t Type of run (normal or select)
#                    select - produce cards for select cardholders
#                 -u Turns off update of EMBOS00MAS
# Author	: Linda S. Jefferis
# Date		: 09/24/96
# Modifications : 
#                 01/23/97 - CMS - TOOK OUT EXPORT OF COPAY00MAS=/usr/pdm/claims/COPAY00NEW
#                 05/07/97 - LSJ - Added env_var & OBJ_DIR logic
#		  11/24/98 - LSJ - Assigning FG4AUD to EMBAUD
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TYPE_RUN="null"
SELECT=0
UPDATE=0
PLA_DIR=/usr/lnk/cards
CARD_DIR=/usr/lnk/crd_01
CARD_BAK=/usr/upd/crd_01

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh06.sh [-t normal|select] [-u] 

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
# Validate -t options
validate_run()
{  case ${TYPE_RUN} in
     "normal" | "select")
			  ;;
     *)  usage
	 ;;
   esac
}

# Submit cardh06 program
submit_cardh06()
{
   if [ ${TYPE_RUN} = "null" ]
   then
     usage
   else
     case ${TYPE_RUN} in
       "normal")
          rm ${PLA_DIR}/PLA-*
          cp ${CARD_DIR}/CARDH06MAS ${CARD_BAK}/CARDH06MAS.bak
          if [ ${UPDATE} = 0 ]
          then
            runcobol ${OBJ_DIR}/cardh06 -s 01
          else
            runcobol ${OBJ_DIR}/cardh06 -s 00
          fi
          ;;
       "select")
          if [ ${UPDATE} = 0 ]
          then
            runcobol ${OBJ_DIR}/cardh06 -s 11
          else
            runcobol ${OBJ_DIR}/cardh06 -s 10
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
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        TYPE_RUN=$1
        validate_run
        ;;
    -u) UPDATE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate variables
FG4AUD=/usr/lnk/audit/EMBAUD
export FG4AUD

cd /usr/lnk/cards
echo Paper Card Production
date
echo "EXPORT PATHS:"
echo "   CARDH06MAS=$CARDH06MAS"
submit_cardh06 
date

exit 0
