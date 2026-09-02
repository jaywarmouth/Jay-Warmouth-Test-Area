#!/bin/sh
#
# Program Name	: clms_careservices.sh
# Description	: Procedure to setup clmrt01 claims file for HPS (sys073,124, 184, 189)
#		  Command Line Arguments:
#		  -p <ccyymmdd> Date for filename 
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
DEST_LOC=/usr/lnk/wt/oper-wt/sftpexport/CareServices/CycleRefresh/ToDE
TAPE_FILE="????CLMRTCS"
PE_DATE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_careservices.sh [-p <ccyymmdd>]
ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="Refreshclms-HPS-${PE_DATE}.txt"
}

#
transfer_file()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
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
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PE_DATE=$1
        set_filenames
        ;;
  esac
  shift
done


echo
echo "--> Transferring file..."
echo

transfer_file

echo "-=> Finished."

exit 0
