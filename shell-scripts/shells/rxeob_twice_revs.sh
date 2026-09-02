#!/bin/sh
#
# Program Name	: rxeob_twice_revs.sh
# Description	: Prepare reversal file for encryption/upload to RXEOB
#               : Command Line Arguments:
#                       -d <yyyymmdd> Date for filename
# Author	: Linda Jefferis
# Date		: 11/29/2001
# Modifications : 10/28/2005 - Changes for Linux  (LSJ)
#		: 06/04/2007 - Added secure_transfer.sh logic  (LSJ)
#		: 12/28/2007 - Changed name of TAPE_FILE for new claim111rx procedure  (LSJ)
#		: 07/02/2010 - Added "?" to RXEOB file names  (LSJ)
#
# Variables Used:
FILE_DATE="null"
FILE_LOC=/usr/lnk/rxeob				# Location of original file
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="RXEOB-GA"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_twice_revs.sh [-d <yyyymmdd>]

ENDOFUSAGE
  exit 1
}

set_filenames()
{
   if [ ${FILE_DATE} = "null" ]
   then
      usage
   else
      FNAME=pdmi_reversals_cycle_t_${FILE_DATE}.txt
   fi
}


transfer_file()
{  
   if test -f ${FILE_LOC}/${FNAME}
   then
     ${TR_PROG} ${TR_ID} ${FILE_LOC}/${FNAME}
     if test $? -ne 0
           then
                echo "*-> Transfer of file failed"
                clean_up
                exit 1
           fi
   else
     echo "-*> ${FILE_LOC}/${FNAME} does not exist..."
     echo "-*> Exiting script"
     exit 1
   fi

}



#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_DATE=$1
        ;;
  esac
  shift
done

set_filenames

echo
echo "--> Transfer file..."
echo

transfer_file

echo "-=> Finished."


exit 0
