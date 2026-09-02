#!/bin/ksh
#
# Program Name	: cp_cl71_suma.sh
# Description	: Prepare Claim71 file for Summacare to pick up.
#		  Command Line Argument:
#		  -p <m/e prefix>  e.g. G31
#		  -c <record count>
# Author	: Linda Jefferis
# Date		: 07/24/2002
# Modifications : 01/16/2003 - Changes for switch to web transfer  (LSJ)
#		: 10/20/2005 - Changes for linux  (LSJ)
#		: 11/29/2005 - Changes for new system names  (LSJ)
#
# Variables Used:
PREFIX="null"
FILE_LOC="/usr/lnk/tapes"			# Location of original file
NEW_FLOC="/tmp"					# Location of zip files
DEST_LOC="firefly:/usr/lnk/wt/suma-wt"	 	# Location of file for pickup
TAPE_FILE="CL71SUMA"				# Original file
LOG_FILE="readme.txt"
MAIL_TO=`/usr/bin/logname`
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"


remove_file()
{  
   cd ${NEW_FLOC}
   if test -f ${FNAME}
   then
     rm ${FNAME}
   fi
}

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_cl71_suma.sh -p <m/e prefix> -c <record count>

ENDOFUSAGE
  exit 1
}

set_month()
{
	MON_LETTER=`echo ${PREFIX} | cut -c1`	
	case ${MON_LETTER} in
	   "A") MONTH="January"
		;;
	   "B") MONTH="February"
		;;
	   "C") MONTH="March"
		;;
	   "D") MONTH="April"
		;;
	   "E") MONTH="May"
		;;
	   "F") MONTH="June"
		;;
	   "G") MONTH="July"
		;;
	   "H") MONTH="August"
		;;
	   "I") MONTH="September"
		;;
	   "J") MONTH="October"
		;;
	   "K") MONTH="November"
		;;
	   "L") MONTH="December"
		;;
	esac
}

set_filenames()
{
      ZIP_FILE=odjfs.zip      # Zip file name
      TXT_FILE=odjfs.dat
}

rename_files()
{
   cd ${FILE_LOC}
   if test -s ${PREFIX}${TAPE_FILE}
   then
     cp ${PREFIX}${TAPE_FILE} ${NEW_FLOC}/${TXT_FILE}
   else
     echo "-*> SUMMA claims file does not exist..."
   fi

}

create_log()
{
	echo "************************************" > ${NEW_FLOC}/${LOG_FILE}
	echo "  ODJFS Encounter Data for ${MONTH}" >> ${NEW_FLOC}/${LOG_FILE}
	echo "" >> ${NEW_FLOC}/${LOG_FILE}
	echo "     Total Claims = ${REC_CNT}" >> ${NEW_FLOC}/${LOG_FILE}
	echo "************************************" >> ${NEW_FLOC}/${LOG_FILE}
}

zip_files()
{  cd ${NEW_FLOC}

   if test -f ${TXT_FILE}
   then
     ${ZIP_PROG} ${ZIP_FILE} ${TXT_FILE} ${LOG_FILE}
   fi

}

copy_files()
{  cd ${NEW_FLOC}

   if test -f ${ZIP_FILE}
   then
     scp ${ZIP_FILE} ${DEST_LOC}
     echo "-=> Summa file copied..."
     echo "The file, ${ZIP_FILE}, is now available." | ${MAIL_PROG} -s "SUMMACARE MONTHLY ODJFS FILE NOTIFICATION" ${MAIL_TO} 
   else
     echo "-*> SummaCare file not copied to Raven."
   fi
   
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${TXT_FILE}
   remove_file
   FNAME=${ZIP_FILE}
   remove_file
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
if [ $# -lt 4 ]
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
	PREFIX=$1
	set_month
	;;
    -c) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	REC_CNT=$1
	;;
  esac
  shift
done

set_filenames

date +%T

echo 
echo "--> Renaming files for archival..."
echo

rename_files

echo 
echo "--> Creating log file..."
echo

create_log

echo
echo "--> Zipping the files..."
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
