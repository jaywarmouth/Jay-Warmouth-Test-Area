#!/bin/ksh
#
# Program Name	: ldmddb-wkly.sh
# Description   : Medispan Tape Load 
# Author	: Linda S. Jefferis
# Date		: 06/17/96
# Modifications : 03/04/99 - CD load instead of 8MM tape load  (LSJ)
#		: 12/02/99 - Removed procedure to remove \n from files  (LSJ)
#		: 02//1/2000 - Added record count listing for Benefits  (LSJ)
#		: 12/14/2000 - Added more error checking and remove_files (LSJ)
#		: 01/02/2001 - Fixed unmount_cd problem - added cd ${LOAD_PATH}  (LSJ)
#		: 05/21/2002 - Fixes for version 2 files  (LSJ)
#		: 05/31/2002 - Added load of MDDBERR  (LSJ)
#		: 10/24/2005 _ Changes for Linux  (LSJ)
#		: 11/30/2005 - Changes for new system names  (LSJ)
#
# Variables Used:
DATE=`date +%m/%d/%Y`
LOG="/tmp/medispan.log"
CD_LIST="/tmp/cd-list"
PROD_MACHINE="rook"
PROD_PATH="/usr/lnk/MDDB"
TAPE_DRIVE=/opt/cdrom
LOAD_PATH=/usr/lnk/MDDB
TAPE_PATH="/opt/cdrom/mddbv2/usaeng/upd"
MOUNT_PROG="/usr/local/bin/mountcd"
TPFILE_1="mddbtcrf"
TPFILE_2="mddbgppc"
TPFILE_3="mddbnmod"
TPFILE_4="mddbgprr"
TPFILE_5="mddbmod"
TPFILE_6="mddb"
TPFILE_7="mddberr"
FILE_1="MDDBTCRF"
FILE_2="MDDBGPPC"
FILE_3="MDDBNMOD"
FILE_4="MDDBGPRR"
FILE_5="MDDBMOD"
FILE_6="DRUG000TAP"
FILE_7="MDDBERR"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ldmddb-wkly.sh 

ENDOFUSAGE
  exit 1
}

#
# Mount CD
mount_cd()
{
	echo "Mounting CD"
	${MOUNT_PROG}	
	if test $? -ne 0 
	then
	   echo ""
	   echo "-*> MOUNT OF CD WAS UNSUCCESSFUL -- EXITING SCRIPT"
 	   echo "-*> PLEASE SEE SUPERVISOR"
	   exit 1
	else
	   echo ""
	   echo "-=> CD is mounted"
	fi
}

#
# Listing of files
get_listing()
{
	echo "Creating Listing of files on the CD"
	ls -l ${TAPE_PATH} > ${CD_LIST}
	if test $? -ne 0
	then
	   echo ""
	   echo "-*> ${TAPE_PATH} IS INCORRECT -- EXITING SCRIPT"
	   echo "-*> PLEASE SEE SUPERVISOR"
	   unmount_cd
	   exit 1
	else
	   lp ${CD_LIST}
	   echo ""
	   echo "-=> CD listing created"
	   rm ${CD_LIST}
	fi
}

#
# Load files from CD
get_files()
{
	echo ""
	echo "--> Getting files from CD"
	cp ${TAPE_PATH}/${TPFILE_1} ${LOAD_PATH}/${FILE_1}
	chmod 664 ${LOAD_PATH}/${FILE_1}
	cp ${TAPE_PATH}/${TPFILE_2} ${LOAD_PATH}/${FILE_2}
	chmod 664 ${LOAD_PATH}/${FILE_2}
	cp ${TAPE_PATH}/${TPFILE_3} ${LOAD_PATH}/${FILE_3}
	chmod 664 ${LOAD_PATH}/${FILE_3}
	cp ${TAPE_PATH}/${TPFILE_4} ${LOAD_PATH}/${FILE_4}
	chmod 664 ${LOAD_PATH}/${FILE_4}
	cp ${TAPE_PATH}/${TPFILE_5} ${LOAD_PATH}/${FILE_5}
	chmod 664 ${LOAD_PATH}/${FILE_5}
	cp ${TAPE_PATH}/${TPFILE_6} ${LOAD_PATH}/${FILE_6}
	chmod 664 ${LOAD_PATH}/${FILE_6}
	cd ${LOAD_PATH}
	cp ${TAPE_PATH}/${TPFILE_7} ${LOAD_PATH}/${FILE_7}
	chmod 664 ${LOAD_PATH}/${FILE_7}
	cd ${LOAD_PATH}
}

