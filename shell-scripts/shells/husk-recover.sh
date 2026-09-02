#!/bin/ksh
#
# Program Name  : husk-recover.sh
# Author        : Linda S. Jefferis
# Date          : 08/24/2012
#
# Variables Used:
PATH=$PATH:/usr/local/bin
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
COPYTO="/usr/lnk"
COPYFR="/usr/lnk"
OUTPUT_DIR="/usr/lnk/backup"
SHELL="/usr/lnk/shell"
DAY=`date +%w`
MAILUSER="operator@pdmi.com"
MAIL_PROG="/bin/mail"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: husk-recover.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Set log filename
OUT_LOG="${OUTPUT_DIR}/husk_recover"

date > ${OUT_LOG}


	echo "Running recover1 on CARDH00MAS file" >> ${OUT_LOG}
        /usr/rmcobol/recover1 /usr/lnk/crd_02/CARDH00MAS /usr/lnk/wrk/drop-card -L /usr/lnk/wrk/log-card -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of CARDH00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of CARDH00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-card >> ${OUT_LOG}
	rm -f /usr/lnk/wrk/log-card
        date >> ${OUT_LOG}

	echo "Running recover1 on CATAB00MAS file" >> ${OUT_LOG}
        /usr/rmcobol/recover1 /usr/lnk/crd_01/CATAB00MAS /usr/lnk/wrk/drop-catab -L /usr/lnk/wrk/log-catab -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of CATAB00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of CATAB00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-catab >> ${OUT_LOG}
	rm -f /usr/lnk/wrk/log-catab
        date >> ${OUT_LOG}

	echo "Running recover1 on CLCOB00MAS file" >> ${OUT_LOG}
        /usr/rmcobol/recover1 /usr/lnk/claims/CLCOB00MAS /usr/lnk/wrk/drop-clcob -L /usr/lnk/wrk/log-clcob -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of CLCOB00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of CLCOB00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-clcob >> ${OUT_LOG}
	rm -f /usr/lnk/wrk/log-clcob
        date >> ${OUT_LOG}

	echo "Running recover1 on PDECL00MAS file" >> ${OUT_LOG}
        /usr/rmcobol/recover1 /usr/lnk/claims/PDECL00MAS /usr/lnk/wrk/drop-pde -L /usr/lnk/wrk/log-pde -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of PDECL00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of PDECL00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-pde >> ${OUT_LOG}
	rm -f /usr/lnk/wrk/log-pde
        date >> ${OUT_LOG}

${MAIL_PROG} -s "Daily File Recover for ${HOSTNAME}" ${MAILUSER} < ${OUT_LOG}

exit 0
