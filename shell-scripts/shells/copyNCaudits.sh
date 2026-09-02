#!/bin/sh
#
# Program Name	: copyNCaudits.sh 
# Description	: 
#		  Command line arguments:
#		  -r <remote system name>
# Author	: Linda Jefferis
# Date		: 09/05/2017
# Modifications	: 9/19/2017 - Changed HOST_DIR and added cleanup_dir.sh procedure.
#
# Variables Used:
REMOTE_DIR1="/usr/lnk/tmp"
REMOTE_DIR2="/usr/lnk/audit"
HOST_DIR="/usr/lnk/repl/server/prod10/auditfiles"
CLEANUP_CMD="/usr/lnk/shell/clean_dir.sh"
FNAME[1]="FG4AUD"
FNAME[2]="GRPAUD"
FNAME[3]="PHAAUD"
FNAME[4]="LIMAUD"
FNAME[5]="EMBAUD"
FNAME[6]="REVAUD"
FNAME[7]="CHKAUD"
FNAME[8]="CRDAUD"
FNAME[9]="CRDAUD-RT"
FNAME[10]="CRDAUD-FG"
FNAME[11]="PDEAUD"
MAXVALUE=11
LOG="/tmp/copyNCaudits.log"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copyNCaudits.sh -r <remote system name>
	-r <system name> - required argument

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
  esac
  shift
done

date > ${LOG}

echo "Runnining clean_dir.sh for $HOST_DIR" >> ${LOG}
$CLEANUP_CMD $HOST_DIR 10

i=1
while [ $i -le 2 ]
do
    scp -q ${RNAME}:${REMOTE_DIR1}/${FNAME[i]} ${HOST_DIR}/${FNAME[i]}.tmp >> ${LOG} 2>&1
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${FNAME[i]}.tmp ${HOST_DIR}/${FNAME[i]}.${SYS} >> ${LOG} 2>&1
      echo "${FNAME[i]}.${SYS} copy completed" >> ${LOG}
      date >> ${LOG}
    else
	echo "**> ERROR with ${FNAME[i]}.${SYS} copy" >> ${LOG}
    fi
    echo "" >> ${LOG}
    let i=i+1
done
i=3
while [ $i -le $MAXVALUE ]
do
    scp -q ${RNAME}:${REMOTE_DIR2}/${FNAME[i]} ${HOST_DIR}/${FNAME[i]}.tmp >> ${LOG} 2>&1
    if test $? -eq 0
    then
      mv ${HOST_DIR}/${FNAME[i]}.tmp ${HOST_DIR}/${FNAME[i]}.${SYS} >> ${LOG} 2>&1
      echo "${FNAME[i]}.${SYS} copy completed" >> ${LOG}
      date >> ${LOG}
    else
        echo "**> ERROR with ${FNAME[i]}.${SYS} copy" >> ${LOG}
    fi
    echo "" >> ${LOG}
    let i=i+1
done

ERRCNT=`grep "**> ERROR" ${LOG} | wc -l` 
if [ $ERRCNT -ne 0 ]
then
	RETVAL=99
fi

echo "RETVAL=$RETVAL" >> ${LOG}

exit $RETVAL
