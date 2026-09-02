#!/bin/sh
#
# Program Name	: clms_ngs.sh
# Description	: Procedure to transfer claims data files to HCRM
#		  Command Line Arguments:
#		  -p <mmccyy>  M/E date
# Author	: Linda S. Jefferis
# Date		: 05/09/2008
# Modifications : 02/26/2009 - Changed email logic  (LSJ)
#		: 02/15/2010 - Changed jhansard email to mbulic and kbrzezinski  (LSJ)
#		: 01/03/2011 - Removed logic for NGS_SSI file
#		: 11/22/2011 - Changes for claim109d0 file format
#		: 05/02/2014 - Changed email contact
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="???CL109D0-M-PHU"
MAIL_PROG="/bin/mail"
MAIL_TO="mbulic@ngsamerican.com bbush@coresource.com"
MAIL_CC="operations@pdmi.com"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="300"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="NGS2"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_ngs.sh -p <m/e date>
	<m/e date> is month ending date in mmccyy format  (required)

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


#
# Set Filenames
set_filenames()
{
	CLM_FILE="ngs-phh${PE_DATE}.txt"
}


#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
          ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi

	
}

#
# Transfer files
transfer_file()
{
	${TR_PROG} ${TR_ID} ${DEST_LOC}/${CLM_FILE} 
	if test $? -ne 0
	then
		echo "*-> Transfer of file failed"
		clean_up
		exit 1
	else
		echo "The file, ${CLM_FILE}.pgp, from PDMI is now available." | ${MAIL_PROG} -s "NGS/Port Huron -  MONTHLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
	fi
}

#
# Cleanup
clean_up()
{
	rm ${DEST_LOC}/${CLM_FILE}
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

# Parse environment variables
#parse_env

set_filenames

echo
echo "--> Renaming files for archival..."
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
