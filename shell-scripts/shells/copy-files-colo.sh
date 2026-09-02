#!/bin/ksh
#
# Program Name  : copy-files-colo.sh
# Description   : Does rcp from requested remote system to host system those files listed in the input cat file 
#		  Command Line Arguments:
#		  -r <remote system name>  (e.g. raven, pdm01, falcon)
# Author        : Linda S. Jefferis
# Date          : 01/13/2010
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

usage: copy-files-colo.sh [-r <remote system name>]

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
OUT_LOG="${OUTPUT_DIR}/dly_rcp" 

date > ${OUT_LOG}

   echo "Host system=${HOSTNAME}" >> ${OUT_LOG}
   echo "Remote system=${REMOTE}" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   for file do
      date >> ${OUT_LOG}
      scp -q ${REMOTE}:${COPYFR}/$file ${COPYTO}/$file
      if test $? -eq 0
      then
         echo "$file copy complete" >> ${OUT_LOG}
      else
         echo "*** ERROR - $file NOT COPIED ***" >> ${OUT_LOG}
      fi
   done
date >> ${OUT_LOG}

${MAIL_PROG} -s "Daily File Copies for ${HOSTNAME}" ${MAILUSER} < ${OUT_LOG}

exit 0
