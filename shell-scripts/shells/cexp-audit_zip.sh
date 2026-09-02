#!/bin/sh
#
# Program Name	: cexp-audit_zip.sh
# Description   : zips previous day's AUDIT file and compresses all *AUD files
# Author	: Linda S. Jefferis
#
# Variables Used:
DATE=`date +%Y%m%d`
#DATE=`date -d "yesterday 0800" +%Y%m%d`
TODAY=`date +%Y%m%d`
PROD_DIR="/usr/lnk/audit"
PROD_BKUP="/usr/lnk/audit/backup"
BACKUP_1="prod11"
BACKUP_2="husk"
BACKUP_3="robin"
BACKUP_4="prod20"
BACKUP_5="prodtest10"
BACKUP_DIR=/usr/lnk/audit
FNAME[0]="AUDIT-400-"
FNAME[1]="AUDIT-402-"
FNAME[2]="AUDIT-404-"
FNAME[3]="AUDIT-406-"
FNAME[4]="AUDIT-408-"
FNAME[5]="AUDIT-300-"
FNAME[6]="AUDIT-301-"
FNAME[7]="AUDIT-200-"
FNAME[8]="AUDIT-201-"
FNAME[9]="DMR-"
MAXVALUE_1=9
MSG[0]="MSG-400-"
MSG[1]="MSG-402-"
MSG[2]="MSG-404-"
MSG[3]="MSG-406-"
MSG[4]="MSG-408-"
MSG[5]="MSG-300-"
MSG[6]="MSG-301-"
MSG[7]="MSG-200-"
MSG[8]="MSG-201-"
MSGFILES=8
CLMSS[0]="CLMSS-400-"
CLMSS[1]="CLMSS-402-"
CLMSS[2]="CLMSS-404-"
CLMSS[3]="CLMSS-406-"
CLMSS[4]="CLMSS-408-"
CLMSS[5]="CLMSS-300-"
CLMSS[6]="CLMSS-301-"
CLMSS[7]="CLMSS-200-"
CLMSS[8]="CLMSS-201-"
CLMSSFILES=8
EFSS[0]="EFSS-400-"
EFSS[1]="EFSS-402-"
EFSS[2]="EFSS-404-"
EFSS[3]="EFSS-406-"
EFSS[4]="EFSS-408-"
EFSS[5]="EFSS-300-"
EFSS[6]="EFSS-301-"
EFSS[7]="EFSS-200-"
EFSS[8]="EFSS-201-"
EFSSFILES=8
SCSS[0]="SCSS-400-"
SCSS[1]="SCSS-402-"
SCSS[2]="SCSS-404-"
SCSS[3]="SCSS-406-"
SCSS[4]="SCSS-408-"
SCSS[5]="SCSS-300-"
SCSS[6]="SCSS-301-"
SCSS[7]="SCSS-200-"
SCSS[8]="SCSS-201-"
SCSSFILES=8

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage:  audit_zip.sh

ENDOFUSAGE
  exit 1
}


#
# Main routine
#


echo ""
echo "--> Doing scp and zip of AUDIT files"
i=0
while [ $i -le ${MAXVALUE_1} ]
do
   if test -a ${PROD_DIR}/${FNAME[i]}${DATE}
   then
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_1}:${BACKUP_DIR}/${FNAME[i]}${DATE}.prod10old
      if test $? -ne 0
      then
   	echo ""
	echo "-*> scp of ${FNAME[i]}${DATE} to ${BACKUP_1} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_2}:${BACKUP_DIR}/${FNAME[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${FNAME[i]}${DATE} to ${BACKUP_2} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_3}:${BACKUP_DIR}/${FNAME[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${FNAME[i]}${DATE} to ${BACKUP_3} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_4}:${BACKUP_DIR}/${FNAME[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${FNAME[i]}${DATE} to ${BACKUP_4} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${FNAME[i]}${DATE} ${BACKUP_5}:${BACKUP_DIR}/${FNAME[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${FNAME[i]}${DATE} to ${BACKUP_5} was unsuccessful"
      fi
   else
      echo ""
      echo "-*> ${PROD_DIR}/${FNAME[i]}${DATE} does not exist"
   fi
   mv ${PROD_DIR}/${FNAME[i]}${DATE} ${PROD_BKUP}
   let i=i+1
