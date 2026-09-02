#!/bin/ksh
#
# Program Name	: biwkly_suma_ded.sh
# Description	: Procedure to setup Deductible file to send to Summa
#		  Command Line Arguments:
#		  -p <p/e prefix>
#		  -d <p/e - mmddccyy>
# Author	: Linda S. Jefferis
# Date		: 03/14/2002
# Modifications : 06/10/2003 - Changed logic for putting file on suma-wt web server location  (LSJ) 
#		: 10/17/2005 - Changes for linux commands  (LSJ)
#		: 12/03/2005 - Changes for new system names  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
NEW_FLOC=/tmp                                   # Location of zip files
DEST_LOC="firefly:/usr/lnk/wt/suma-wt"
TAPE_FILE="SUMA-DED-P"
MAIL_TO=`/usr/bin/logname`
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: biwkly_suma_ded.sh -p <p/e date> -d <mmddccyy>
	<p/e prefix> is period ending prefix(3-digit)  (required)
	<mmddccyy> is period ending date  (required)

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

remove_file()
{
   cd ${NEW_FLOC}
   if test -f ${FNAME}
   then
     rm ${FNAME}
   fi
}


#
rename_files()
{
	if test -s ${FILE_LOC}/${PREFIX}${TAPE_FILE}
	then
	  ZIP_FILE=pdmded.zip
	  DED_FILE=pdmded.txt
	  cp ${FILE_LOC}/${PREFIX}${TAPE_FILE} ${NEW_FLOC}/${DED_FILE}
	else
	  echo "-*> ${PREFIX}${TAPE_FILE} file does not exist..."
	  exit 1
	fi
}

#
# Zip files
zip_files()
{
	cd ${NEW_FLOC}
	if test -f ${DED_FILE}
	then
	  ${ZIP_PROG} ${ZIP_FILE} ${DED_FILE}
	fi
}

copy_files()
{  
	cd ${NEW_FLOC}

   	if test -f ${ZIP_FILE}
   	then
     	  scp ${ZIP_FILE} ${DEST_LOC}
     	  echo "-=> Summa Deductible file copied..."
     	  echo "The file, ${ZIP_FILE}, for Period Ending ${DATE} is now available." | ${MAIL_PROG} -s "SUMMACARE BI-WEEKLY DEDUCTIBLE FILE NOTIFICATION" ${MAIL_TO}
   	else
     	  echo "-*> SummaCare file not copied to Raven."
   	fi
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${DED_FILE}
   remove_file
   FNAME=${ZIP_FILE}
   remove_file
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
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
	;;
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

# Parse environment variables
#parse_env

echo
echo "--> Renaming files..."
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
exit 0
