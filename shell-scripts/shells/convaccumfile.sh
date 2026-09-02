#!/bin/sh
#
# Program Name  : convaccumfile.sh
# Description   : Elig file conversion to cardh29 format
#                
#
# Variables Used:
SHELL_DIR=/usr/lnk/shell
CONFIG_FILE="/usr/lnk/elig_in/accum01.cfg"
CR="
"
FILE_NAME="null"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convaccumfile.sh [file name] 
	where [file name] is:
	<clientID>l<mmdd>

ENDOFUSAGE
  exit 99
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
        fi
done
if [ "$FOUND" -ne 1 ]
then
	echo ""
	echo "**> ERROR **"
        echo "Client ID $CLIENT not found in database."
	echo ""
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

${SHELL_DIR}/accum01cnv.sh -i ${FILE_NAME}
RETVAL="$?"

exit ${RETVAL}
