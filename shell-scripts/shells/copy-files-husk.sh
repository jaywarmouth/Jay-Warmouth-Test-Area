#!/bin/ksh
#
# Program Name  : copy-files.sh
# Description   : Does rcp from requested remote system to host system those files listed in the input cat file 
#		  Command Line Arguments:
#		  -r <remote system name>  (e.g. raven, pdm01, falcon)
# Author        : Linda S. Jefferis
# Date          : 11/15/2005
# Modifications : 
#
# Variables Used:
PATH=$PATH:/usr/local/bin
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
COPYTO="/usr/lnk"
COPYFR="/usr/lnk"
OUTPUT_DIR="/usr/lnk/backup"
SHELL="/usr/lnk/shell"
DAY=`date +%w`
MAILUSER="ljefferis@pdmi.com"
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
	REMOTE_SYS=$1
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
REMOTE=${REMOTE_SYS}
   echo "Remote system=${REMOTE}" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   for file do
      date >> ${OUT_LOG}
      scp ${REMOTE}:${COPYFR}/$file ${COPYTO}/$file.tmp
      if test $? -eq 0
      then
	 cp ${COPYTO}/$file.tmp ${COPYTO}/$file
	 rm ${COPYTO}/$file.tmp
         echo "$file copy complete" >> ${OUT_LOG}
      else
	 rm ${COPYTO}/$file.tmp
         echo "ERROR - $file not copied" >> ${OUT_LOG}
      fi
   done
date >> ${OUT_LOG}

echo "" >> ${OUT_LOG}
echo "COMPU11" >> ${OUT_LOG}
${SHELL}/compu11.sh >> ${OUT_LOG} 2>&1

if [ ${DAY} = 0 ]
then
   ${MAIL_PROG} -s "Weekly File Copies from ${REMOTE}" ${MAILUSER} < ${OUT_LOG}
else
   ${MAIL_PROG} -s "Daily File Copies from ${REMOTE}" ${MAILUSER} < ${OUT_LOG}
fi

exit 0
