#!/bin/sh
#
# Program Name	: clms_lviiv.sh
# Description	: Procedure to setup claims file for LASH/VIIV (sys0179)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 09/23/2016
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
DEST_LOC=/usr/lnk/wt/oper-wt/sftpexport/LASH/FromPDMI
TAPE_FILE="???CL111D0-T-LVIIV"
LOG_FILE="???CL111D0-T-LVIIVTEXT"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="LASHP-BIMONTHLY"
REMOTE_SYS=husk
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_lviiv.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}

#
# Set Filenames
set_filenames()
{
	CLM_FILE="Refreshclms-LVIIV-${PE_DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
	  scp ${FILE_LOC}/${TAPE_FILE} ${REMOTE_SYS}:${TMP_LOC}/${CLM_FILE}
	  ssh ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}"
          if test $? -ne 0
            then
                echo "*-> Transfer of file failed"
                clean_up
                exit 1
            fi
	else
	  echo "-*> Claims file does not exist..."
	  exit 99
	fi
}

#
# Cleanup
clean_up()
{
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${TMP_LOC}/${CLM_FILE}"
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
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
	PE_DATE=$1
	;;
  esac
  shift
done


set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

clean_up

echo "-=> Finished."

exit 0
