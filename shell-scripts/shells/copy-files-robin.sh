#!/bin/ksh
#
# Program Name  : copy-files-robin.sh
# Description   : Does scp from requested remote system to host system those files listed in the input cat file 
#		  Command Line Arguments:
#		  -r <remote system name>  (e.g. husk, rook, firefly)
# Author        : Linda S. Jefferis
# Date          : 03/25/99
# Modifications : 02/28/2001 - Added logic to remove CARDH00MAS before the rcp  (LSJ)
#		: 03/13/2001 - Added OUT_LOG logic and Changed mailing logic
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 03/21/2006 - Put HOSTNAME in output display and email  (LSJ)
#		: 04/30/2009 - Added recover process for CATAB00MAS  (LSJ)
#		: 06/25/2009 - Added recover process for REVER00MAS  (LSJ)
#		: 11/05/2009 - Added logic to remove CARDH00MAS and PDECL00MAS before scp is run  (LSJ)
#		: 11/09/2009 - Issues with PDECL00MAS; removed it for now  (LSJ)
#		: 11/13/2009 - Changed logic for CARDH00MAS  (LSJ)
#		: 12/18/2009 - new logic for PDECL00MAS copy  (LSJ)
#		: 02/11/2010 - Changed logic to remove files then copy  (LSJ)
#		: 04/26/2010 - Removed special logic for select files, files are no longer linked to /usr/tmp_wrk  (LSJ)
#		: 10/03/2010 - Commented out the recover of CARDH00MAS and CATAB00MAS
#		: 02/08/2016 - Updated with changes made in the tstshl version (LSJ).
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

usage: copy-files-robin.sh [-r <remote system name>]

ENDOFUSAGE
  exit 1
}

# Special file copy process
spec_copy()
{
date >> ${OUT_LOG}
rm -f ${OUT}
scp -q ${REMOTE}:${IN} ${OUT}
if test $? -eq 0
then
        chmod 666 ${OUT}
        chgrp pdm ${OUT}
        echo "${OUT} copy complete" >> ${OUT_LOG}
else
        echo "ERROR - ${OUT} NOT COPIED" >> ${OUT_LOG}
fi
}

# Recover process
recover_process()
{

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

#echo "Running recover1 on CARDI00MAS file" >> ${OUT_LOG}
#/usr/rmcobol/recover1 /usr/lnk/crd_01/CARDI00MAS /usr/lnk/wrk/drop-cardi -L /usr/lnk/wrk/log-cardi -Q -Y
#if test $? -eq 0
#then
#        echo "Recovery of CARDI00MAS is completed" >> ${OUT_LOG}
#else
#        echo "Error with recovery of CARDI00MAS" >> ${OUT_LOG}
#fi
#echo "" >> ${OUT_LOG}
#echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
#cat /usr/lnk/wrk/log-cardi >> ${OUT_LOG}
#date >> ${OUT_LOG}

#echo "Running recover1 on PDECL00MAS file" >> ${OUT_LOG}
#/usr/rmcobol/recover1 /usr/lnk/claims/PDECL00MAS /usr/lnk/wrk/drop-pde -L /usr/lnk/wrk/log-pde -Q -Y
#if test $? -eq 0
#then
#        echo "Recovery of PDECL00MAS is completed" >> ${OUT_LOG}
#else
#        echo "Error with recovery of PDECL00MAS" >> ${OUT_LOG}
#fi
#echo "" >> ${OUT_LOG}
#echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
#cat /usr/lnk/wrk/log-pde >> ${OUT_LOG}
#date >> ${OUT_LOG}
#
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
	REMOTE_SYS=$1
	;;
     *) usage
	;;
  esac
  shift


# Set log filename
OUT_LOG="${OUTPUT_DIR}/dly_rcp" 

date > ${OUT_LOG}
REMOTE=${REMOTE_SYS}
   echo "Remote system=${REMOTE}" >> ${OUT_LOG}
   echo "Host system=${HOSTNAME}" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   for file do
      date >> ${OUT_LOG}
      scp -p -q ${REMOTE}:${COPYFR}/$file ${COPYTO}/$file.tmp
      if test $? -eq 0
      then
	  cp ${COPYTO}/$file.tmp ${COPYTO}/$file
	 #chmod 666 ${COPYTO}/$file
	 #chgrp pdm ${COPYTO}/$file
         echo "$file copy complete" >> ${OUT_LOG}
      else
         echo "*** ERROR - $file NOT COPIED ***" >> ${OUT_LOG}
      fi
      rm -f ${COPYTO}/$file.tmp
   done


IN=/usr/lnk/pharm/NPIISSUMAS
OUT=/usr/upd/pharm/NPIISSUMAS
spec_copy

date >> ${OUT_LOG}

echo "" >> ${OUT_LOG}

recover_process

${MAIL_PROG} -s "File Copies for ${HOSTNAME} from ${REMOTE}" ${MAILUSER} < ${OUT_LOG}

exit 0
