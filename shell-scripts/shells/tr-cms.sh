#!/bin/ksh
#
# Program Name	: tr-cms.sh
# Description	: Prepare CMS files for transfer to SummaCare
# Author	: Linda Jefferis
# Date		: 11/05/2004
# Modifications : 10/24/2005 - Changes for Linux  (LSJ)
#		: 12/19/2005 - Changed MAIL_TO to computers@pdmi.com  (LSJ)
#
# Variables Used:
DATE=`date`
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
DEST_LOC=firefly:/usr/lnk/wt/suma-wt	 	# Location of file for pickup
FILE1_FOUND=0					# file flag
FILE2_FOUND=0					# file flag
TAPE_FILE_1=???CMS01SUMA.1			# Original file
TAPE_FILE_2=D3660N-PH04-900			# Original file
NEW_FILE_1=D366Op.txt
NEW_FILE_2=D366On.txt
ZIP_FILE_1=D366Op.zip				# zip filename
ZIP_FILE_2=D366On.zip				# zip filename
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
CONV_PROG_1="/usr/local/bin/char_repl"
CONV_PROG_2="/usr/local/bin/addlf"
REC_SIZE_1=28
REC_SIZE_2=44


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr-cms.sh 

ENDOFUSAGE
  exit 1
}

remove_file()
{ 
   cd ${NEW_FLOC}
   if test -f ${FNAME}
   then
     rm ${FNAME}
   fi
}

rename_files()
{  cd ${FILE_LOC}

   if test -f ${TAPE_FILE_1}
   then
     FILE1_FOUND=1
     cat ${TAPE_FILE_1} | ${CONV_PROG_1} 10 -1 > ${NEW_FLOC}/tmp-file
     ${CONV_PROG_2} ${REC_SIZE_1} ${NEW_FLOC}/tmp-file ${NEW_FLOC}/${NEW_FILE_1}  
     rm -f ${FILE_LOC}/${TAPE_FILE_1}
   else
     echo "-*> ${TAPE_FILE_1} does not exist..."
   fi 
   if test -f ${TAPE_FILE_2}
   then
     FILE2_FOUND=1
     mv ${TAPE_FILE_2} ${NEW_FLOC}/${NEW_FILE_2}
   else
     echo "-*> ${TAPE_FILE_2} does not exist..."
   fi

}

zip_files()
{  cd ${NEW_FLOC}

   if [ ${FILE1_FOUND} = 1 ]
   then
     ${ZIP_PROG} -m ${ZIP_FILE_1} ${NEW_FILE_1}
   fi
   if [ ${FILE2_FOUND} = 1 ]
   then
     ${ZIP_PROG} -m ${ZIP_FILE_2} ${NEW_FILE_2} 
   fi
}

copy_files()
{
   cd ${NEW_FLOC}

   if test -f ${ZIP_FILE_1}
   then
     scp ${ZIP_FILE_1} ${DEST_LOC}
   else 
     echo "-*>  ${ZIP_FILE_1} was not copied to ${DEST_LOC}"
   fi
   if test -f ${ZIP_FILE_2}
   then
     scp ${ZIP_FILE_2} ${DEST_LOC}
   else
     echo "-*>  ${ZIP_FILE_2} was not copied to ${DEST_LOC}"
   fi
   echo "The weekly CMS files, ${ZIP_FILE_1} and ${ZIP_FILE_2}, are available for downloading." | ${MAIL_PROG} -s "Weekly SummaCare/CMS Data" ${MAIL_TO}
   
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${ZIP_FILE_1}
   remove_file
   FNAME=${ZIP_FILE_2}
   remove_file
   FNAME=tmp-file
   remove_file
}

#
# Main routine
#

umask 002

date +%T

echo 
echo "--> Renaming files for archival..."
echo

rename_files

echo
echo "--> Zipping current files..."
echo

zip_files

echo 
echo "--> Copying files to raven..."

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up
 
echo "-=> Finished."

date +%T

exit 0
