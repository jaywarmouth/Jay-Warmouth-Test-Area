#!/bin/ksh
#
# Program Name	: bimthly_pharm.sh
# Description	: Prepare mid-monthly Pharmacy files for pickup 
#			For HRRX
# Author	: Linda Jefferis
# Date		: 06/08/2004
# Modifications : 09/20/2004 - Added logic for new PHARM01-77 file  (LSJ)
#		: 05/10/2005 - Fixed rm of ???PHARM-01 files before run  (LSJ)
#		: 10/17/2005 - Changes for linux  (LSJ)
#
# Variables Used:
DATE=`date`
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
HRRX_LOC=/usr/lnk/shares/ftp-tmp 		# HRRX file location for pickup
SUMA_LOC=/usr/lnk/wt/suma-wt			# SUMA file location for pickup
URX_LOC=/usr/lnk/wt/urx-wt			# URX file location for pickup
AMS_LOC=/usr/lnk/shares/ftp-tmp
HRRX_FOUND=0					# HRRX file flag
SUMA_FOUND=0					# SUMA File flag
URX_FOUND=0					# URX File flag
AMS_FOUND=0					# AMS File flag
HRRX_PHARM73=???PHARM01-73			# Original HRRX file
HRRX_PHARM77=???PHARM01-77			# Original HRRX file
HRRX_PHARM136=???PHARM01-136			# Original HRRX file
SUMA_PHARM25=???PHARM01-25			# Original SUMA file
URX_PHARM159=???PHARM01-159			# Original URX file
AMS_PHARM03=???PHARM01-3			# Original AMS file
AMS_PHARM158=???PHARM01-158			# Original AMS file
NEW_PHARM73=pharm-73.txt			# Renamed HRRX file
NEW_PHARM77=pharm-77.txt			# Renamed HRRX file
NEW_PHARM136=pharm-136.txt                      # Renamed HRRX file
NEW_PHARM25=pharm-25.txt			# Renamed SUMA file
NEW_PHARM159=pharm-159.txt			# Renamed URX file
NEW_PHARM03=pharm-03.txt			# Renamed AMS file
NEW_PHARM158=pharm-158.txt			# Renamed AMS file
ZIP_PROG="/usr/bin/zip"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: bimthly_pharm.sh

ENDOFUSAGE
  exit 1
}


validate_host()
{
   case ${HOSTNAME} in
     "falcon" | "raven")
	;;
     "*")
	echo "This procedure must be run on Falcon or Raven"
	exit 1
	;;
   esac
}
	
rename_files()
{  cd ${FILE_LOC}

   if [ -f ${HRRX_PHARM136} -a -f ${HRRX_PHARM73} -a -f ${HRRX_PHARM77} ]
   then
     HRRX_FOUND=1
     cp ${HRRX_PHARM73} ${NEW_FLOC}/${NEW_PHARM73}
     cp ${HRRX_PHARM77} ${NEW_FLOC}/${NEW_PHARM77}
     cp ${HRRX_PHARM136} ${NEW_FLOC}/${NEW_PHARM136}
   else
     echo "-*> HRRX pharmacy files do not exist..."
   fi 

#   if test -s ${SUMA_PHARM25}
#   then
#      SUMA_FOUND=1
#      cp ${SUMA_PHARM25} ${NEW_FLOC}/${NEW_PHARM25}
#   else
#      echo "-*> SUMA pharmacy file does not exist..."
#   fi
#
#   if test -s ${URX_PHARM159}
#   then
#      URX_FOUND=1
#      cp ${URX_PHARM159} ${NEW_FLOC}/${NEW_PHARM159}
#   else
#      echo "-*> URX pharmacy file does not exist..."
#   fi
#
#   if [ -f ${AMS_PHARM03} -a -f ${AMS_PHARM158} ]
#   then
#     AMS_FOUND=1
#     cp ${AMS_PHARM03} ${NEW_FLOC}/${NEW_PHARM03}
#     cp ${AMS_PHARM158} ${NEW_FLOC}/${NEW_PHARM158}
#   else
#     echo "-*> AMS pharmacy files do not exist..."
#   fi 
}

zip_files()
{  cd ${NEW_FLOC}

   if [ ${HRRX_FOUND} = 1 ]
   then
      ZIP_FILE=hrrx-pdmpharm.zip
      ${ZIP_PROG} -m ${ZIP_FILE} ${NEW_PHARM73} ${NEW_PHARM77} ${NEW_PHARM136}
      DEST_LOC=${HRRX_LOC}
      DEST_SYS="crow"
      scp_file
      rm ${ZIP_FILE}
   fi

   if [ ${SUMA_FOUND} = 1 ]
   then
      ZIP_FILE=pdmpharm.zip
      ${ZIP_PROG} -m ${ZIP_FILE} ${NEW_PHARM25}
      DEST_LOC=${SUMA_LOC}
      copy_file 
      rm ${ZIP_FILE}
   fi

   if [ ${URX_FOUND} = 1 ]
   then
      ZIP_FILE=pdmpharm.zip   
      ${ZIP_PROG} -m ${ZIP_FILE} ${NEW_PHARM159}
      DEST_LOC=${URX_LOC}
      DEST_SYS="falcon"
      copy_file
      rm ${ZIP_FILE}
   fi

   if [ ${AMS_FOUND} = 1 ]
   then
      ZIP_FILE=csa-pdmpharm.zip
      ${ZIP_PROG} -m ${ZIP_FILE} ${NEW_PHARM03} ${NEW_PHARM158}
      DEST_LOC=${AMS_LOC}
      DEST_SYS="crow"
      scp_file
      rm ${ZIP_FILE}
   fi

}

# Do cp of file
copy_file()
{
	echo
	echo "--> Copying the zip file"
	cd ${NEW_FLOC}
	if test -f ${ZIP_FILE}
	then
		cp ${ZIP_FILE} ${DEST_LOC}
		if test $? -ne 0
		then
		   echo "-*> Copy of file failed..."
		else
		   echo "-=> Copy of file was successful"
		fi
	else
		echo "-*> ${ZIP_FILE} doesn't exist. File was not copied"
	fi
}

# Do scp of file
scp_file()
{
	echo
	echo "--> SCPing the zip file"
	cd ${NEW_FLOC}
	if test -f ${ZIP_FILE}
	then
		SCP_SYS=`/usr/local/bin/picksystem.sh ${DEST_SYS}`
		if test $? -ne 0
		then
		   echo "-*> ERROR with picksystem.sh"
		   SCP_SYS=${DEST_SYS}
		fi
		scp ${ZIP_FILE} ${DEST_SYS}:${DEST_LOC}
	else
		echo "-*> ${ZIP_FILE} doesn't exist. File was not copied"
	fi
}

#
# Main routine
#

validate_host

rm -f ${FILE_LOC}/???PHARM01-*
${SHELL_DIR}/pharm01.sh > ${RPT_DIR}/pharm01 2>&1
lp ${RPT_DIR}/pharm01

date 

echo 
echo "--> Renaming files for archival..."
echo

rename_files

echo
echo "--> Zipping current files..."
echo

zip_files

echo "-=> Finished."

date 

exit 0
