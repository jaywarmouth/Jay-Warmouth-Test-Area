#!/bin/ksh
#
# Program Name	: cla55_rbextract_pay.sh
# Description	: Runs procedure to do an extract on the CLAIM55MAS file
# Author	: Linda S. Jefferis
# Date		: 05/18/2000
# Modifications : 05/15/2002 - Changes for no longer updating Redbrick(Bigred) 
#		: 09/20/2007 - Added logic to check if the EXTRACT_FILE is created okay.  (LSJ)
#               : 09/08/2008 - Logic to copy file between Husk and Firefly  (LSJ)
#		: 01/15/2010 - COLO conversion changes  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_PATH="/usr/lnk/wh"
S1_FILE_PATH="/usr/pdm/sqlimports/misc"
FLEX="/usr/lnk/flexgen"
EXTRACT_FILE="CLAIM55-P"
SERVER="`/bin/hostname -s`"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cla55_rbextract_pay.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

case ${SERVER} in
  "husk")
        REMOTE_SYS="prod11"
        ;;
esac

rm -f ${FILE_PATH}/${EXTRACT_FILE}
cd ${FLEX}
echo "--> Extracting ${EXTRACT_FILE} - cla55rb2_pay.cs"
date
cla55rb2_pay.cs
if ! test -s ${FILE_PATH}/${EXTRACT_FILE}
then
        echo "-*> The extract file, ${FILE_PATH}/${EXTRACT_FILE}, is empty or did not get created."
        exit 1
else
	scp ${FILE_PATH}/${EXTRACT_FILE} ${REMOTE_SYS}:${S1_FILE_PATH}
fi

date

exit 0
