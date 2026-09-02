#!/bin/sh
#
# Program Name	: clms_ahf_hcrm.sh
# Description	: Procedure to transfer claims data files to HCRM
#		  Command Line Arguments:
#		  -p <mmccyy>  M/E date
# Author	: Linda S. Jefferis
# Date		: 06/28/2013
# Modifications	: 07/17/2013 - Added copy of files to ault-wt and MAIL_TO
#		: 09/03/2013 - Fixed emailing command, it was missing "|"
#		: 01/06/2015 - update email for aultcare-is@aultman.com to @aultcare.com (TT:13915-21; DME)
#		: 01/20/2016 - add jnorris@aultcare.com to notifcations. (TT:13915-21; DME)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="???CL109D0-X-AHF"
MAIL_PROG="/bin/mail"
MAIL_CC="operations@pdmi.com"
MAIL_TO="cwydro@hcrmnet.net jnorris@aultcare.com aultcare-is@aultcare.com"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="300"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
AWK_SCR="/usr/local/pub/claim109d0_splitmastergrp56652.awk"
TR_ID="HCRM"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_ahf_hcrm.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

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
	CLM_FILE="unionhosp-${PE_DATE}.txt"
}


#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
          ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/claim109d0-ahf
	  awk -f ${AWK_SCR} < ${TMP_LOC}/claim109d0-ahf
	  mv ${TMP_LOC}/fileOut.56652 ${DEST_LOC}/${CLM_FILE}
	  rm -f ${TMP_LOC}/claim109d0-ahf
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
		clean_up
		exit 1
	   fi
	   cp ${DEST_LOC}/${CLM_FILE} /usr/lnk/wt/ault-wt
	   echo "The Union Hospital data file for period ending ${PE_DATE}, has been uploaded." | ${MAIL_PROG} -s "HCRM - Notification" -c ${MAIL_CC} ${MAIL_TO}
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
	PE_DATE=$1
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
