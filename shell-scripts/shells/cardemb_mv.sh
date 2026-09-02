#!/bin/ksh
#
# Program Name	: cardemb_mv.sh
#		  Command Line Arguments:
#		  -t <emb|pla|prm>
#		  -d alternate date/suffix for zip name (4-chars.)
# Description	: Archives printed card emboss files (PLA-*, *.EMB, Prmmed*)
# Author	: Linda S. Jefferis
# Date		: 11/17/1999
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
EMB_FILES="*.EMB"
PLA_FILES="PLA-*"
PRMMED_FILES="Prmmed*"
CARD_DIR="/usr/lnk/card"
DATE=`date +%m%d`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardemb_mv.sh [-t <emb|pla|prm>] [-d <4-chars.>]

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
# Validate type
validate_type()
{
	case ${TYPE} in
	  "emb" | "pla" | "prm")
	     	;;
	  *) usage
		;;
	esac
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
	TYPE=$1
	validate_type
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
#parse_env

case ${TYPE} in
  "emb")
	mv ${EMB_FILES} ${CARD_DIR}
	pkzip -m cards-${DATE}.zip ${EMB_FILES}
	;;
  "pla")
	mv ${PLA_FILES} ${CARD_DIR}
	pkzip -m cards-${DATE}.zip ${PLA_FILES}
	;;
  "prm")
	mv ${PRMMED_FILES} ${CARD_DIR}
	pkzip -m cards-${DATE}.zip ${PRMMED_FILES}
	;;
esac

exit 0