#
# Put files on production machine
put_files()
{
	echo ""
	echo "--> Putting files to "${PROD_MACHINE}
	scp ${LOAD_PATH}/${FILE_1} ${PROD_MACHINE}:${PROD_PATH}
	if test $? -ne 0
	then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
	   echo "-*> PLEASE NOTIFY SUPERVISOR"
	   unmount_cd
	   exit 1
	else
	   echo ""
	   echo "-=> scp to ${PROD_MACHINE} was successful"
	fi
	scp ${LOAD_PATH}/${FILE_2} ${PROD_MACHINE}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
	   unmount_cd
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_MACHINE} was successful"
        fi
	scp ${LOAD_PATH}/${FILE_3} ${PROD_MACHINE}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
	   unmount_cd
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_MACHINE} was successful"
        fi
	scp ${LOAD_PATH}/${FILE_4} ${PROD_MACHINE}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
	   unmount_cd
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_MACHINE} was successful"
        fi
	scp ${LOAD_PATH}/${FILE_5} ${PROD_MACHINE}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
	   unmount_cd
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_MACHINE} was successful"
        fi
	scp ${LOAD_PATH}/${FILE_6} ${PROD_MACHINE}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
	   unmount_cd
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_MACHINE} was successful"
        fi
	scp ${LOAD_PATH}/${FILE_7} ${PROD_MACHINE}:${PROD_PATH}
	if test $? -ne 0
        then
	   echo ""
	   echo "-*> SCP DID NOT WORK -- EXITING SCRIPT"
           echo "-*> PLEASE NOTIFY SUPERVISOR"
	   unmount_cd
           exit 1
        else
	   echo ""
           echo "-=> scp to ${PROD_MACHINE} was successful"
        fi
}

# Create record count listing
create_list()
{
	echo ""
	echo "Creating Record Count Listing"
	echo "MEDISPAN RECORD COUNT LISTING for ${DATE}" > ${LOG}
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
	echo "FILES ON CD" >> ${LOG}
	echo "" >> ${LOG}
	echo "#Records Filename" >> ${LOG}
	cd ${TAPE_PATH}
	echo "`wc -l ${TPFILE_1}`" >> ${LOG}
	echo "`wc -l ${TPFILE_2}`" >> ${LOG}
	echo "`wc -l ${TPFILE_3}`" >> ${LOG}
	echo "`wc -l ${TPFILE_4}`" >> ${LOG}
	echo "`wc -l ${TPFILE_5}`" >> ${LOG}
	echo "`wc -l ${TPFILE_6}`" >> ${LOG}
	echo "`wc -l ${TPFILE_7}`" >> ${LOG}
	lp ${LOG}
}

#
# Remove files
remove_files()
{
	rm ${LOAD_PATH}/${FILE_1}
	rm ${LOAD_PATH}/${FILE_2}
	rm ${LOAD_PATH}/${FILE_3}
	rm ${LOAD_PATH}/${FILE_4}
	rm ${LOAD_PATH}/${FILE_5}
	rm ${LOAD_PATH}/${FILE_6}
	rm ${LOAD_PATH}/${FILE_7}
}

#
# Unmount CD
unmount_cd()
{
	echo ""
	echo "--> Unmounting CD"
	cd ${LOAD_PATH}
        ${MOUNT_PROG} -u
        if test $? -ne 0 
        then
	   echo ""
           echo "-*> The unmount of the CD was unsuccessful - exiting script"
	   echo "-*> You will not be able remove the CD until it has been unmounted"
	   echo "-*> Please see your supervisor"
           exit 1
	else
	   echo ""
	   echo "--> The CD is unmounted"
        fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

echo "Medispan Tape Load"
date

mount_cd

get_listing

get_files

put_files

create_list

#remove_files

unmount_cd

date

exit 0
