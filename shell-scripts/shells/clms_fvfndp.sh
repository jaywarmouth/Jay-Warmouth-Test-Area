#!/bin/sh
#
# Program Name	: clms_fvfndp.sh
# Description	: Procedure to setup clmrt01 claims file for FVFNDP (sys0211)
#		  Command Line Arguments:
#		  -p <ccyymmdd> Date for filename 
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
DEST_LOC=/usr/lnk/wt/oper-wt/sftpexport/FVFNDP/FromPDMI
TAPE_FILE="????CLMRTFC"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
PE_DATE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_fvfndp.sh [-p <ccyymmdd>]
ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="Refreshclms-FVFNDP-${PE_DATE}.txt"
}

#
rename_files()
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
	   mv ${TMP_LOC}/${CLM_FILE} ${DEST_LOC}
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
        PE_DATE=$1
        set_filenames
        ;;
  esac
  shift
done

echo
echo "--> Renaming files..."
echo

rename_files

echo
echo "--> Transferring file..."
echo

transfer_file

echo "-=> Finished."


exit 0
