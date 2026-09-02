#!/bin/sh
#
# Program Name	: clms_gdrx.sh
# Description	: Procedure to setup clmrt01 claims file for GDRX (sys0210)
#		  Command Line Arguments:
#		  -p <ccyymmdd> Date for filename 
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="????CLMRTGX"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
PE_DATE="null"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="MERCALIS"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_gdrx.sh [-p <ccyymmdd>]
ENDOFUSAGE
  exit 1
}


#
# Set Filenames
set_filenames()
{
	CLM_FILE="Refreshclms-GDRX-${PE_DATE}.txt"
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
          ${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}
          if test $? -ne 0
            then
                echo "*-> Transfer of file failed"
                clean_up
                exit 1
            fi
        else
           echo "--*> File not copied..."
        fi
}

#
# Cleanup
clean_up()
{
	rm -f ${TMP_LOC}/${CLM_FILE}
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

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."


exit 0
