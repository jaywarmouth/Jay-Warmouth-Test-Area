#!/bin/ksh
#
# Program Name	: zip_cl112.sh
# Description	: Prepare Claim112 file.
#		  Command Line Argument:
#		  -p <m/e prefix>  e.g. G31
# Author	: Linda Jefferis
# Date		: 05/05/2004
# Modifications : 10/28/2005 - Changes for Linux  (LSJ)
#
# Variables Used:
PREFIX="null"
FILE_LOC="/usr/lnk/tapes"			# Location of original file
NEW_FLOC="/usr/lnk/sort"			# Location of zip files
DEST_LOC="/usr/lnk/shares/ftp-tmp"	 	# Location of file for pickup
TAPE_FILE="CL112-P-SUMA"			# Original file
LOG_FILE="CL112SUMATEXT-P"
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

usage: zip_cl112.sh -p <m/e prefix>

ENDOFUSAGE
  exit 1
}

set_filenames()
{
      ZIP_FILE=hedis.zip      # Zip file name
      TXT_FILE=hedis.dat
      NEW_LOG=totals.txt
}

rename_files()
{
   cd ${FILE_LOC}
   if test -s ${PREFIX}${TAPE_FILE}
   then
     cp ${PREFIX}${TAPE_FILE} ${NEW_FLOC}/${TXT_FILE}
     cp ${PREFIX}${LOG_FILE} ${NEW_FLOC}/${NEW_LOG}
   else
     echo "-*> SUMMA claims file does not exist..."
   fi

}

zip_files()
{  cd ${NEW_FLOC}

   if test -f ${TXT_FILE}
   then
     ${ZIP_PROG} ${ZIP_FILE} ${TXT_FILE} ${NEW_LOG}
   fi

}

copy_files()
{  cd ${NEW_FLOC}

   if test -f ${ZIP_FILE}
   then
     mv ${ZIP_FILE} ${DEST_LOC}
     echo "-=> Summa file ready to be put to CD..."
   else
     echo "-*> SummaCare file not copied."
   fi
   
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${TXT_FILE}
   remove_file
   FNAME=${ZIP_FILE}
   remove_file
   FNAME=${NEW_LOG}
   remove_file
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
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
	PREFIX=$1
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
