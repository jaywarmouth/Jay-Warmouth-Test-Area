#!/bin/ksh
#
# Program Name	: start_claims_del.sh
# Description	: Runs claims_del.sh with proper permissions
#
# Author	: Linda S. Jefferis
# Date		: 03/24/2006
# Modifications : 03/26/2006 - Added firefly to run as c04 also  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: start_claims_del.sh 

ENDOFUSAGE
  exit 1
}

#
# Are we root?
check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
                echo "You need to be root to run this program!"
                exit 100
        fi
}

#
# Main routine
#

check_for_root

if [ ${HOSTNAME} = "prod10" -o ${HOSTNAME} = "prod11" ]
then
   su - c04 -c "${SHELL_DIR}/claims_del.sh"
else
   ${SHELL_DIR}/claims_del.sh 2>&1
fi


exit 0
