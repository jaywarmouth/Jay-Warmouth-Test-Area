#!/bin/sh
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
#		: 1/1/2015 - Add logic for CLMSS audit files
#               : 05/07/2015 - TT #12432-3 changed 401 audit file anem to 402 for new MCET file and 401 not used for restack anymore.
#		: 02/07/2016 - TT12432-4,12432-5,12432-6,12432-8
#		: 09/12/2016 - add EFSS audit files (Ticket #16089)
#		: 03/28/2018 - TT18207-21; SCSS audit files
#
# Variables Used:
REMOTE_DIR="/usr/lnk/audit"
HOST_DIR="/usr/lnk/audit"
SHELL_DIR="/usr/lnk/shell"
DATE=`date +%Y%m%d`
FNAME[0]="AUDIT-400-${DATE}"
FNAME[1]="AUDIT-402-${DATE}"
FNAME[2]="AUDIT-404-${DATE}"
FNAME[3]="AUDIT-406-${DATE}"
FNAME[4]="AUDIT-408-${DATE}"
FNAME[5]="AUDIT-300-${DATE}"
FNAME[6]="AUDIT-301-${DATE}"
FNAME[7]="AUDIT-200-${DATE}"
FNAME[8]="AUDIT-201-${DATE}"
FNAME[9]="DMR-${DATE}"
FNAME[10]="CLAIM02"
MSG[0]="MSG-400-${DATE}"
MSG[1]="MSG-402-${DATE}"
MSG[2]="MSG-404-${DATE}"
MSG[3]="MSG-406-${DATE}"
MSG[4]="MSG-408-${DATE}"
MSG[5]="MSG-300-${DATE}"
MSG[6]="MSG-301-${DATE}"
MSG[7]="MSG-200-${DATE}"
MSG[8]="MSG-201-${DATE}"
CLMSS[0]="CLMSS-400-${DATE}"
CLMSS[1]="CLMSS-402-${DATE}"
CLMSS[2]="CLMSS-404-${DATE}"
CLMSS[3]="CLMSS-406-${DATE}"
CLMSS[4]="CLMSS-408-${DATE}"
CLMSS[5]="CLMSS-300-${DATE}"
CLMSS[6]="CLMSS-301-${DATE}"
CLMSS[7]="CLMSS-200-${DATE}"
CLMSS[8]="CLMSS-201-${DATE}"
EFSS[0]="EFSS-400-${DATE}"
EFSS[1]="EFSS-402-${DATE}"
EFSS[2]="EFSS-404-${DATE}"
EFSS[3]="EFSS-406-${DATE}"
EFSS[4]="EFSS-408-${DATE}"
EFSS[5]="EFSS-300-${DATE}"
EFSS[6]="EFSS-301-${DATE}"
EFSS[7]="EFSS-200-${DATE}"
EFSS[8]="EFSS-201-${DATE}"
SCSS[0]="SCSS-400-${DATE}"
SCSS[1]="SCSS-402-${DATE}"
SCSS[2]="SCSS-404-${DATE}"
SCSS[3]="SCSS-406-${DATE}"
SCSS[4]="SCSS-408-${DATE}"
SCSS[5]="SCSS-300-${DATE}"
SCSS[6]="SCSS-301-${DATE}"
SCSS[7]="SCSS-200-${DATE}"
SCSS[8]="SCSS-201-${DATE}"
MAXVALUE=9
MSGFILES=8
CLMSSFILES=8
EFSSFILES=8
SCSSFILES=8
CHK_RPT="/tmp/updaudit_chk"
HOST=`/usr/lnk/shell/get_hostname.sh`
SUBJECT="$HOST updaudit"
MAILUSER="operations@pdmi.com"
ERR_MSG="Problem with updaudit.sh; claim96 already running"
NOW_FLAG=0
RPT_DIR=/usr/lnk/rpt
LOG=/tmp/err-updaudit.txt

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

ps -e | grep recover > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "A file recover is currently running on Husk." > $LOG
	echo "When completed, run the following on Husk (operator user):    /usr/lnk/shell/updaudit-spechusk.sh -r prod10 -now" >> $LOG
	cat $LOG | /bin/mail -s "Husk updaudit and recovery message" operations@pdmi.com
	exit 99
fi

ps -e | grep claim96 > ${CHK_RPT}
if test -s ${CHK_RPT}
then
   echo $ERR_MSG | /bin/mail -s "$SUBJECT" $MAILUSER
   exit 99
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
scp -q ${RNAME}:${REMOTE_DIR}/${FNAME[10]} ${HOST_DIR}/${FNAME[10]}.tmp
if test $? -eq 0
then
  mv ${HOST_DIR}/${FNAME[10]}.tmp ${HOST_DIR}/${FNAME[10]}-${DATE}.${SYS}
fi
i=0
while [ $i -le $MSGFILES ]
do
    scp -q ${RNAME}:${REMOTE_DIR}/${MSG[i]} ${HOST_DIR}/${MSG[i]}.tmp
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${MSG[i]}.tmp ${HOST_DIR}/${MSG[i]}.${SYS}
    fi
    let i=i+1
done
i=0
while [ $i -le $CLMSSFILES ]
do
    scp -q ${RNAME}:${REMOTE_DIR}/${CLMSS[i]} ${HOST_DIR}/${CLMSS[i]}.tmp
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${CLMSS[i]}.tmp ${HOST_DIR}/${CLMSS[i]}.${SYS}
    fi
    let i=i+1
done
i=0
while [ $i -le $EFSSFILES ]
do
    scp -q ${RNAME}:${REMOTE_DIR}/${EFSS[i]} ${HOST_DIR}/${EFSS[i]}.tmp
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${EFSS[i]}.tmp ${HOST_DIR}/${EFSS[i]}.${SYS}
    fi
    let i=i+1
done
while [ $i -le $SCSSFILES ]
do
    scp -q ${RNAME}:${REMOTE_DIR}/${SCSS[i]} ${HOST_DIR}/${SCSS[i]}.tmp
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${SCSS[i]}.tmp ${HOST_DIR}/${SCSS[i]}.${SYS}
    fi
    let i=i+1
done


${SHELL_DIR}/claim96.sh -a all -d ${DATE}.${SYS} -p ${HOST_DIR} > ${RPT_DIR}/claim96 2>&1
${SHELL_DIR}/analyze-claim96output.sh


exit 0
