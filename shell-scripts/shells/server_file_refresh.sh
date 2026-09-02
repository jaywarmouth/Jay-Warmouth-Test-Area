#!/bin/ksh
#
# Program Name  : server_file_refresh.sh
# Description   : Does copy from requested remote system to host system those files listed in the input cat file 
#		  Command Line Arguments:
#		  -r <remote system name> 
#		  -f <filename> - file list name
# Author        : Linda S. Jefferis
# Date          : 03/30/2017
# Modifications	: 12/15/2017 - Changed "TestProd12" to "UATTrans20"
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

usage: server_file_refresh.sh [-r <remote system name>] [-f <filename>]

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

	echo "${SHELL_DIR}/checkindexfiles.sh" | at now
fi	

if [ ${HOSTNAME} = "prod20" ]
then
	COPYTO="/usr/lnk"
	COPYFR="/usr/lnk"
	remote_copy

	echo "${SHELL_DIR}/checkindexfiles.sh" | at now
fi	


if [ ${HOSTNAME} = "prodtest10" ]
then
	COPYTO=/usr/lnk
        COPYFR=/usr/lnk
        remote_copy

	echo "${SHELL_DIR}/checkindexfiles.sh" | at now
fi

if [ ${HOSTNAME} = "TestProd11" ]
then
	COPYTO=/usr/lnk
        COPYFR=/usr/lnk
        remote_copy
	echo "${SHELL_DIR}/checkindexfiles.sh" | at now
fi

if [ ${HOSTNAME} = "UATTrans20" ]
then
	COPYTO=/usr/lnk
        COPYFR=/usr/lnk
        remote_copy
fi

if [ ${HOSTNAME} = "CobolQA20" ]
then
	COPYTO=/usr/lnk
        COPYFR=/usr/lnk
        remote_copy
	echo "${SHELL_DIR}/checkindexfiles.sh" | at now
fi

if [ ${HOSTNAME} = "husk" ]
then
	COPYTO="/usr/lnk"
        COPYFR="/usr/lnk"
        remote_copy

	echo "${SHELL_DIR}/checkindexfiles.sh" | at now
fi

if [ ${HOSTNAME} = "robin" ]
then
	COPYTO="/usr/lnk"
        COPYFR="/usr/lnk"
        remote_copy
fi

${MAIL_PROG} -s "Server File Copies for ${HOSTNAME}" ${MAIL_TO} < ${OUT_LOG}

exit 0
