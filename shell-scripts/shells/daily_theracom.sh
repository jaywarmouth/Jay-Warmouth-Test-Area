#!/bin/ksh
#
# Program Name	: daily_theracom.sh
# Description	: Files for Theracom (sys152)
# Author	: Linda S. Jefferis
# Date		: 12/28/2012
# Modifications : 03/08/2013 - Added logic to transfer a zero byte file if TAP_FILE isn't created.
#		: 05/17/2013 - Added LVID/Vidara file logic
#		: 03/12/2015 - Removed logic for termed VTX(Incivek-2331) file.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/tapes"
EXTRACT_FILE_1="CL111DAYD0-P-LVID"
EXTRACT_FILE_3="CL111DAYD0-P-ACR"
NETWRK_DIR="/usr/lnk/shares/ftp-tmp"
ZIP_PROG="/usr/bin/zip"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="THC"
ARCH_DIR="/usr/lnk/rptarch/daily"
REMOTE_SYS="husk"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="500"
TMP_LOC=/tmp

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_theracom.sh 

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
# Rename file
rename_file()
{
	${CONV_PROG} ${REC_LEN} ${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	scp ${TMP_LOC}/${CLM_FILE} ${REMOTE_SYS}:${NETWRK_DIR}
	if test $? -ne 0
        then
            echo "*-> SCP of file failed"
            clean_up
	else
	    transfer_file
        fi
}
	
# Transfer_file
transfer_file()
{
	ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${NETWRK_DIR}/${CLM_FILE}"
	if test $? -ne 0
        then
            echo "*-> Transfer of file failed"
        fi
	clean_up
}

# Cleanup
clean_up()
{
	ssh -q ${REMOTE_SYS} "mv ${NETWRK_DIR}/${CLM_FILE} ${ARCH_DIR}"
	if test $? -ne 0
             then
		echo "*-> File Archive failed"
	else
	     rm ${TAPE_FILE}
	     rm ${TMP_LOC}/${CLM_FILE}
	fi
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

umask 002

if test -s ${FILE_PATH}/???${EXTRACT_FILE_1}
then
   echo "      --> Moving ${EXTRACT_FILE_1} to Network Directory"
   TAPE_FILE=${FILE_PATH}/???${EXTRACT_FILE_1}
   CLM_FILE="dailyTHCVidara-clms${DATE}.txt"
   rename_file
   date
else
   echo "-*> NO Vidara(138) FILE TO PROCESS"
   echo "-*> Creating blank file to transfer"
   CLM_FILE="dailyTHCVidara-clms${DATE}.txt"
   touch ${TMP_LOC}/${CLM_FILE}
   scp ${TMP_LOC}/${CLM_FILE} ${REMOTE_SYS}:${NETWRK_DIR}
   transfer_file
fi

if test -s ${FILE_PATH}/???${EXTRACT_FILE_3}
then
   echo "      --> Moving ${EXTRACT_FILE_3} to Network Directory"
   TAPE_FILE=${FILE_PATH}/???${EXTRACT_FILE_3}
   CLM_FILE="dailyTHCAmpyra-clms${DATE}.txt"
   rename_file
   date
else
   echo "-*> NO AMPYRA(2332) FILE TO PROCESS"
   echo "-*> Creating blank file to transfer"
   CLM_FILE="dailyTHCAmpyra-clms${DATE}.txt"
   touch ${TMP_LOC}/${CLM_FILE}
   scp ${TMP_LOC}/${CLM_FILE} ${REMOTE_SYS}:${NETWRK_DIR}
   transfer_file
fi

exit 0
