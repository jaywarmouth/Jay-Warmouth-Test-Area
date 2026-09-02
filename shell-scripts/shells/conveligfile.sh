#!/bin/sh
#
# Program Name  : conveligfile.sh
# Description   : Elig file conversion to cardh29 format
#                
#
# Variables Used:
SHELL_DIR=/usr/lnk/shell
CONFIG_FILE="/usr/lnk/elig_in/elig.cfg"
#CONFIG_FILE="/media/test/TC05/change_output/elig.cfg"
CR="
"
FILE_NAME="null"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conveligfile.sh [file name] 
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
case ${ELIG_TYPE} in
  "1")
	${SHELL_DIR}/car2906cnv.sh -i ${FILE_NAME}
	RETVAL=$?
	;;
  "2")
	${SHELL_DIR}/cardhx12.sh -f ${FILE_NAME}
	RETVAL=$?
	;;
  "3")
	${SHELL_DIR}/crdxls01.sh -f ${FILE_NAME}
	RETVAL=$?
	;;
  "8")
	${SHELL_DIR}/crdxls01.sh -p -f ${FILE_NAME}
	RETVAL=$?
	;;
  *) 
	echo "Invalid ELIG_TYPE, check clientID record in elig.cfg file"
	RETVAL=99
	;;
esac

exit ${RETVAL}
