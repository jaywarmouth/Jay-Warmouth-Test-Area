#!/bin/ksh
#
# Program Name	: clms_ihs.sh
# Description	: Procedure to setup claims file for IHS (sys107)
#		  This is run on Rook
#		  Command Line Arguments:
#		  -p <ccyymmdd>  current date
# Author	: Linda S. Jefferis
# Date		: 04/02/2008
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109IHS-W-IHS"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="300"
ZIP_PROG="/usr/bin/zip"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="TPAB"
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_ihs.sh -p <current date - mmddccyy>

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
	ZIP_FILE="clms_pdmi${DATE}.zip"
	CLM_FILE="clms_pdmi${DATE}.txt"
}


#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_LEN} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  echo "-*> The IHS file was not ftp'ed to TPAB"
	  exit 1
	fi
}

#
# Zip files
zip_files()
{
        ${ZIP_PROG} -mj ${TMP_LOC}/${ZIP_FILE} ${TMP_LOC}/${CLM_FILE} 
}

#
# Copy files
copy_files()
{
	if test -f ${TMP_LOC}/${ZIP_FILE}
	then
	   scp -q ${TMP_LOC}/${ZIP_FILE} ${REMOTE_SYS}:${REMOTE_DIR}
	   if test $? -eq 0
	   then
	   	ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${ZIP_FILE}"
	   	if test $? -ne 0
            	then
                	echo "*-> Transfer of file failed"
                	clean_up
                	exit 1
           	fi
	   else
		echo "--*> scp of ${ZIP_FILE} failed"
	   fi
	else
	   echo "--*> ${TMP_LOC}/${ZIP_FILE} does not exist, unable to transfer file..."
	fi
}

# Cleanup
clean_up()
{
	rm -f ${TMP_LOC}/${ZIP_FILE}
	ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${ZIP_FILE}"
}



#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

zip_files

echo 
echo "--> Transferring file to ${TR_ID}..."
echo

copy_files

echo
echo "--> Doing cleanup..."
clean_up


echo "-=> Finished."

exit 0
