#!/bin/ksh
#
# Program Name	: ldmddb-full.sh
# Description   : Medispan Tape Load for Full file request
# Author	: Linda S. Jefferis
# Date		: 01/31/2000
# Modifications : 10/24/2005 - Changes for Linux  (LSJ)
#		: 11/30/2005 - Changes for new system names  (LSJ)
#
# Variables Used:
PROD_MACHINE="rook"
PROD_PATH="/usr/lnk/medispan/MDDB"
TAPE_DRIVE=/opt/cdrom
LOAD_PATH=/usr/lnk/medispan/MDDB
TAPE_PATH="/opt/cdrom/mddb/usaeng/db"
#CONV_PROG="/usr/local/bin/char_repl"
MOUNT_PROG="/usr/local/bin/mountcd"
TPFILE_1="gpiexp"
TPFILE_2="gppc"
TPFILE_3="gppcmod"
TPFILE_4="gprr"
TPFILE_5="modifier"
TPFILE_6="mddb"
FILE_1="MSTCRF"
FILE_2="GPPC"
FILE_3="NDCMODIFIER"
FILE_4="GPPCPRICE"
FILE_5="MODIFIER"
FILE_6="DRUG000TAP"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ldmddb-full.sh 

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
	   echo "Mount of CD unsuccessful - exiting script"
	   exit 1
	fi
}

#
# Listing of files
get_listing()
{
	echo "Creating Listing of files on the CD"
	ls -l ${TAPE_PATH} | lp
}

#
# Load files from CD
get_files()
{
	echo "Getting files from CD"
	cp ${TAPE_PATH}/${TPFILE_1} ${LOAD_PATH}/${FILE_1}
	cp ${TAPE_PATH}/${TPFILE_2} ${LOAD_PATH}/${FILE_2}
	cp ${TAPE_PATH}/${TPFILE_3} ${LOAD_PATH}/${FILE_3}
	cp ${TAPE_PATH}/${TPFILE_4} ${LOAD_PATH}/${FILE_4}
	cp ${TAPE_PATH}/${TPFILE_5} ${LOAD_PATH}/${FILE_5}
	cp ${TAPE_PATH}/${TPFILE_6} ${LOAD_PATH}/${FILE_6}
	cd ${LOAD_PATH}
}

#
# Put files on production machine
put_files()
{
	echo "Putting files to "${PROD_MACHINE}
	scp ${LOAD_PATH}/${FILE_1} ${PROD_MACHINE}:${PROD_PATH}
	scp ${LOAD_PATH}/${FILE_2} ${PROD_MACHINE}:${PROD_PATH}
	scp ${LOAD_PATH}/${FILE_3} ${PROD_MACHINE}:${PROD_PATH}
	scp ${LOAD_PATH}/${FILE_4} ${PROD_MACHINE}:${PROD_PATH}
	scp ${LOAD_PATH}/${FILE_5} ${PROD_MACHINE}:${PROD_PATH}
	scp ${LOAD_PATH}/${FILE_6} ${PROD_MACHINE}:${PROD_PATH}
}

#
# Unmount CD
unmount_cd()
{
	echo "Unmounting CD"
        ${MOUNT_PROG} -u
        if test $? -ne 0 
        then
           echo "The unmount of the CD was unsuccessful - exiting script"
	   echo "You will not be able remove the CD until it has been unmounted"
	   echo "Please see your supervisor"
           exit 1
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

unmount_cd

date

exit 0
