#!/bin/sh
#
# Program Name	: clms_qcp_antares.sh
# Description	: Procedure to transfer claim171 QCP claims data file to Antares
#		  Command Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 05/17/2007
# Modifications : 08/17/2007 - commented out the transfer_file and clean-up sections for now until procedure for signing files with secure-transfer is resolved  (LSJ)
#		: 05/06/2008 - put transfer logic back in  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="???CL171-M-QCP"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="ANTARES"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_qcp_antares.sh 

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
# Set Filenames
set_filenames()
{
	CLM_FILE="TP034CL"
}


#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
          cp ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Transfer files
transfer_file()
{
	if test -f ${DEST_LOC}/${CLM_FILE}
	then
	   ${TR_PROG} ${TR_ID} ${DEST_LOC}/${CLM_FILE}
	   if test $? -ne 0
	   then
		echo "*-> Transfer of file failed"
	   fi
	else
	   echo "--*> File not copied..."
	fi
}

#
# Cleanup
clean_up()
{
	rm ${DEST_LOC}/${CLM_FILE}
}

#
# Main routine
#


# Parse environment variables
#parse_env

set_filenames

echo
echo "--> Renaming files for transferring..."
echo

rename_files

echo 
echo "--> Transferring file..."
echo

transfer_file

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
