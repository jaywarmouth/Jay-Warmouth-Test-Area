#!/bin/ksh
#
# Program Name	: daily_LBRXhealthsmart.sh
# Description	: Procedure to setup claims file for LBRX-Healthsmart
#		  Command Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 08/05/2014
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL111DAYD0-P-HSMT"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="500"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="HSBS"
DATE=`date -d "yesterday 0800" +%Y%m%d`
ARCH_DIR="/usr/lnk/rptarch/daily"
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_LBRXhealthsmart.sh 

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

# Set File names
set_filenames()
{
	CLM_FILE="Dailyclms-LBRXHealthsmart-${DATE}.txt"
}
	

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_LEN} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Copy files
copy_files()
{
	if test -f ${TMP_LOC}/${CLM_FILE}
        then
           scp ${TMP_LOC}/${CLM_FILE} ${REMOTE_SYS}:${REMOTE_DIR}
           if test $? -ne 0
             then
                echo "*-> SCP of file failed"
                rm ${TMP_LOC}/${CLM_FILE}
                exit 1
           fi
           ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${CLM_FILE}"
           if test $? -ne 0
             then
                echo "*-> Transfer of file failed"
                clean_up
                exit 1
           fi
        else
           echo "--*> File, ${TMP_LOC}/${CLM_FILE}, was not found..."
        fi
}

#
# Cleanup
clean_up()
{
	rm ${FILE_LOC}/${TAPE_FILE}
        ssh -q ${REMOTE_SYS} "mv ${REMOTE_DIR}/${CLM_FILE} ${ARCH_DIR}"
        if test $? -ne 0
        then
            echo "*-> Archive of file failed"
            exit 1
        else
            rm ${TMP_LOC}/${CLM_FILE}
        fi
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo 
echo "--> Copying file ..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
