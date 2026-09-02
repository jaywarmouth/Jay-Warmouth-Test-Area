#!/bin/ksh
#
# Program Name	: mthly_pharm.sh
# Description	: Prepare monthly Pharmacy files for pickup 
# Author	: Linda Jefferis
# Date		: 09/09/1999
# Modifications : 09/20/1999 (LSJ) Added run of shell/pharm01.sh
#		: 09/25/2000 (LSJ) Added rm of files before run of pharm01
#		: 12/13/2000 (LSJ) Changed PHARM01-77 to PHARM01-136
#		: 06/20/2002 (LSJ) Changed name of script to mthly_pharm.sh and added logic for SummaCare's file, PHARM01-25
#		: 08/26/2002 (LSJ) Added logic for URX's file, PHARM-159
#		: 01/16/2003 (LSJ) Changes for switch to web transfer location for SummaCare.
#		: 06/24/2003 (LSJ) Added logic for AMS's files
#		: 06/08/2004 (LSJ) Changed name for NEW_PHARM159 
#		: 06/24/2004 (LSJ) Added logic for new URX file, PHARM01-176
#		: 09/20/2004 (LSJ) Added logic for new HRRX PHARM01-77 file
#		: 02/08/2005 (LSJ) Added logic for Aultman files 
#		: 02/21/2005 (LSJ) Added 132 file for Aultman  
#		: 03/17/2005 (LSJ) Created zip file of 3 and 158 for Jill Jarosz at AMS
#		: 03/25/2005 (LSJ) Added 3 new networks for URX
#		: 04/25/2005 (LSJ) Changed NEW_PHARM_159 output name
#		: 05/04/2005 (LSJ) Addition of network #3 and #158 for URX
#		: 05/10/2005 (LSJ) Fixed rm of ???PHARM files before run 
#		: 06/03/2005 (LSJ) Changes for new PHARM05-URX file
#		: 06/03/2005 (LSJ) Removed send of files to Ameriscript and AMS-CSA
#		: 07/22/2005 (LSJ) Addition of file for Amerigroup/Careplus
#		: 09/27/2005 (LSJ) Removed logic for sending HRRX files
#		: 10/20/2005 (LSJ) Changes for linux  (LSJ)
#		: 11/29/2005 (LSJ) Changes for new system names  
#		: 12/15/2005 (LSJ) Additions for network 999 file for Aultman
#		: 12/15/2005 (LSJ) Eliminated send of netowrk 136 file to Aultman
#		: 01/23/2006 (LSJ) Eliminated send to SummaCare
#		: 02/27/2006 (LSJ) Removed lp commands and added umask command
#		: 04/18/2006 (LSJ) Added pharm01 run for Network #887 (sys85)
#		: 07/25/2006 (LSJ) Addition of amg-wt2 area
#		: 10/24/2006 (LSJ) Removal of URX logic and other general cleanup
#		: 12/26/2006 (LSJ) Added output log for emailing
#		: 05/29/2007 (LSJ) Removed logic for AMG/CarePlus 
#		: 10/22/2007 (LSJ) Changed to operations@pdmi.com and added email notification
#		: 01/26/2009 (LSJ) Changed email to two separate automatic to Aulcare and ODMH
#		: 04/28/2009 (LSJ) Added McFadden to MAIL_ODMH
#		: 04/30/2009 (LSJ) Temporarily (hopefully) changed logic back to just email Operations so emails can be forwarded.
#		: 09/26/2011 (LSJ) Changed to email clients directly.
#		: 03/29/2012 (LSJ) changed emails for ODMH
#		: 12/30/2014 - remove ODMH ilogic due to termination
#		: 02/20/2017 - TT16291-10; add process for Network #303
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date`
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
AULT_FOUND=0					# AULT File flag
AULT_PHARM111=???PHARM01-111
AULT_PHARM132=???PHARM01-132
AULT_PHARM134=???PHARM01-134
AULT_PHARM135=???PHARM01-135
AULT_PHARM161=???PHARM01-161
AULT_PHARM179=???PHARM01-179
AULT_PHARM189=???PHARM01-189
AULT_PHARM999=???PHARM01-999
AULT_PHARM303=???PHARM01-303
NEW_PHARM111=pharm-111.txt
NEW_PHARM132=pharm-132.txt
NEW_PHARM134=pharm-134.txt
NEW_PHARM135=pharm-135.txt
NEW_PHARM161=pharm-161.txt
NEW_PHARM179=pharm-179.txt
NEW_PHARM189=pharm-189.txt
NEW_PHARM999=pharm-999.txt
NEW_PHARM303=pharm-303.txt
ZIP_PROG="/usr/bin/zip"
LOG="/tmp/mthly_pharm_log"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
MAIL_AULT="aultcare-is@aultcare.com"
WT_DIR="/usr/lnk/wt"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mthly_pharm.sh

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

validate_host()
{
   case ${HOSTNAME} in
     "prod11")
	;;
     "*")
	echo "This procedure must be run on Prod11" > ${LOG}
	cat ${LOG} | ${MAIL_PROG} -s "Monthly Pharmacy File Process" ${MAIL_TO}
	exit 1
	;;
   esac
}
	
rename_files()
{  cd ${FILE_LOC}


   ### Aultman
   AULT_FOUND=1
   cp ${AULT_PHARM111} ${NEW_FLOC}/${NEW_PHARM111}
   cp ${AULT_PHARM132} ${NEW_FLOC}/${NEW_PHARM132}
   cp ${AULT_PHARM134} ${NEW_FLOC}/${NEW_PHARM134}
   cp ${AULT_PHARM135} ${NEW_FLOC}/${NEW_PHARM135}
   cp ${AULT_PHARM161} ${NEW_FLOC}/${NEW_PHARM161}
   cp ${AULT_PHARM179} ${NEW_FLOC}/${NEW_PHARM179}
   cp ${AULT_PHARM189} ${NEW_FLOC}/${NEW_PHARM189}
   cp ${AULT_PHARM999} ${NEW_FLOC}/${NEW_PHARM999}
   cp ${AULT_PHARM303} ${NEW_FLOC}/${NEW_PHARM303}

}

zip_files()
{  cd ${NEW_FLOC}


   if [ ${AULT_FOUND} = 1 ]
   then
      ZIP_FILE=pdmpharm.zip
      ${ZIP_PROG} -m ${ZIP_FILE} ${NEW_PHARM111} ${NEW_PHARM132} ${NEW_PHARM134} ${NEW_PHARM135} ${NEW_PHARM161} ${NEW_PHARM179} ${NEW_PHARM189} ${NEW_PHARM999} ${NEW_PHARM303}
      DEST_LOC=${AULT_LOC}
      copy_file 
      rm ${ZIP_FILE}
   fi

}

# Do cp of file
copy_file()
{
	echo "" >> ${LOG}
	echo "--> Copying the zip file" >> ${LOG}
	cd ${NEW_FLOC}
	if test -f ${ZIP_FILE}
	then
		cp ${ZIP_FILE} ${DEST_LOC}
		if test $? -ne 0
		then
		   echo "-*> Copy of file failed..." >> ${LOG}
		else
		   echo "-=> Copy of file was successful" >> ${LOG}
		fi
	else
		echo "-*> ${ZIP_FILE} doesn't exist. File was not copied" >> ${LOG}
	fi
}

#
# Main routine
#

umask 002

validate_host

parse_env

AULT_LOC=${WT_DIR}/ault-wt

rm -f ${LOG}
rm -f ${FILE_LOC}/???PHARM01-*

echo "" >> ${LOG}
echo "--> Running pharm01..." >> ${LOG}
${SHELL_DIR}/pharm01.sh > ${RPT_DIR}/pharm01 2>&1
${SHELL_DIR}/pharm01.sh -o 000303 >> ${RPT_DIR}/pharm01 2>&1
cat ${RPT_DIR}/pharm01 >> ${LOG}

date 

echo "" >> ${LOG}
echo "--> Renaming files for archival..." >> ${LOG}
echo "" >> ${LOG}

rename_files

echo "" >> ${LOG}
echo "--> Zipping current files..." >> ${LOG}
echo "" >> ${LOG}

zip_files

echo "-=> Finished." >> ${LOG}

date 

cat ${LOG} | ${MAIL_PROG} -s "Monthly Pharmacy File Process" ${MAIL_TO}
echo "The monthly Aultcare updated pharmacy file, pdmpharm.zip, is now available for downloading." | ${MAIL_PROG} -s "Monthly Pharmacy File Notification" -c ${MAIL_TO} ${MAIL_AULT}

exit 0
