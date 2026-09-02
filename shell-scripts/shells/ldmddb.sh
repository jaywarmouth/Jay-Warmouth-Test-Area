#!/bin/ksh
#
# Program Name	: ldmddb-wkly.sh
# Description   : Medispan Tape Load 
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on zip filename.
# Author	: Linda S. Jefferis
# Date		: 06/17/96
# Modifications : 03/04/99 - CD load instead of 8MM tape load  (LSJ)
#		: 12/02/99 - Removed procedure to remove \n from files  (LSJ)
#		: 02//1/2000 - Added record count listing for Benefits  (LSJ)
#		: 12/14/2000 - Added more error checking and remove_files (LSJ)
#		: 01/02/2001 - Fixed unmount_cd problem - added cd ${LOAD_PATH}  (LSJ)
#		: 05/21/2002 - Fixes for version 2 files  (LSJ)
#		: 05/31/2002 - Added load of MDDBERR  (LSJ)
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 11/30/2005 - Changes for new system names  (LSJ)
#		: 01/02/2006 - Changed lp to emails  (LSJ)
#		: 04/15/2008 - Changes for switch from CD to getting files FTPedto us  (LSJ)
#		: 04/25/2008 - Added CURR_DATE variable for emails  (LSJ)
#		: 04/16/2010 - Changes for copying directly from mspan-ftp
#		: 05/10/2010 - Added move of RXNORMD file
#		: 10/03/2010 - Added scp to dev20 for DBPronto updating
#		: 08/05/2011 - Removed scp to dev20
#		: 07/26/2013 - changes for file location zip file names
#		: 08/15/2013 - changes for V2.5 mddb file(s)
#		: 08/21/2013 - added copy of mddbv2.5 file to sqlimports/misc for 340B  (LSJ)
#		: 12/09/2015 - TT13915-14 
#
# Variables Used:
CURR_DATE=`date +%m/%d/%Y`
LOG="/tmp/medispan.log"
PROD_SYS="prod10"
PROD_PATH="/usr/lnk/MDDB"
LOAD_PATH=/usr/lnk/MDDB
TAPE_PATH="/usr/lnk/shares/ftp-tmp"
TPFILE_1="m25tcrf"
TPFILE_2="m25gppc"
TPFILE_3="m25nmod"
TPFILE_4="m25gprr"
TPFILE_5="m25mod"
TPFILE_6="m25"
TPFILE_7="m25err"
FILE_1="MDDBTCRF"
FILE_2="MDDBGPPC"
FILE_3="MDDBNMOD"
FILE_4="MDDBGPRR"
FILE_5="MDDBMOD"
FILE_6="DRUG000TAP"
FILE_7="MDDBERR"
UNZIP_PROG="/usr/bin/unzip -L"
MAIL_PROG="/bin/mail"
MAIL_SUBJ="Weekly Medispan"
MAIL_OPER="operations@pdmi.com"
MAIL_BENEFITS="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ldmddb.sh 

ENDOFUSAGE
  exit 1
}

#
# Set zip filename 
copy_file()
{
	ZIP_FILE="mddbv2.5_0_0_wk_w-gppc_2.5_u_${DATE}.zip"
	echo "ZIP_FILE=${ZIP_FILE}"
	if ! test -s ${TAPE_PATH}/${ZIP_FILE}
	then
		echo -*> "${TAPE_PATH}/${ZIP_FILE} does not exist."
		echo -*> "Check date entered on the command line."
		exit 1
	fi
}


#
# Move files 
get_files()
{
	echo ""
	echo "--> Unzipping and Moving Files"
	${UNZIP_PROG} -d ${LOAD_PATH} ${TAPE_PATH}/${ZIP_FILE} ${TPFILE_1} ${TPFILE_2} ${TPFILE_3} ${TPFILE_4} ${TPFILE_5} ${TPFILE_6} ${TPFILE_7}
	cp ${LOAD_PATH}/${TPFILE_1} ${LOAD_PATH}/${FILE_1}
	cp ${LOAD_PATH}/${TPFILE_2} ${LOAD_PATH}/${FILE_2}
	cp ${LOAD_PATH}/${TPFILE_3} ${LOAD_PATH}/${FILE_3}
	cp ${LOAD_PATH}/${TPFILE_4} ${LOAD_PATH}/${FILE_4}
	cp ${LOAD_PATH}/${TPFILE_5} ${LOAD_PATH}/${FILE_5}
	cp ${LOAD_PATH}/${TPFILE_6} ${LOAD_PATH}/${FILE_6}
	cp ${LOAD_PATH}/${TPFILE_7} ${LOAD_PATH}/${FILE_7}
	chmod 664 ${LOAD_PATH}/${FILE_1}
	chmod 664 ${LOAD_PATH}/${FILE_2}
	chmod 664 ${LOAD_PATH}/${FILE_3}
	chmod 664 ${LOAD_PATH}/${FILE_4}
	chmod 664 ${LOAD_PATH}/${FILE_5}
	chmod 664 ${LOAD_PATH}/${FILE_6}
	chmod 664 ${LOAD_PATH}/${FILE_7}
}

