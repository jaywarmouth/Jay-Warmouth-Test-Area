#!/bin/sh
#
# Program Name	: clms_bch.sh
# Description	: Procedure to setup clmrt01 claims file for PAF-BCH (sys0224)
#		  Command Line Arguments:
#		  -p <mmddccyy> Date for filename 
# Author	: Linda S. Jefferis
# Date		: 07/06/2018
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC=/tmp
TAPE_FILE="????CLMRTFB"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="BCH"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_bch.sh [-p <mmddccyy>]
ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
        MO=`echo ${IN_DATE} | cut -c1-2`
        DAY=`echo ${IN_DATE} | cut -c3-4`
        YR=`echo ${IN_DATE} | cut -c5-8`
        PE_DATE=${YR}${MO}${DAY}
	CLM_FILE="Refreshclms-BCH-${PE_DATE}.txt"
}

#
rename_file()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Transfer file
transfer_file()
{
        if test -a ${TMP_LOC}/${CLM_FILE}
        then
	   ${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE} 
	   rm -f ${TMP_LOC}/${CLM_FILE}
        else
           echo "--*> File not copied..."
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
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        IN_DATE=$1
        set_filenames
        ;;
  esac
  shift
done

echo
echo "--> Convert/Rename file..."
rename_file

echo
echo "--> Transferring file to ${DEST_LOC}..."
echo
transfer_file

echo "-=> Finished."

exit 0
