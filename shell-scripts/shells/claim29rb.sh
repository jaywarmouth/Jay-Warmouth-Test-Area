#!/bin/ksh
#
# Program Name	: claim29rb.sh
# Description   : CLAIM29MAS extract to warehouse.
#                 Command line arguments:
#           
# Author	: Mike Paulus
# Date		: 12/12/2008
# Modifications : 07/29/2010 - - Add logic for dated file, transfer to clientfiles area, and email to warehouse.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
ZIP_PROG="/bin/gzip"
TR_ERR=0
MAIL_PROG="/bin/mail"
MAIL_TO="warehouse@pdmi.com ljefferis@pdmi.com"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim29rb.sh 

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
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        ${ZIP_PROG} ${FNAME}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
        fi
else
        TR_ERR=1
        echo "${FNAME} does not exist"
fi
}

# Determine q/e date
set_date()
{
MONTH=`date +%m`
case $MONTH in
   "01" | "02" | "03")
        MON_NUM=01
        ;;
   "04" | "05" | "06")
        MON_NUM=04
        ;;
   "07" | "08" | "09")
        MON_NUM=07
        ;;
   "10" | "11" | "12")
        MON_NUM=10
        ;;
esac
FILE_DATE=`date -d "yesterday $(date +%Y)${MON_NUM}01" +%Y%m%d`
}

# Submit claim29rb program
submit_claim29rb()
{
     runcobol ${OBJ_DIR}/claim29rb  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
set_date
CLAIM29RB001=${CLAIM29RB001}-${FILE_DATE}
export CLAIM29RB001

echo "Extract of CLAIM29MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "    CLAIM29MAS=$CLAIM29MAS"
echo "    CLAIM29RB001=$CLAIM29RB001"
submit_claim29rb
date

REC_CNT=`wc -l ${CLAIM29RB001} | awk '{ print $1 }'`
FNAME=${CLAIM29RB001}
file_transfer

if [ $TR_ERR = 0 ]
then
        echo -e "The Quarterly CLAIM29RB001 file, with file date of ${FILE_DATE}, is available for updating.\n\nRecord Count = $REC_CNT" | ${MAIL_PROG} -s "Quarterly CLAIM29RB001" ${MAIL_TO}
fi


exit 0
