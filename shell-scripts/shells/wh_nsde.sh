#!/bin/sh
#
# Program Name	: wh_nsde.sh
# Description	: Create restack claims extract files for warehouse
#		  Command Line Arguments:
#		  -d <ccyymmdd> - Set alternate file date; default is yesterday date.
# Author	: Linda S. Jefferis
# Date		: 11/19/2014
# Modifications	: 3/31/2015 - TT #12829-43; DATECARD logic
#		: 01/10/2020 - change "s2ps" to "enscript"
#		: 01/31/2020 - TT:13915-86
#		
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
DATE=`date -d "yesterday 0800" +%Y%m%d`
OUT_DIR="misc"
SQL_DIR="/usr/lnk/wt/sqlimports"
MAIL_PROG="/usr/bin/mutt"
MAIL_OPER="operations@pdmi.com"
MAIL_WHSE="DEDMSupport@pdmi.onmicrosoft.com"
ZIP_PROG="/bin/gzip"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_nsde.sh -d <ccyymmdd>
	where <ccyymmdd> is optional. If not used, default is current date.

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


#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        mv ${FNAME} ${FNAME}-${DATE}
        gzip ${FNAME}-${DATE}
        mv ${FNAME}-${DATE}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${FNAME}"
        fi
else
        echo "${FNAME} does not exist"
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

date

parse_env

echo "--> Running nsderb01"
echo ""
${SHELL_DIR}/nsderb01.sh -b FULL > ${RPT_DIR}/nsde-nsderb01 2>&1
if test -s ${SQLIMPORTS}/${OUT_DIR}/NSDERB001
then
   REC_CNT=`wc -l ${SQLIMPORTS}/${OUT_DIR}/NSDERB001 | awk '{ print $1 }'`
   echo ${REC_CNT}","${DATE} > ${SQLIMPORTS}/${OUT_DIR}/NSDERB001-counts
   FNAME=${SQLIMPORTS}/${OUT_DIR}/NSDERB001-counts
   file_transfer
   FNAME=${SQLIMPORTS}/${OUT_DIR}/NSDERB001
   file_transfer
   echo "A NSDE file is available." | ${MAIL_PROG} -s "NSDE Process" -c ${MAIL_OPER} ${MAIL_WHSE}
fi

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/nsde-nsderb01 | ps2pdf - ${RPT_DIR}/nsde-nsderb01.pdf

echo "Output from wh_nsde.sh process" | ${MAIL_PROG} -a ${RPT_DIR}/nsde-nsderb01.pdf -s "NSDE File for Warehouse" ${MAIL_OPER}

date

exit 0
