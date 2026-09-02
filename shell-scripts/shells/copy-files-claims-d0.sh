#!/bin/ksh
#
# Program Name  : copy-files-claims-d0.sh
# Description   : Does rcp from requested remote system to host system those files listed in the input cat file 
#		  Command Line Arguments:
#		  -r <remote system name>  
# Author        : Linda S. Jefferis
# Date          : 12/11/2009
# Modifications : 
#
# Variables Used:
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
OUTPUT_DIR="/usr/lnk/d0/rpt"
SHELL="/usr/lnk/shell"
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
	OUT_LOG="${OUTPUT_DIR}/claims-hist-scp"

date >> ${OUT_LOG}

   echo "Host system=${HOSTNAME}" >> ${OUT_LOG}
   echo "Remote system=${REMOTE}" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   for file do
      date >> ${OUT_LOG}
      scp -q ${REMOTE}:$file $file
      if test $? -eq 0
      then
	 chmod 666 $file
	 chown c04 $file
	 chgrp c04 $file
         echo "$file copy complete" >> ${OUT_LOG}
      else
         echo "*** ERROR - $file NOT COPIED ***" >> ${OUT_LOG}
      fi
   done
date >> ${OUT_LOG}

   ${MAIL_PROG} -s "D0 Claims File Copies" ${MAILUSER} < ${OUT_LOG}

exit 0
