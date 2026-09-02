#!/bin/ksh
#
# Program Name	: clms_vhi.sh
# Description	: Procedure to setup claims files for D2Hawkeye. 
#		  Command Line Arguments:
#		  -p <mmccyy>  M/E date
# Author	: Linda S. Jefferis
# Date		: 03/28/2006
# Modifications : 04/24/2006 - Addition of MHS (spo0451) file. 
#		: 06/14/2006 - Separated each file to own zip file  (LSJ)
#		: 03/29/2007 - Added files for Capital Tire (CAP) (497)
#		: 04/26/2007 - Added files for spo#346 (PLUM)
#		: 03/13/2008 - Added logic for spo0534 file (HYL)  (LSJ)
#		: 05/07/2008 - Added logic for spo0527 file (MMH)  (LSJ)
#		: 09/08/2008 - Removed test for TAPE_FILE  (LSJ)
#		: 02/26/2009 - Changed email logic  (LSJ)
#		: 04/03/2009 - Added logic for QCP file  (LSJ)
#		: 06/22/2009 - Removed logic for Capital Tire file (#4)  (LSJ)
#		: 11/12/2009 - Changed logic for new vhi-ftp location  (LSJ)
#		: 01/04/2010 - Added logic for 595_PortHuron file  (LSJ)
#		: 02/24/2010 - Changed 595 logic to NCMC(602)  (LSJ)
#		: 03/09/2010 - Removed termed 534 and 527 logic  (LSJ)
#		: 11/03/2011 - Remove logic for QCP
#		: 12/30/2011 - Changes for D.0 file names
#		: 02/17/2012 - Added CONV_PROG logic
#		: 05/21/2014 - Removed logic for SSIN and NCMC files  (LSJ)
#		: 11/4/2014 - Remove logic for "MHS" and "PLUM" (LSJ TT #12283-1)
#		: 10/27/2016 - Remove invalid datamgr@d2hawkeye.com address.
#		: 10/31/2016 - TT13915-39 email address update.
#	
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE_1="???CL109D0-M-D2H"
LOG_FILE_1="???CL109D0-M-D2HTEXT"
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
MAIL_TO="vendor@verscend.com"
MAIL_CC="operations@pdmi.com"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="300"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="VHI"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_vhi.sh -p <m/e date>
	<m/e date> is month ending date in mmccyy format  (required)

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
# Split out m/e date
conv_date()
{
        MON=`echo ${PE_DATE} | cut -c1-2`
        YEAR=`echo ${PE_DATE} | cut -c3-6`
}



#
# Set Filenames
set_filenames()
{
	CLM_FILE_1="medben${PE_DATE}.txt"
	ZIP_FILE_1="medben${PE_DATE}.zip"
	NEW_LOG_1="medben_totals.txt"
}

#
rename_files()
{
	${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE_1} ${TMP_LOC}/${CLM_FILE_1}
	cp ${FILE_LOC}/${LOG_FILE_1} ${TMP_LOC}/${NEW_LOG_1}
}

#
# Zip files
zip_files()
{
	${ZIP_PROG} -mj ${TMP_LOC}/${ZIP_FILE_1} ${TMP_LOC}/${CLM_FILE_1} ${TMP_LOC}/${NEW_LOG_1}
}

#
# Copy files
copy_files()
{
	${TR_PROG} ${TR_ID} ${TMP_LOC}/${ZIP_FILE_1}
	if test $? -ne 0
	then
		echo "*-> Transfer of file failed"
                clean_up
                exit 1
        fi
	echo "The monthly files for ${MON}/${YEAR} are now available." | ${MAIL_PROG} -s "VERISK HEALTH MONTHLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
}

#
# Cleanup
clean_up()
{
	rm ${TMP_LOC}/${ZIP_FILE_1}
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
	conv_date
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
echo "--> Zipping current files..."
echo

zip_files

echo 
echo "--> Transferring files..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
