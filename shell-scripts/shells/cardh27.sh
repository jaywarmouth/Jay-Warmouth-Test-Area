#!/bin/ksh
#
# Program Name	: cardh27.sh
# Description   : Plastic Card Production 
#                 Command line arguments:
#                 -t Type of run (normal or select)
#                    select - produce cards for select cardholders
#                 -u Turns off update of EMBOS00MAS
# Author	: Linda S. Jefferis
# Date		: 08/23/96
# Modifications : 
#                 01/23/97 - CMS - TOOK OUT EXPORT OF COPAY00MAS=/usr/pdm/claims/COPAY00NEW
#                 05/07/97 - LSJ - Added env_var & OBJ_DIR logic
#                 05/07/97 - LSJ - Removed proc_audit
#		  11/24/98 - LSJ - Assigned FG4AUD to EMBAUD
#		  11/03/2004 - LSJ - Added rm *.TXT
#		  07/20/2006 - LSJ - Removed "rm *.TXT"
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
EMB_DIR=/usr/lnk/cards
CARD_DIR=/usr/lnk/crd_01
CARD_BAK=/usr/upd/crd_01

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh27.sh [-t normal|select] [-u] 

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
validate_run()
{  case ${TYPE_RUN} in
     "normal" | "select")
			  ;;
     *)  usage
	 ;;
   esac
}

# Submit cardh27 program
submit_cardh27()
{
   if [ ${TYPE_RUN} = "null" ]
   then
     usage
   else
     case ${TYPE_RUN} in
       "normal")
          rm ${EMB_DIR}/*.EMB
          #rm ${EMB_DIR}/*.TXT
          cp ${CARD_DIR}/CARDH06MAS ${CARD_BAK}/CARDH06MAS.bak27
          if [ ${UPDATE} = 0 ]
          then
            runcobol ${OBJ_DIR}/cardh27 -s 01
          else
            runcobol ${OBJ_DIR}/cardh27 -s 00
          fi
          ;;
       "select")
          if [ ${UPDATE} = 0 ]
          then
            runcobol ${OBJ_DIR}/cardh27 -s 11
          else
            runcobol ${OBJ_DIR}/cardh27 -s 10
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
echo Plastic Card Production
date
echo "EXPORT PATHS:"
echo "   CARDH06MAS=$CARDH06MAS"
submit_cardh27 
date

exit 0
