#!/bin/sh
#
# Program Name  : validateeligfile.sh
# Description   : Elig file validation processes
#                
#
# Variables Used:
SHELL_DIR=/usr/lnk/shell
CONFIG_FILE="/usr/lnk/elig_in/elig.cfg"
#CONFIG_FILE="/media/test/TC05/nochange_output/elig.cfg"
CR="
"
FILE_NAME="null"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: validateeligfile.sh [file name] 
	where [file name] is:
	<clientID>e<mmdd>

ENDOFUSAGE
  exit 1
}

#
# Parse config. record
parse_config()
{
        ELIG_TYPE=`echo $line | awk -F: '{ print $4 }'`
}

#
# Validate client
validate_client()
{
IFS="$CR"
FOUND=0
for line in `cat $CONFIG_FILE | grep -v "^#"`
do
        IFS="$OIFS"
        fid=`echo $line | awk -F: '{ print $1 }'`

        if [ "$CLIENT" = "$fid" ]
        then
                FOUND="1"
                parse_config
        fi
done
if [ "$FOUND" -ne 1 ]
then
        echo "Client ID $CLIENT not found in database."
        exit 99
fi
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
	usage
fi
FILE_NAME=$1
CLIENT=`echo ${FILE_NAME} | cut -c1-2`
validate_client

${SHELL_DIR}/crdck01.sh -f ${FILE_NAME}

${SHELL_DIR}/cardh30_new.sh -f ${FILE_NAME}


exit ${RETVAL}
