#!/bin/sh
#
# Program Name	: clms_lsun.sh
# Description	: Procedure to setup claims file for Lash-SUN (132)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 01/14/2010 
# Modifications : 12/28/2011 - Changed file name for D.0 format
#		: 02/22/2021 - new copy of file to lash-sftp
#
# Variables Used:
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
DEST_LOC=/usr/lnk/wt/oper-wt/sftpexport/LASH/FromPDMI
TAPE_FILE="???CL111D0-T-LSUN"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="LASHP-BIMONTHLY"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_lsun.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

ENDOFUSAGE
  exit 1
}


# Convert input date
conv_date()
{
        MO=`echo ${PE_DATE} | cut -c1-2`
        DAY=`echo ${PE_DATE} | cut -c3-4`
        YR=`echo ${PE_DATE} | cut -c5-8`
        PE_DATE2=${YR}${MO}${DAY}
}

#
# Set Filenames
set_filenames()
{
	CLM_FILE="Refreshclms-LSUN-${PE_DATE2}.txt"
	CLM_FILE_OLD="SUN_BIMON_${PE_DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
          if test $? -ne 0
            then
                echo "*-> Transfer of file failed"
            fi
	  cp ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE_OLD}
	  ${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE_OLD}
          if test $? -ne 0
            then
                echo "*-> Transfer of OLD file failed"
            fi
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Cleanup
clean_up()
{
        rm -f ${TMP_LOC}/${CLM_FILE_OLD}
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
	conv_date
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
