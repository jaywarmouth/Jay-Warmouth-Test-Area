#!/bin/ksh
#
# Program Name	: daily_updaudit.sh 
# Description	: Updates previous day's gz audit files.
#		  Command line arguments:
#		  -r <remote system name>
#		  -now - Flag to skip "sleep 60" and run immediately
# Author	: Linda Jefferis
# Date		: 
# Modifications : 08/09/2010 - Added logic for ???AUD files
#		: 08/30/2011 - Changed format for DATE
#                 3/5/2015 - Updated DATE variable assignment
#
# Variables Used:
REMOTE_DIR="/usr/lnk/audit"
HOST_DIR="/usr/lnk/audit"
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
DATE=`date -d "yesterday 0800" +%Y%m%d`
FNAME[0]="AUDIT-400-${DATE}"
FNAME[1]="AUDIT-401-${DATE}"
FNAME[2]="AUDIT-300-${DATE}"
FNAME[3]="AUDIT-301-${DATE}"
FNAME[4]="AUDIT-200-${DATE}"
FNAME[5]="AUDIT-201-${DATE}"
FNAME[6]="CLAIM02-${DATE}"
FNAME[7]="DMR-${DATE}"
MAX_FNAME=7
AUD[0]="CLAIM02.${DATE}"
AUD[1]="CRDAUD.${DATE}"
AUD[2]="CRDAUD-FG.${DATE}"
AUD[3]="CRDAUD-RT.${DATE}"
AUD[4]="FG4AUD.${DATE}"
AUD[5]="GRPAUD.${DATE}"
AUD[6]="LIMAUD.${DATE}"
AUD[7]="PDEAUD.${DATE}"
AUD[8]="PHAAUD.${DATE}"
AUD[9]="REVAUD.${DATE}"
MAX_AUD=9

CHK_CMD="ps -e | grep claim96"
CHK_RPT="/tmp/updaudit_chk"
HOST=`/usr/lnk/shell/get_hostname.sh`
SUBJECT="$HOST updaudit"
PAGE_PROG="/usr/local/bin/pageuser.sh"
PAGEUSER="linda"
MAILUSER="operator@pdmi.com"
ERR_MSG="Problem with updaudit.sh; claim96 already running"
NOW_FLAG=0
SYS="prod10"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: updaudit.sh -r <remote system name> -now
	-r <system name> - required argument
	-now - optional argument;bypasses the default "sleep 60"

ENDOFUSAGE
  exit 1
}

# Copy traffic01 audit files
cp_audit_1()
{
echo "### Claims Audit Process ###" >> ${RPT_DIR}/daily_updaudit_${DATE}
i=0
while [ $i -le $MAX_FNAME ]
do
    scp -q ${RNAME}:${REMOTE_DIR}/${FNAME[i]}.${SYS}.gz ${HOST_DIR}
    if test $? -ne 0
    then
        echo "ERROR with ${FNAME[i]} copy" >> ${RPT_DIR}/daily_updaudit_${DATE}
    else
        echo "${FNAME[i]} copied" >> ${RPT_DIR}/daily_updaudit_${DATE}
        gunzip ${HOST_DIR}/${FNAME[i]}.${SYS}.gz
    fi
    let i=i+1
done
}

# Copy other audit files
cp_audit_2()
{
echo "" >> ${RPT_DIR}/daily_updaudit_${DATE}
echo "### Miscellaneous Audit Process ###" >> ${RPT_DIR}/daily_updaudit_${DATE}
i=0
while [ $i -le $MAX_AUD ]
do
    scp -q ${SYS}:${REMOTE_DIR}/${AUD[i]}* ${HOST_DIR}
    if test $? -ne 0
    then
        echo "ERROR with ${AUD[i]} copy" >> ${RPT_DIR}/daily_updaudit_${DATE}
    else
        echo "${AUD[i]} copied" >> ${RPT_DIR}/daily_updaudit_${DATE}
        if test -e ${HOST_DIR}/${AUD[i]}.gz
        then
                gunzip ${HOST_DIR}/${AUD[i]}.gz
        else
                if ! test -s ${HOST_DIR}/${AUD[i]}
                then
                        echo "The file, ${AUD[i]}, is zero bytes" >> ${RPT_DIR}/daily_updaudit_${DATE}
                fi
        fi
    fi
    let i=i+1
done
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RNAME=$1
        ;;
    -now) NOW_FLAG=1
	;;
  esac
  shift
done

ps -e | grep claim96 > ${CHK_RPT}
if test -s ${CHK_RPT}
then
   echo $ERR_MSG | /bin/mail -s "$SUBJECT" $MAILUSER
   $PAGE_PROG "$SUBJECT" "$ERR_MSG" $PAGEUSER
   exit 1
fi

if [ $NOW_FLAG = 0 ]
then
    sleep 60
fi


find ${RPT_DIR} -follow -name "daily_updaudit_*" -mtime +14 -exec rm {} \;

cp_audit_1

${SHELL_DIR}/claim96.sh -a all -d ${DATE}.${SYS} -p ${HOST_DIR} -u 00010000 >> ${RPT_DIR}/daily_updaudit_${DATE} 2>&1

cp_audit_2

exit 0
