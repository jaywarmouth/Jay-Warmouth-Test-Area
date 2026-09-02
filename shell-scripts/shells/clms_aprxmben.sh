#!/bin/sh
#
# Program Name	: clms_aprxmben.sh
# Description	: Procedure to setup claims file for ApproRx (105-MBEN)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
DEST_LOC=/usr/lnk/wt/oper-wt/sftpexport/APRXMBEN/FromPDMI
TAPE_FILE="????CLMRTRM"
LOG_FILE="????RMTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="1024"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="bmccune@medben.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_aprxmben.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


# Convert input date
conv_date()
{
        MO=`echo ${IN_DATE} | cut -c1-2`
        DAY=`echo ${IN_DATE} | cut -c3-4`
        YR=`echo ${IN_DATE} | cut -c5-8`
        PE_DATE=${YR}${MO}${DAY}
}

# Set File names
set_filenames()
{
	CLM_FILE="Refreshclms-APRXMBEN-${PE_DATE}.txt"
}
	

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_LEN} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	else
	  echo "-*> ${TAPE_FILE} file does not exist..."
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
		rm ${TMP_LOC}/${CLM_FILE}
		exit 99
	   fi
	   cat ${FILE_LOC}/${LOG_FILE} | ${MAIL_PROG} -s "APRX-MBEN WEEKLY CLAIMS FILES NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
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
	IN_DATE=$1
        conv_date
	;;
  esac
  shift
done

set_filenames

echo
echo "--> Renaming file..."
echo

rename_files

echo 
echo "--> Copying file ..."
echo

copy_files

echo "-=> Finished."

exit 0
