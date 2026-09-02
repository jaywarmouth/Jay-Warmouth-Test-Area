#!/bin/ksh
#
# Program Name	: riser_med.sh
# Description	: Moves file and reports on number of cards to be produced
#		  Command Line Arguments:
#		  -s alternate suffix
# Author	: Linda S. Jefferis
# Date		: 05/17/1999
# Modifications : 08/12/1999 - Added -s option and logic for day suffix 
#		: 10/18/1999 - LSJ - Added email of ${LOG}
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m/%d/%Y`
TOTAL=0
RISER_FILE="/home/ams/ams-tr/transfer/riser.txt"
NEW_FILE="/usr/pdm/MED-RF"
LOG=/tmp/card.log
SUFFIX=`date +%a`
MAIL_TO="ljefferis@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: medical_cards.sh 

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
# Log Heading
log_heading()
{
	echo "MEDICAL CARDS FOR AMERISCRIPT/RISER FOODS  "${DATE} > ${LOG}
	echo "------------------------------------------------------" >> ${LOG}
	echo "" >> ${LOG}
	echo "" >> ${LOG}
}
	

# Card Count
card_count()
{
	IFS=${CR}
	for RECORD in `cat ${RISER_FILE}`
	do
	  COUNT=`echo ${RECORD} | cut -c1`
	  let TOTAL=TOTAL+COUNT
	done
	echo "Number of cards:  "${TOTAL} >> ${LOG}
}

# Move file
mv_file()
{
	mv ${RISER_FILE} ${NEW_FILE}.${SUFFIX}
	echo "" >> ${LOG}
	ls -l ${NEW_FILE}.${SUFFIX} >> ${LOG}
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
	SUFFIX=$1
	;;
  esac
done

# Parse environment variables
#parse_env

log_heading

card_count

mv_file

lpp ${LOG}
echo ${LOG} | mail ${MAIL_TO}
#lpp ${NEW_FILE}

exit 0
