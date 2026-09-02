#!/bin/ksh
#
# Program Name	: updaudit.sh 
# Description	: Updates audit files to CLAIM00MAS.
#		  Command line arguments:
#		  -r <remote system name>
#		  -now - Flag to skip "sleep 60" and run immediately
# Author	: Linda Jefferis
# Date		: 04/01/99
# Modifications : 05/04/2000 - Added /usr/local/bin/picksystem.sh  (LSJ)
#		: 02/24/2003 - Changes for new SSC AUDIT-97 file  (LSJ)
#		: 05/05/2004 - Changes for new PAO AUDIT-89 file  (LSJ)
#		: 10/12/2005 - Removed SWITCH comment lines  (LSJ)
#		: 10/17/2005 - Changes for linux commands  (LSJ)
#		: 11/15/2005 - Removed picksystem run  (LSJ)
#		: 02/23/2006 - Added -now option  (LSJ)
#		: 03/20/2006 - Added AUDIT-92 file and removed AUDIT-97 file  (LSJ)
#		: 01/26/2010 - Changes for new 3-digit queue numbers and removed AUDIT-89 reference
#		: 02/09/2012 - Addition of RPT_DIR
#		: 03/08/2012 - Add logic for new MSG audit files
#
# Variables Used:
REMOTE_DIR="/usr/lnk/audit"
HOST_DIR="/usr/lnk/audit"
SHELL_DIR="/usr/lnk/shell"
DATE=`date +%Y%m%d`
FNAME[0]="AUDIT-400-${DATE}"
FNAME[1]="AUDIT-401-${DATE}"
FNAME[2]="AUDIT-300-${DATE}"
FNAME[3]="AUDIT-301-${DATE}"
FNAME[4]="AUDIT-200-${DATE}"
FNAME[5]="AUDIT-201-${DATE}"
FNAME[6]="DMR-${DATE}"
FNAME[7]="CLAIM02"
FNAME[8]="MSG-400-${DATE}"
FNAME[9]="MSG-401-${DATE}"
FNAME[10]="MSG-300-${DATE}"
FNAME[11]="MSG-301-${DATE}"
FNAME[12]="MSG-200-${DATE}"
FNAME[13]="MSG-201-${DATE}"
FNAME[14]="CLMSS-300-${DATE}"
FNAME[15]="CLMSS-301-${DATE}"
FNAME[16]="CLMSS-200-${DATE}"
FNAME[17]="CLMSS-201-${DATE}"
MAXVALUE=6
MSGFILES=13
CLMSSFILES=17
CHK_CMD="ps -e | grep claim96"
CHK_RPT="/tmp/updaudit_chk"
HOST=`/usr/lnk/shell/get_hostname.sh`
SUBJECT="$HOST updaudit"
PAGE_PROG="/usr/local/bin/pageuser.sh"
PAGEUSER="linda"
MAILUSER="operator@pdmi.com"
ERR_MSG="Problem with updaudit.sh; claim96 already running"
NOW_FLAG=0
RPT_DIR=/usr/lnk/rpt

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
	SYS=$1
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

i=0
while [ $i -le $MAXVALUE ]
do
    scp -q ${RNAME}:${REMOTE_DIR}/${FNAME[i]} ${HOST_DIR}/${FNAME[i]}.tmp
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${FNAME[i]}.tmp ${HOST_DIR}/${FNAME[i]}.${SYS}
    fi
    let i=i+1
done
scp -q ${RNAME}:${REMOTE_DIR}/${FNAME[7]} ${HOST_DIR}/${FNAME[7]}.tmp
if test $? -eq 0
then
  mv ${HOST_DIR}/${FNAME[7]}.tmp ${HOST_DIR}/${FNAME[7]}-${DATE}.${SYS}
fi
i=8
while [ $i -le $MSGFILES ]
do
    scp -q ${RNAME}:${REMOTE_DIR}/${FNAME[i]} ${HOST_DIR}/${FNAME[i]}.tmp
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${FNAME[i]}.tmp ${HOST_DIR}/${FNAME[i]}.${SYS}
    fi
    let i=i+1
done

i=14
while [ $i -le $CLMSSFILES ]
do
    scp -q ${RNAME}:${REMOTE_DIR}/${FNAME[i]} ${HOST_DIR}/${FNAME[i]}.tmp
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${FNAME[i]}.tmp ${HOST_DIR}/${FNAME[i]}.${SYS}
    fi
    let i=i+1
done

${SHELL_DIR}/claim96temp.sh -a all -d ${DATE}.${SYS} -p ${HOST_DIR} > ${RPT_DIR}/claim96 2>&1


exit 0
