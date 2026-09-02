#!/bin/ksh
#
# Program Name	: audit_zip_sat.sh
# Description   : zips previous day's AUDIT file and compresses all *AUD files
# Author	: Linda S. Jefferis
# Date		: 03/29/96
#
# Variables Used:
#DATE=`/usr/local/bin/yesterday`
DATE=`date +%y%m%d`
DATE2=`date +%m%d%y`
#TODAY=`date +%y%m%d`
TODAY=`date +%Y%m%d`
PROD_DIR="/usr/lnk/audit/backup"
BACKUP_1="prod11"
BACKUP_2="husk"
BACKUP_3="robin"
BACKUP_4="prod20"
BACKUP_5="prodtest10"
BACKUP_DIR=/usr/lnk/audit
FNAME[0]="AUDIT-400-"
FNAME[1]="AUDIT-401-"
FNAME[2]="AUDIT-300-"
FNAME[3]="AUDIT-301-"
FNAME[4]="AUDIT-200-"
FNAME[5]="AUDIT-201-"
FNAME[6]="DMR-"
MAXVALUE_1=6
AUD[1]="FG4AUD"
AUD[2]="GRPAUD"
AUD[3]="LIMAUD"
AUD[4]="PHAAUD"
AUD[5]="EMBAUD"
AUD[6]="REVAUD"
AUD[7]="CHKAUD"
AUD[8]="CRDAUD"
AUD[9]="CRDAUD-RT"
AUD[10]="CRDAUD-FG"
AUD[11]="PDEAUD"
AUD[12]="CLAIM02"
MAXVALUE_2=12
ZIP_PROG=/bin/gzip

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage:  audit_zip_sat.sh

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

if ! test -a ${PROD_DIR}/DMR-${TODAY}
then
   touch ${PROD_DIR}/DMR-${TODAY}
   chmod 666 ${PROD_DIR}/DMR-${TODAY}
fi

echo ""
echo "--> Doing scp and zip of AUDIT files"
i=0
while [ $i -le ${MAXVALUE_1} ]
do
   if test -a ${PROD_DIR}/${FNAME[i]}${DATE}
   then
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_1}:${BACKUP_DIR}/${FNAME[i]}${DATE}.cmp
      if test $? -ne 0
      then
   	echo ""
	echo "-*> scp of ${FNAME[i]}${DATE} to ${BACKUP_1} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_2}:${BACKUP_DIR}/${FNAME[i]}${DATE}.cmp
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${FNAME[i]}${DATE} to ${BACKUP_2} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_3}:${BACKUP_DIR}/${FNAME[i]}${DATE}.cmp
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${FNAME[i]}${DATE} to ${BACKUP_3} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_4}:${BACKUP_DIR}/${FNAME[i]}${DATE}.cmp
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${FNAME[i]}${DATE} to ${BACKUP_4} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_5}:${BACKUP_DIR}/${FNAME[i]}${DATE}.cmp
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${FNAME[i]}${DATE} to ${BACKUP_5} was unsuccessful"
      fi
      ${ZIP_PROG} ${PROD_DIR}/${FNAME[i]}${DATE}
   else
      echo ""
      echo "-*> ${PROD_DIR}/${FNAME[i]}${DATE} does not exist"
   fi
   let i=i+1
done

echo ""
echo "--> Compressing ???AUD files"
i=1
while [ $i -le ${MAXVALUE_2} ]
do
   if test -s ${PROD_DIR}/${AUD[i]}.${DATE2}
   then
   	${ZIP_PROG} ${PROD_DIR}/${AUD[i]}.${DATE2}
   	if test $? -ne 0
   	then
		echo ""
		echo "   -*> compress of ${AUD[i]}.${DATE2} was unsuccessful"
   	fi
   else
	echo ""
	echo "   -*> ${AUD[i]}.${DATE2} size is zero or doesn't exist"
   fi
   let i=i+1
done

echo ""
echo "--> Schedule of daily_audit_check.sh script on BACKUP systems" 
#ssh ${BACKUP_1} "echo "/usr/lnk/shell/daily_audit_check.sh" | at now +2 minutes"
#ssh ${BACKUP_2} "echo "/usr/lnk/shell/daily_audit_check.sh" | at now +2 minutes"
#ssh ${BACKUP_3} "echo "/usr/lnk/shell/daily_audit_check.sh" | at now +2 minutes"
#ssh ${BACKUP_4} "echo "/usr/lnk/shell/daily_audit_check.sh" | at now +2 minutes"
#ssh ${BACKUP_5} "echo "/usr/lnk/shell/daily_audit_check.sh" | at now +2 minutes"

exit 0
