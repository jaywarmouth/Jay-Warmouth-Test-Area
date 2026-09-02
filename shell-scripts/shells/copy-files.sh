#!/bin/ksh
#
# Program Name  : copy-files.sh
# Description   : Does rcp from requested remote system to host system those files listed in the input cat file 
#		  Command Line Arguments:
#		  -r <remote system name>  (e.g. raven, pdm01, falcon)
# Author        : Linda S. Jefferis
# Date          : 03/25/99
# Modifications : 02/28/2001 - Added logic to remove CARDH00MAS before the rcp  (LSJ)
#		: 03/13/2001 - Added OUT_LOG logic and Changed mailing logic
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 12/08/2005 - More changes for new Linux systems  (LSJ)
#		: 03/13/2006 - Use HOSTNAME in email subject line and other display  (LSJ)
#		: 04/29/2008 - Added recover procedure for CARDH00MAS on Husk
#		: 07/06/2011 - Add recover process for ONETM00MAS on Prod11
#		: 08/30/2011 - Add recover process for CARDH00MAS and CATAB00MAS on Prodtest10
#		: 12/20/2011 - Add recover processes for Prod20 together with Prod11
#		: 12/29/2011 - Add CLCOB00MAS recover process to Husk
#		: 12/30/2011 - Fixed "extra fi" issue and added CLCOB00MAS recover process under prod11/prod20
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

usage: copy-files.sh [-r <remote system name>]

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
  if [ ${DAY} = 0 ]
  then
	OUT_LOG="${OUTPUT_DIR}/wkly_rcp"
  else
	OUT_LOG="${OUTPUT_DIR}/dly_rcp" 
  fi

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


echo "" >> ${OUT_LOG}
echo "COMPU11" >> ${OUT_LOG}
${SHELL}/compu11.sh >> ${OUT_LOG} 2>&1

if [ ${HOSTNAME} = "prod11" -o ${HOSTNAME} = "prod20" ]
then
	echo "Running recover1 on ONETM00MAS file" >> ${OUT_LOG}
        /usr/rmcobol/recover1 /usr/lnk/crd_01/ONETM00MAS /usr/lnk/wrk/drop-onetm -L /usr/lnk/wrk/log-onetm -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of ONETM00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of ONETM00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-onetm >> ${OUT_LOG}
        rm -f /usr/lnk/wrk/log-onetm
        date >> ${OUT_LOG}
	
	echo "Running recover1 on REVER00MAS file" >> ${OUT_LOG}
        /usr/rmcobol/recover1 /usr/lnk/claims/REVER00MAS /usr/lnk/wrk/drop-rev -L /usr/lnk/wrk/log-rev -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of REVER00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of REVER00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-rev >> ${OUT_LOG}
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

	echo "Running recover1 on CARDI00MAS file" >> ${OUT_LOG}
        /usr/rmcobol/recover1 /usr/lnk/crd_01/CARDI00MAS /usr/lnk/wrk/drop-cardi -L /usr/lnk/wrk/log-cardi -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of CARDI00MAS is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of CARDI00MAS" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-cardi >> ${OUT_LOG}
        rm -f /usr/lnk/wrk/log-cardi
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

fi	


if [ ${HOSTNAME} = "prodtest10" ]
then
	echo "Running recover1 on REVER00MAS file" >> ${OUT_LOG}
	/usr/rmcobol/recover1 /usr/lnk/claims/REVER00MAS /usr/lnk/wrk/drop-rev -L /usr/lnk/wrk/log-rev -Q -Y
	if test $? -eq 0
	then
        	echo "Recovery of REVER00MAS is completed" >> ${OUT_LOG}
	else
        	echo "Error with recovery of REVER00MAS" >> ${OUT_LOG}
	fi
	echo "" >> ${OUT_LOG}
	echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
	cat /usr/lnk/wrk/log-rev >> ${OUT_LOG}
	date >> ${OUT_LOG}

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
fi

if [ ${HOSTNAME} = "husk" ]
then
	sleep 1h
	
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
fi

if [ ${DAY} = 0 ]
then
   ${MAIL_PROG} -s "Weekly File Copies for ${HOSTNAME}" ${MAILUSER} < ${OUT_LOG}
else
   ${MAIL_PROG} -s "Daily File Copies for ${HOSTNAME}" ${MAILUSER} < ${OUT_LOG}
fi

exit 0
