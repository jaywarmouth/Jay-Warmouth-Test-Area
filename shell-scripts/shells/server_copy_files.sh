#!/bin/ksh
#
# Program Name  : server_copy_files.sh
# Description   : Does copy from requested remote system to host system those files listed in the input cat file 
#		  Command Line Arguments:
#		  -r <remote system name> 
#		  -f <filename> - file list name
# Author        : Linda S. Jefferis
# Date          : 09/20/2012
#		: 02/25/2015 - add logic for TestProd11
#		: 03/05/2015 - add logic for CobolQA20
#		: 02/08/2016 - changed hostname CobolQA20 to robin
#		: 04/06/2016 - TT13915-25 (add recover process for TestProd11)
#		: 5/31/2016 - TT13990-22 add TESTPROD12 and TESTPROD21
#		: 1/10/2019 - Add CobolQA20 and remove TESTPROD21
#
# Variables Used:
PATH=$PATH:/usr/local/bin
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
CR="
"
OUTPUT_DIR="/usr/lnk/backup"
OUT_LOG="${OUTPUT_DIR}/file_copy.log"
SHELL_DIR="/usr/lnk/shell"
DAY=`date +%w`
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/bin/mail"
FILE_LIST="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: server_copy_files.sh [-r <remote system name>] [-f <filename>]

ENDOFUSAGE
  exit 1
}

#
# Remote Copy Files
remote_copy()
{
   date > ${OUT_LOG}

   echo "Host system=${HOSTNAME}" >> ${OUT_LOG}
   echo "Remote system=${REMOTE}" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   echo "FILE_LIST=${FILE_LIST}" >> ${OUT_LOG}
   IFS=${CR}
   for FILE in `cat ${FILE_LIST}`
   do
      date >> ${OUT_LOG}
      scp -q ${REMOTE}:${COPYFR}/${FILE} ${COPYTO}/${FILE}.tmp
      if test $? -eq 0
      then
         cp ${COPYTO}/${FILE}.tmp ${COPYTO}/${FILE}
         echo "${FILE} copy complete" >> ${OUT_LOG}
      else
         echo "*** ERROR - ${FILE} NOT COPIED ***" >> ${OUT_LOG}
      fi
      rm ${COPYTO}/${FILE}.tmp
   done
   date >> ${OUT_LOG}
}

#
# Copy Files
cp_files()
{
   date > ${OUT_LOG}

   echo "Host system=${HOSTNAME}" >> ${OUT_LOG}
   echo "Remote system=${REMOTE}" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   for FILE in `cat ${FILE_LIST}`
   do
      date >> ${OUT_LOG}
      cp ${COPYFR}/${FILE} ${COPYTO}/${FILE}.tmp
      if test $? -eq 0
      then
	 cp ${COPYTO}/${FILE}.tmp ${COPYTO}/${FILE} 
         echo "${FILE} copy complete" >> ${OUT_LOG}
      else
         echo "*** ERROR - ${FILE} NOT COPIED ***" >> ${OUT_LOG}
      fi
      rm ${COPYTO}/${FILE}.tmp
   done
   date >> ${OUT_LOG}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	REMOTE=$1
	;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_LIST=$1
	;;
     *) usage
	;;
  esac
  shift
done


if [ ${HOSTNAME} = "prod11" ]
then
	COPYTO=/usr/lnk
	COPYFR=/usr/lnk
	remote_copy

	echo "${SHELL_DIR}/recover_files.sh -r prod11" | at now
fi	


if [ ${HOSTNAME} = "prodtest10" ]
then
	COPYTO=/usr/lnk
        COPYFR=/usr/lnk
        remote_copy

	echo "${SHELL_DIR}/recover_files.sh -r prodtest10" | at now
fi

if [ ${HOSTNAME} = "robin" ]
then
	COPYTO="/usr/lnk"
        COPYFR="/usr/lnk"
        remote_copy
fi

${MAIL_PROG} -s "Server File Copies for ${HOSTNAME}" ${MAIL_TO} < ${OUT_LOG}

exit 0
