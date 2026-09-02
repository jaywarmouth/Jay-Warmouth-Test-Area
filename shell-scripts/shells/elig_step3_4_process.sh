#!/bin/sh
#
# Program Name  : elig_step3_4_process
# Description   : script to run both elig step3 & step4 together
#
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
LOG_DIR="/usr/lnk/wt/oper-wt/accumeliglogs"

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elig_step3_4_process.sh 

ENDOFUSAGE
  exit 1
}

if [ $# -lt 1 ]
then
        usage
fi

 file_name=$1
 client_id=$(echo "${file_name}" | cut -c 1-2)        

${SHELL_DIR}/elig_step3_process.sh ${file_name}

if [ $? -ne 0 ]
then
   echo "Script elig_step3_process.sh failed. Review and rerun if necessary."
exit 99
fi

${SHELL_DIR}/elig_step4_process.sh ${client_id} 

if [ $? -ne 0 ]
then
   echo "Script elig_step4_process.sh failed"
   usage
fi

echo "Eligibilty step 3 & 4 completed successfully"
exit 0
