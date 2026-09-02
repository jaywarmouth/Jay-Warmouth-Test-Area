#!/bin/sh
#
# Program Name	: clms_lbrx_pts.sh.sh
# Description	: Procedure to setup claims file for LBRX-PTS (sys0174/spo1573)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 07/10/2015
#Modifications	: 09/22/2015 - change naming convention for tapes files from ???CL111D0-T-LBRX to ????CL111D0-T-PTS (DME) 
#		: 10/02/2015 - changed ????CL111D0-T-PTS to ???CL111D0-T-PTS (LSJ)
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
DEST_LOC=/usr/lnk/wt/pst-wt/FromPDMI
TAPE_FILE="???CL111D0-T-PTS"
LOG_FILE="???CL111D0-T-PTSTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="500"
MAIL_PROG="/usr/bin/mutt"
MAIL_CC="operations@pdmi.com"
MAIL_TO="tuckerh@ptsmn.org patd@ptsmn.org"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_lbrx_pts.sh.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


# Date conversion
date_conv()
{
	MON=`echo ${PE_DATE} | cut -c1-2`
	DAY=`echo ${PE_DATE} | cut -c3-4`
	YR=`echo ${PE_DATE} | cut -c5-8`
	FIDATE=${YR}${MON}${DAY}
}

# Set File names
set_filenames()
{
	CLM_FILE="Refreshclms_LBRXPTS_${FIDATE}.txt"
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
	   mv ${TMP_LOC}/${CLM_FILE} ${DEST_LOC}
	   if test $? -ne 0
	     then
		echo "*-> Transfer of file failed"
		clean_up
		exit 1
	   fi
	   cat ${FILE_LOC}/${LOG_FILE} | ${MAIL_PROG} -s "Pipe Trades Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "--*> File not copied..."
	fi
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
	date_conv
	;;
  esac
  shift
done


set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo 
echo "--> Copying file ..."
echo

copy_files


echo "-=> Finished."

exit 0
