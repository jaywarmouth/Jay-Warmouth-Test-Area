#!/bin/ksh
#
# Program Name	: ldmddb-suppname.sh
# Description   : Medispan Tape Load 
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on zip filename.
# Author	: Linda S. Jefferis
# Date		: 09/26/2008
# Modifications :
#		: 04/16/2010 - Changes for moving zip file directly from mspan-ftp area
#		: 10/03/2010 - Added scp to dev20
#		: 08/05/2011 - Removed scp to dev20
#		: 07/26/2013 - Changes for switch to download of files.
#
# Variables Used:
CURR_DATE=`date +%m/%d/%Y`
LOG="/tmp/medispan-suppname.log"
PROD_SYS="prod10"
PROD_PATH="/usr/lnk/MDDB"
LOAD_PATH=/usr/lnk/MDDB
TAPE_PATH="/usr/lnk/shares/ftp-tmp"
TPFILE_1="medndc"
TPFILE_2="medname"
TPFILE_3="medval"
FILE_1="MEDNDCTAP"
FILE_2="MEDNAMETAP"
FILE_3="MEDVALTAP"
UNZIP_PROG="/usr/bin/unzip -L"
MAIL_PROG="/bin/mail"
MAIL_SUBJ="Weekly Medispan-SUPPNAME"
MAIL_OPER="operations@pdmi.com benefits@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ldmddb-suppname.sh 

ENDOFUSAGE
  exit 1
}

#
# Set zip filename and move to local directory
copy_file()
{
	ZIP_FILE="suppname_0_0_wk_standard_1.0_u_${DATE}.zip"
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
	${UNZIP_PROG} -d ${LOAD_PATH} ${TAPE_PATH}/${ZIP_FILE} ${TPFILE_1} ${TPFILE_2} ${TPFILE_3} 
	cp ${LOAD_PATH}/${TPFILE_1} ${LOAD_PATH}/${FILE_1}
	cp ${LOAD_PATH}/${TPFILE_2} ${LOAD_PATH}/${FILE_2}
	cp ${LOAD_PATH}/${TPFILE_3} ${LOAD_PATH}/${FILE_3}
	chmod 664 ${LOAD_PATH}/${FILE_1}
	chmod 664 ${LOAD_PATH}/${FILE_2}
	chmod 664 ${LOAD_PATH}/${FILE_3}
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
}

# Create record count listing
create_list()
{
	echo "Creating Listing of files in zip file"
        ${UNZIP_PROG} -v ${TAPE_PATH}/${ZIP_FILE} ${TPFILE_1} ${TPFILE_2} ${TPFILE_3} > ${LOG}
	echo "" >> ${LOG}
	echo "" >> ${LOG}
	echo "" >> ${LOG}
	echo ""
	echo "Creating Record Count Listing"
	echo "SUPPNAME RECORD COUNT LISTING for ${CURR_DATE}" >> ${LOG}
	echo "" >> ${LOG}
	echo "" >> ${LOG}
	echo "FILES ON SYSTEM" >> ${LOG}
	echo "" >> ${LOG}
	echo "#Records Filename" >> ${LOG}
	cd ${LOAD_PATH}
	echo "`wc -l ${FILE_1}`" >> ${LOG}
	echo "`wc -l ${FILE_2}`" >> ${LOG}
	echo "`wc -l ${FILE_3}`" >> ${LOG}
	echo "" >> ${LOG}
	echo "" >> ${LOG}
	echo "FILES FROM MEDISPAN ZIP FILE" >> ${LOG}
	echo "" >> ${LOG}
	echo "#Records Filename" >> ${LOG}
	cd ${LOAD_PATH}
	echo "`wc -l ${TPFILE_1}`" >> ${LOG}
	echo "`wc -l ${TPFILE_2}`" >> ${LOG}
	echo "`wc -l ${TPFILE_3}`" >> ${LOG}
	cat ${LOG} | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_OPER}
}

#
# Remove files
remove_files()
{
	rm ${LOAD_PATH}/${TPFILE_1}
	rm ${LOAD_PATH}/${TPFILE_2}
	rm ${LOAD_PATH}/${TPFILE_3}
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

copy_file

echo "Medispan-SUPPNAME File Load"
date

rm -f ${LOAD_PATH}/${FILE_1}
rm -f ${LOAD_PATH}/${FILE_2}
rm -f ${LOAD_PATH}/${FILE_3}

get_files

put_files

create_list

remove_files

date

exit 0
