#!/bin/sh

#
# Variables:
SHELL_DIR=/usr/lnk/shell
LOG_DIR=/usr/lnk/wt/oper-wt/accumeliglogs

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum_step2_process.sh [file name]
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

if [ ${HOST_SYS} = "prod10" ]
then
	nohup ${SHELL_DIR}/accum01.sh -u -c ${file_name:0:2} -d ${file_name:3} > ${LOG_DIR}/${HOST_SYS}_accum01_process_${file_name}.txt 2>&1
else
	nohup ${SHELL_DIR}/testinbound_accum01.sh -u -c ${file_name:0:2} -d ${file_name:3} > ${LOG_DIR}/${HOST_SYS}_testaccum_process_${file_name}.txt 2>&1
fi
