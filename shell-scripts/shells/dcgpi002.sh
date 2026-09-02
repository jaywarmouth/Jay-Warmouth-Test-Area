#!/bin/ksh
#
# Program Name  : dcgpi002.sh **** INACTIVE ****
# Description   : Redbrick DCGPI File Extract
#		  Command Line Arguments:
# Author        : Kathy Ritzler
# Date          : 07/23/03
# Modifications : 07/29/2010 - Add logic for dated file, transfer to clientfiles area, and email to warehouse.
#		: 01/31/2020 - TT:13915-86
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
ZIP_PROG="/bin/gzip"
TR_ERR=0
MAIL_PROG="/bin/mail"
MAIL_TO="datasupport@pdmi.com ljefferis@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dcgpi002.sh 

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


# Submit dcgpi002 program
submit_dcgpi002()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/dcgpi002 

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


#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
set_date
DCGPIRB001=${DCGPIRB001}-${FILE_DATE}
export DCGPIRB001

date
echo "DCGPI Extract for Redbrick"
echo ""
echo "EXPORT FILES:"
echo "   DCGPI=${DCGPI}"
echo "   DCGPIRB001=${DCGPIRB001}"
echo ""
submit_dcgpi002
date

REC_CNT=`wc -l ${DCGPIRB001} | awk '{ print $1 }'`
FNAME=${DCGPIRB001}
file_transfer

if [ $TR_ERR = 0 ]
then
        echo -e "The Quarterly Dosecheck file, with file date of ${FILE_DATE}, is available for updating.\n\nRecord Count = $REC_CNT" | ${MAIL_PROG} -s "Quarterly Dosecheck" ${MAIL_TO}
fi

exit 0