done
i=0
while [ $i -le ${MSGFILES} ]
do
   if test -a ${PROD_DIR}/${MSG[i]}${DATE}
   then
      scp -q ${PROD_DIR}/${MSG[i]}${DATE} ${BACKUP_1}:${BACKUP_DIR}/${MSG[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "-*> scp of ${MSG[i]}${DATE} to ${BACKUP_1} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${MSG[i]}${DATE} ${BACKUP_2}:${BACKUP_DIR}/${MSG[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${MSG[i]}${DATE} to ${BACKUP_2} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${MSG[i]}${DATE} ${BACKUP_3}:${BACKUP_DIR}/${MSG[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${MSG[i]}${DATE} to ${BACKUP_3} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${MSG[i]}${DATE} ${BACKUP_4}:${BACKUP_DIR}/${MSG[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${MSG[i]}${DATE} to ${BACKUP_4} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${MSG[i]}${DATE} ${BACKUP_5}:${BACKUP_DIR}/${MSG[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${MSG[i]}${DATE} to ${BACKUP_5} was unsuccessful"
      fi
   else
      echo ""
      echo "-*> ${PROD_DIR}/${MSG[i]}${DATE} does not exist"
   fi
   mv ${PROD_DIR}/${MSG[i]}${DATE} ${PROD_BKUP}
   let i=i+1
done

i=0
while [ $i -le ${CLMSSFILES} ]
do
   if test -a ${PROD_DIR}/${CLMSS[i]}${DATE}
   then
      scp -q ${PROD_DIR}/${CLMSS[i]}${DATE} ${BACKUP_1}:${BACKUP_DIR}/${CLMSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "-*> scp of ${CLMSS[i]}${DATE} to ${BACKUP_1} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${CLMSS[i]}${DATE} ${BACKUP_2}:${BACKUP_DIR}/${CLMSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${CLMSS[i]}${DATE} to ${BACKUP_2} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${CLMSS[i]}${DATE} ${BACKUP_3}:${BACKUP_DIR}/${CLMSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${CLMSS[i]}${DATE} to ${BACKUP_3} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${CLMSS[i]}${DATE} ${BACKUP_4}:${BACKUP_DIR}/${CLMSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${CLMSS[i]}${DATE} to ${BACKUP_4} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${CLMSS[i]}${DATE} ${BACKUP_5}:${BACKUP_DIR}/${CLMSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${CLMSS[i]}${DATE} to ${BACKUP_5} was unsuccessful"
      fi
   else
      echo ""
      echo "-*> ${PROD_DIR}/${CLMSS[i]}${DATE} does not exist"
   fi
   mv ${PROD_DIR}/${CLMSS[i]}${DATE} ${PROD_BKUP}
   let i=i+1
done

i=0
while [ $i -le ${EFSSFILES} ]
do
   if test -a ${PROD_DIR}/${EFSS[i]}${DATE}
   then
      scp -q ${PROD_DIR}/${EFSS[i]}${DATE} ${BACKUP_1}:${BACKUP_DIR}/${EFSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "-*> scp of ${EFSS[i]}${DATE} to ${BACKUP_1} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${EFSS[i]}${DATE} ${BACKUP_2}:${BACKUP_DIR}/${EFSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${EFSS[i]}${DATE} to ${BACKUP_2} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${EFSS[i]}${DATE} ${BACKUP_3}:${BACKUP_DIR}/${EFSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${EFSS[i]}${DATE} to ${BACKUP_3} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${EFSS[i]}${DATE} ${BACKUP_4}:${BACKUP_DIR}/${EFSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${EFSS[i]}${DATE} to ${BACKUP_4} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${EFSS[i]}${DATE} ${BACKUP_5}:${BACKUP_DIR}/${EFSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${EFSS[i]}${DATE} to ${BACKUP_5} was unsuccessful"
      fi
   else
      echo ""
      echo "-*> ${PROD_DIR}/${EFSS[i]}${DATE} does not exist"
   fi
   mv ${PROD_DIR}/${EFSS[i]}${DATE} ${PROD_BKUP}
   let i=i+1
done

i=0
while [ $i -le ${SCSSFILES} ]
do
   if test -a ${PROD_DIR}/${SCSS[i]}${DATE}
   then
      scp -q ${PROD_DIR}/${SCSS[i]}${DATE} ${BACKUP_1}:${BACKUP_DIR}/${SCSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "-*> scp of ${SCSS[i]}${DATE} to ${BACKUP_1} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${SCSS[i]}${DATE} ${BACKUP_2}:${BACKUP_DIR}/${SCSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${SCSS[i]}${DATE} to ${BACKUP_2} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${SCSS[i]}${DATE} ${BACKUP_3}:${BACKUP_DIR}/${SCSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${SCSS[i]}${DATE} to ${BACKUP_3} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${SCSS[i]}${DATE} ${BACKUP_4}:${BACKUP_DIR}/${SCSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${SCSS[i]}${DATE} to ${BACKUP_4} was unsuccessful"
      fi
      scp -q ${PROD_DIR}/${SCSS[i]}${DATE} ${BACKUP_5}:${BACKUP_DIR}/${SCSS[i]}${DATE}.prod10old
      if test $? -ne 0
      then
        echo ""
        echo "   -*> scp of ${SCSS[i]}${DATE} to ${BACKUP_5} was unsuccessful"
      fi
   else
      echo ""
      echo "-*> ${PROD_DIR}/${SCSS[i]}${DATE} does not exist"
   fi
   mv ${PROD_DIR}/${SCSS[i]}${DATE} ${PROD_BKUP}
   let i=i+1
done

touch ${PROD_DIR}/DMR-${TODAY}
chmod 666 ${PROD_DIR}/DMR-${TODAY}

echo ""
echo "--> Schedule of claim96.sh script on BACKUP systems" 
ssh ${BACKUP_1} "echo "/usr/lnk/shell/claim96.sh -a all -d ${DATE}.prod10old -p /usr/lnk/audit -u NNNYNNNN > /usr/lnk/rpt/cexp-claim96 2>&1" | at now +2 minutes"
ssh ${BACKUP_2} "echo "/usr/lnk/shell/claim96.sh -a all -d ${DATE}.prod10old -p /usr/lnk/audit -u NNNYNNNN > /usr/lnk/rpt/cexp-claim96 2>&1" | at now +2 minutes"
ssh ${BACKUP_3} "echo "/usr/lnk/shell/claim96.sh -a all -d ${DATE}.prod10old -p /usr/lnk/audit -u NNNYNNNN > /usr/lnk/rpt/cexp-claim96 2>&1" | at now +2 minutes"
ssh ${BACKUP_4} "echo "/usr/lnk/shell/claim96.sh -a all -d ${DATE}.prod10old -p /usr/lnk/audit -u NNNYNNNN > /usr/lnk/rpt/cexp-claim96 2>&1" | at now +2 minutes"
ssh ${BACKUP_5} "echo "/usr/lnk/shell/claim96.sh -a all -d ${DATE}.prod10old -p /usr/lnk/audit -u NNNYNNNN > /usr/lnk/rpt/cexp-claim96 2>&1" | at now +2 minutes"

exit 0
