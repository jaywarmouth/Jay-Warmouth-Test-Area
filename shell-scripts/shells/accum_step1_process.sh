#!/bin/sh

#
# Variables:
SHELL_DIR=/usr/lnk/shell
LOG_DIR=/usr/lnk/wt/oper-wt/accumeliglogs

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum_step1_process.sh [file name]
        where [file name] is:
        <clientID>l<mmdd>

ENDOFUSAGE
  exit 1
}

if [ $# -lt 1 ]
then
        usage
fi

file_name=$1
HOST_SYS=`hostname -s`


nohup ${SHELL_DIR}/convaccumfile.sh ${file_name} > ${LOG_DIR}/${HOST_SYS}_convaccumfile_${file_name}.txt 2>&1
if test $? -ne 0
then
	echo "->** Issue with convaccumfile.sh process. Review log file: ${LOG_DIR}/${HOST_SYS}_convaccumfile_${file_name}.txt"
fi