#
# Put files on production machine
put_files()
{
	echo ""
	echo "--> Putting files to "${PROD_SYS}
	scp -q ${LOAD_PATH}/${FILE_1} ${PROD_SYS}:${PROD_PATH}
	if test $? -ne 0
	then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
	   echo "-*> PLEASE NOTIFY SUPERVISOR"
	   exit 1
	else
	   echo ""
	   echo "-=> scp to ${PROD_SYS} was successful"
	fi
	scp -q ${LOAD_PATH}/${FILE_2} ${PROD_SYS}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_SYS} was successful"
        fi
	scp -q ${LOAD_PATH}/${FILE_3} ${PROD_SYS}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_SYS} was successful"
        fi
	scp -q ${LOAD_PATH}/${FILE_4} ${PROD_SYS}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_SYS} was successful"
        fi
	scp -q ${LOAD_PATH}/${FILE_5} ${PROD_SYS}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_SYS} was successful"
        fi
	scp -q ${LOAD_PATH}/${FILE_6} ${PROD_SYS}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_SYS} was successful"
        fi
	scp -q ${LOAD_PATH}/${FILE_7} ${PROD_SYS}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_SYS} was successful"
        fi
}

# Create record count listing
create_list()
{
	echo "Creating Listing of files in zip file"
	${UNZIP_PROG} -v ${TAPE_PATH}/${ZIP_FILE} ${TPFILE_1} ${TPFILE_2} ${TPFILE_3} ${TPFILE_4} ${TPFILE_5} ${TPFILE_6} ${TPFILE_7} > ${LOG}
	echo "" >> ${LOG}
	echo "" >> ${LOG}
	echo ""
	echo "Creating Record Count Listing"
	echo "MEDISPAN RECORD COUNT LISTING for ${CURR_DATE}" >> ${LOG}
	echo "" >> ${LOG}
	echo "" >> ${LOG}
	echo "FILES ON SYSTEM" >> ${LOG}
	echo "" >> ${LOG}
	echo "#Records Filename" >> ${LOG}
	cd ${LOAD_PATH}
	echo "`wc -l ${FILE_1}`" >> ${LOG}
	echo "`wc -l ${FILE_2}`" >> ${LOG}
	echo "`wc -l ${FILE_3}`" >> ${LOG}
	echo "`wc -l ${FILE_4}`" >> ${LOG}
	echo "`wc -l ${FILE_5}`" >> ${LOG}
	echo "`wc -l ${FILE_6}`" >> ${LOG}
	echo "`wc -l ${FILE_7}`" >> ${LOG}
	echo "" >> ${LOG}
	echo "" >> ${LOG}
	echo "FILES FROM MEDISPAN ZIP FILE" >> ${LOG}
	echo "" >> ${LOG}
	echo "#Records Filename" >> ${LOG}
	cd ${LOAD_PATH}
	echo "`wc -l ${TPFILE_1}`" >> ${LOG}
	echo "`wc -l ${TPFILE_2}`" >> ${LOG}
	echo "`wc -l ${TPFILE_3}`" >> ${LOG}
	echo "`wc -l ${TPFILE_4}`" >> ${LOG}
	echo "`wc -l ${TPFILE_5}`" >> ${LOG}
	echo "`wc -l ${TPFILE_6}`" >> ${LOG}
	echo "`wc -l ${TPFILE_7}`" >> ${LOG}
	cat ${LOG} | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_BENEFITS}
}

#
# Remove files
remove_files()
{
	rm ${LOAD_PATH}/${TPFILE_1}
	rm ${LOAD_PATH}/${TPFILE_2}
	rm ${LOAD_PATH}/${TPFILE_3}
	rm ${LOAD_PATH}/${TPFILE_4}
	rm ${LOAD_PATH}/${TPFILE_5}
	rm ${LOAD_PATH}/${TPFILE_6}
	rm ${LOAD_PATH}/${TPFILE_7}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done


# Copy file and set zip filename
copy_file

echo "Medispan Tape Load"
date

rm -f ${LOAD_PATH}/${FILE_1}
rm -f ${LOAD_PATH}/${FILE_2}
rm -f ${LOAD_PATH}/${FILE_3}
rm -f ${LOAD_PATH}/${FILE_4}
rm -f ${LOAD_PATH}/${FILE_5}
rm -f ${LOAD_PATH}/${FILE_6}
rm -f ${LOAD_PATH}/${FILE_7}

get_files

put_files

create_list

remove_files

date

exit 0
