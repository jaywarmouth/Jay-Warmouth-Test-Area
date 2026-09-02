#!/bin/ksh
#
# Program Name  : dea001rb.sh 
# Description   : UPDATE DEA MASTER FILE TO REDBRICK
#                 Command Line Arguments:
#                 -o <filename> - Assign alternate output file name
#			Default is DEA-<q/e - ccyymmdd>
# Author        : Jim Masluk
# Date          : 02/13/2001
# Modifications : 07/02/2010 - Add logic for dated file, transfer to clientfiles area, and email to warehouse.
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
FILE_FLG=0
FILE_DIR="/usr/lnk/sqlimports/misc"
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

usage: dea001rb.sh [-o <filename>]

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


# Submit dea001rb program
submit_dea001rb()
{
        runcobol ${OBJ_DIR}/dea001rb 

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
while [ $# -gt 0 ]
do
   case "$1"
   in
      -o) shift
          if [ $# -le 0 ]
          then
             usage
          fi
	  FILE_FLG=1
          OUTPUT_FILE=$1
          ;;
   esac
   shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLG} = 1 ]
then
   DEA00RB001=${OUTPUT_FILE}
else
   set_date
   DEA00RB001=${FILE_DIR}/dea-${FILE_DATE}
fi
export DEA00RB001

echo "DEA FILE UPDATE"
echo ""
echo "EXPORT FILES:"
echo "   DEA000MAS=${DEA000MAS}"
echo "   DEA00RB001=${DEA00RB001}"
echo ""

date
submit_dea001rb  
date

REC_CNT=`wc -l ${DEA00RB001} | awk '{ print $1 }'`
FNAME=${DEA00RB001}
file_transfer

if [ $TR_ERR = 0 ]
then
        echo -e "The Quarterly DEA file, with file date of ${FILE_DATE}, is available for updating.\n\nRecord Count = $REC_CNT" | ${MAIL_PROG} -s "Quarterly DEA" ${MAIL_TO}
fi

exit 0
