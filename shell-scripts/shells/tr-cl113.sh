#!/bin/ksh
#
# Program Name	: tr-cl113.sh
# Description	: Prepare week files for transfer to Aultman
# Author	: Linda Jefferis
# Date		: 05/11/2001
# Modifications : 03/25/2002 - Changed DEST_LOC for switch to WEB transfer methos  (LSJ)
#		: 03/29/2002 - Changed /usr/lnk/transfers to /usr/lnk/wt
#		: 09/11/2002 - Added *.des file  (LSJ)
#		: 03/27/2003 - New tape file added  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 09/15/2006 - Addition of AUL file and removing MEDI file  (LSJ)
#		: 11/24/2006 - Added logic back in for MEDI files  (LSJ)
#		: 08/27/2007 - Removed DES logic  (LSJ)
#		: 10/24/2007 - Removed MEDI logic again and removed cp of DES file  (LSJ)
#		: 06/03/2009 - Added file from ault_gt_file.sh process
#		: 06/03/2009 - Removed AUL file logic
#		: 06/05/2009 - Added email logic 
#		: 11/05/2010 - Changes for NEW tweek cycle
#		: 01/10/2011 - Added date input
#		: 01/25/2011 - Added requested email addresses
#		: 02/18/2011 - Added Tlewis@aultcare.com email
#		: 01/10/2014 - Addition of sys0161 logic
#		: 03/17/2014 - Removed logic for MKPL files (this data now included in AHF file as requested by Aultcare)
#
# Variables Used:
DATE=`date +%m%d%Y`
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
DEST_LOC=/usr/lnk/wt/ault-wt		 	# Location of file for pickup
FILE1_FOUND=0					# file flag
FILE2_FOUND=0					# file flag
TAPE_FILE_1=???CL113-X-AHF			# Original file
TAPE_FILE_2=???CL113-X-CAS			# Original file
LOG_FILE_1=???-X-AHFTEXT			# Original log file
LOG_FILE_2=???-X-CASTEXT			# Original log file
NEW_LOG=readme.txt				# new log file name
ZIP_FILE=pdm-clm.zip				# zip filename
ZIP_PROG="/usr/bin/zip"
GT_FILE="AULTCARE-ACT-GENERIC-TABLES.txt"
MAIL_PROG="/bin/mail"
MAIL_TO="AultCareClaimsSupport@aultcare.com MFry2@aultcare.com CCriswell@aultcare.com aultcare-is@aultcare.com lrearick@aultcare.com ahenderson@aultcare.com Tlewis@aultcare.com"
MAIL_CC="operations@pdmi.com"
MAIL_SUBJ="Week Data File Notification"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr-cl113.sh 

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

   touch ${NEW_FLOC}/${NEW_LOG}
   if test -f ${TAPE_FILE_1}
   then
     FILE1_FOUND=1
     cat ${LOG_FILE_1} >> ${NEW_FLOC}/${NEW_LOG}
   else
     echo "-*> ${TAPE_FILE_1} does not exist..."
   fi 
   if test -f ${TAPE_FILE_2}
   then
     FILE2_FOUND=1
     cat ${LOG_FILE_2} >> ${NEW_FLOC}/${NEW_LOG}
   else
     echo "-*> ${TAPE_FILE_2} does not exist..."
   fi

}

zip_files()
{  cd ${NEW_FLOC}

   ${ZIP_PROG} ${ZIP_FILE} ${NEW_LOG}
   if [ ${FILE1_FOUND} = 1 ]
   then
     	${ZIP_PROG} -j ${ZIP_FILE} ${FILE_LOC}/${TAPE_FILE_1}
   fi
   if [ ${FILE2_FOUND} = 1 ]
   then
     	${ZIP_PROG} -j ${ZIP_FILE} ${FILE_LOC}/${TAPE_FILE_2} 
   fi
}


copy_files()
{
   cd ${NEW_FLOC}

   if test -f ${ZIP_FILE}
   then
     cp ${ZIP_FILE} ${DEST_LOC}
     echo "-=> zip file copied..."
     send_email
   else
     echo "-*>  Zip file was not copied to ${DEST_LOC}"
   fi
   
}

# Notification Email
send_email()
{  
        MON=`date +%m`
        DAY=`date +%d`
        YR=`date +%Y`
        case ${DAY} in
          "08" | "09" |"10" | "11" | "12" | "13") DATE_RANGE="${MON}/01/${YR} - ${MON}/07/${YR}"
                ;;
          "24" | "25" | "26" | "27" | "28") DATE_RANGE="${MON}/16/${YR} - ${MON}/23/${YR}"
                ;;
          "16" | "17" | "18" | "19" | "20" | "21" | "22")
                DATE_RANGE="${MON}/08/${YR} - ${MON}/15/${YR}"
                ;;
          "01" | "02" | "03" | "04" | "05" | "06")
                PREV_MON=`date -d "last month" +%m`
                MON_END=`date -d "now -${DAY} days" +%d`
                if [ $MON = "01" ]
                then
                        YR=`date -d "last year" +%Y`
                fi
                DATE_RANGE="${PREV_MON}/24/${YR} - ${PREV_MON}/${MON_END}/${YR}"
                ;;
        esac
        if test -s ${DEST_LOC}/${ZIP_FILE}
        then
                echo "The week file, ${ZIP_FILE}, is now available.\n\nDate Range: ${DATE_RANGE}" | ${MAIL_PROG} -s "Week Data File Notification" -c ${MAIL_CC} ${MAIL_TO}
        else
                echo "-*> No zip file.  Notification was not sent."
        fi
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${NEW_LOG}
   remove_file
   FNAME=${ZIP_FILE}
   remove_file
}

#
# Main routine
#

date +%T

echo 
echo "--> Renaming files for archival..."
echo

rename_files

if [ ${FILE1_FOUND} = 0 ]
then
  if [ ${FILE2_FOUND} = 0 ]
  then
      echo "-**> Neither claims file exists...Aborting this script"
      exit 1
  fi
fi

echo
echo "--> Zipping current files..."
echo

zip_files

echo 
echo "--> Copying files to ${DEST_LOC}..."

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up
 
echo "-=> Finished."

date +%T

exit 0
