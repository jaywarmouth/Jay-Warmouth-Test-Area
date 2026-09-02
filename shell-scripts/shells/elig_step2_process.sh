#!/bin/sh

#
# Variables:
SHELL_DIR=/usr/lnk/shell
LOG_DIR=/usr/lnk/wt/oper-wt/accumeliglogs

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elig_step2_process.sh [file name]
        where [file name] is:
        <clientID>e<mmdd>

ENDOFUSAGE
  exit 1
}

if [ $# -lt 1 ]
then
        usage
fi

file_name=$1
HOST_SYS=`hostname -s`


nohup ${SHELL_DIR}/validateeligfile.sh ${file_name} > ${LOG_DIR}/${HOST_SYS}_validateeligfile_${file_name}.txt 2>&1
