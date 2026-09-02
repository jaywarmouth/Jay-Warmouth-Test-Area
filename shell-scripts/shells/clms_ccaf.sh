#!/bin/sh
#
# Program Name	: clms_ccaf.sh
# Description	: Procedure to setup clmrt01 claims file for CCAF (sys0221)
#		  Command Line Arguments:
#		  -p <ccyymmdd> Date for filename 
# Author	: K Kosalai
# Date		: 01/16/2026
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="s3://ga-internal-transfers/CCAF/DIR/OUTBOUND/claims-refresh"
AWS_CP="/usr/local/bin/aws s3 cp"
TAPE_FILE="????CLMRTCY"
PE_DATE="null"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_ccaf.sh [-p <ccyymmdd>]
ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="Refreshclms-CCAF-${PE_DATE}.txt"
}

#
#
transfer_file()
{
        if test -s ${FILE_LOC}/${TAPE_FILE}
        then
          ${AWS_CP} ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
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
