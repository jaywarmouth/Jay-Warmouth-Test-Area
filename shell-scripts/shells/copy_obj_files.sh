#!/bin/sh
#
# Program Name  : copy_obj_files.sh
# Description   : Does scp from requested remote system to host system those files listed in the file entered with the -f option 
#		  Command Line Arguments:
#		  -r <remote system name>  (e.g. robin,husk,rook)
#		  -f <filename>  (list of filenames)
# Author        : Linda S. Jefferis
# Date          : 08/31/2006
# Modifications : 07/20/2011 - Added chmod/chgrp commands
#
# Variables Used:
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
COPYTO="/usr/lnk/obj"
COPYFR="/usr/lnk/obj"
OUTPUT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copy_obj_files.sh -r <remote system name> -f <file list name>

ENDOFUSAGE
  exit 1
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

OUT_LOG="${OUTPUT_DIR}/obj_scp.$$"

date > ${OUT_LOG}

   echo "Host system=${HOSTNAME}" >> ${OUT_LOG}
   echo "Remote system=${REMOTE}" >> ${OUT_LOG}
   echo "Copy From Directory = ${COPYFR}" >> ${OUT_LOG}
   echo "Copy To Directory = ${COPYTO}" >> ${OUT_LOG}
   echo "FILE_LIST=$FILE_LIST" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   for file in `cat ${FILE_LIST}`
   do
      scp -q ${REMOTE}:${COPYFR}/$file ${COPYTO}/$file
      if test $? -eq 0
      then
         echo "$file copy complete" >> ${OUT_LOG}
	 chmod 664 ${COPYTO}/$file
	 chgrp devadm ${COPYTO}/$file
      else
         echo "ERROR - $file not copied" >> ${OUT_LOG}
      fi
   done
date >> ${OUT_LOG}


exit 0
