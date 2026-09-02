#!/bin/ksh
#
# Program Name  : copy-files-colo_refresh.sh
# Description   : Does scp from requested remote system to host system those files listed in the input cat file 
#		  Command Line Arguments:
#		  -r <remote system name>  (e.g. rook, firefly)
# Author        : Linda S. Jefferis
# Date          : 12/10/2008
# Modifications : 04/01/2009 - Added LIMIT00MAS and ONETM00MAS logic
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
RECOVER_PROG="/usr/rmcobol/recover1"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copy-files-colo_refresh.sh [-r <remote system name>]

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
  case "$1"
  in
    -r) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	REMOTE=$1
	;;
     *) usage
	;;
  esac
  shift

# Set log filename
OUT_LOG="${OUTPUT_DIR}/wkly_rcp" 

date > ${OUT_LOG}

   echo "Host system=${HOSTNAME}" >> ${OUT_LOG}
   echo "Remote system=${REMOTE}" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   for file do
      date >> ${OUT_LOG}
      scp -q ${REMOTE}:${COPYFR}/$file ${COPYTO}/$file.tmp
      if test $? -eq 0
      then
         cp ${COPYTO}/$file.tmp ${COPYTO}/$file
         echo "$file copy complete" >> ${OUT_LOG}
      else
         echo "*** ERROR - $file NOT COPIED ***" >> ${OUT_LOG}
      fi
      rm ${COPYTO}/$file.tmp
   done
date >> ${OUT_LOG}

	echo "Running recover1 on CLAIM80MAS file" >> ${OUT_LOG}
        ${RECOVER_PROG} /usr/lnk/claims/CLAIM80MAS /usr/lnk/wrk/drop-claim80 -L /usr/lnk/wrk/log-claim80 -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of CLAIM80MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of CLAIM80MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
	echo "Running recover1 on PDECL00MAS file" >> ${OUT_LOG}
        ${RECOVER_PROG} /usr/lnk/claims/PDECL00MAS /usr/lnk/wrk/drop-pde -L /usr/lnk/wrk/log-pde -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of PDECL00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of PDECL00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
	echo "Running recover1 on CARDI00MAS file" >> ${OUT_LOG}
        ${RECOVER_PROG} /usr/lnk/crd_01/CARDI00MAS /usr/lnk/wrk/drop-cardi -L /usr/lnk/wrk/log-cardi -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of CARDI00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of CARDI00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
	echo "Running recover1 on LIMIT00MAS file" >> ${OUT_LOG}
        ${RECOVER_PROG} /usr/lnk/crd_01/LIMIT00MAS /usr/lnk/wrk/drop-limit -L /usr/lnk/wrk/log-limit -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of LIMIT00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of LIMIT00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "Running recover1 on ONETM00MAS file" >> ${OUT_LOG}
        ${RECOVER_PROG} /usr/lnk/crd_01/ONETM00MAS /usr/lnk/wrk/drop-onetm -L /usr/lnk/wrk/log-onetm -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of ONETM00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of ONETM00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-claim80 >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-pde >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-cardi >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-limit >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-onetm >> ${OUT_LOG}
	rm -f /usr/lnk/wrk/log-claim80
	rm -f /usr/lnk/wrk/log-pde
	rm -f /usr/lnk/wrk/log-cardi
	rm -f /usr/lnk/wrk/log-limit
	rm -f /usr/lnk/wrk/log-onetm
        date >> ${OUT_LOG}

${MAIL_PROG} -s "Refresh File Copies for ${HOSTNAME} from ${REMOTE}" ${MAILUSER} < ${OUT_LOG}

exit 0
