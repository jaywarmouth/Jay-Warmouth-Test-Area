#!/bin/ksh
#
# Program Name	: mv_cardmed.sh
# Description	: Archives the days card emboss files
#		: Command Line Arguments:
#		  -d <date suffix - mmddccyy>
# Author	: Linda S. Jefferis
# Date		: 11/01/2000
# Modifications : 12/03/2005 - Changes for new system names (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
CARD_DIR="/usr/lnk/cards"
ARCH_SYS="husk"
CARD_ARCH="/usr/lnk/cards/pla"
ZIP_PROG="/usr/bin/zip"
DATE_SUFFIX="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv_cardmed.sh -d <date suffix>

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
        DATE_SUFFIX=$1
        ;;
  esac
  shift
done


# Parse environment variables
#parse_env

if [ ${DATE_SUFFIX} = "null" ]
then
  usage
  exit 1
fi

cd ${CARD_DIR}
${ZIP_PROG} -m med_cards-${DATE_SUFFIX}.zip prmmed??.???
${ZIP_PROG} -m med_cards-${DATE_SUFFIX}.zip prmden??.???
scp med_cards-${DATE_SUFFIX}.zip ${ARCH_SYS}:${CARD_ARCH}
CMD_STATUS=$?
if [ ${CMD_STATUS} = 0 ]
then
   rm med_cards-${DATE_SUFFIX}.zip
else
   echo "-*> RCP of the file failed..."
fi

exit 0
