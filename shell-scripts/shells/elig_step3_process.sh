#!/bin/sh

#
# Variables:
SHELL_DIR=/usr/lnk/shell
LOG_DIR=/usr/lnk/wt/oper-wt/accumeliglogs

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elig_step3_process.sh [file name]
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

if [ ${HOST_SYS} = "prod10" ]
then
	nohup ${SHELL_DIR}/elig_process.sh ${file_name} > ${LOG_DIR}/${HOST_SYS}_elig_process_${file_name}.txt 2>&1
else
	nohup ${SHELL_DIR}/testelig_process.sh ${file_name} > ${LOG_DIR}/${HOST_SYS}_testelig_process_${file_name}.txt 2>&1
fi
