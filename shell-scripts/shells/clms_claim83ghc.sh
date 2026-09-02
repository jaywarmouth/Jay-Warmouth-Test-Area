#!/bin/ksh
#
# Program Name	: clms_claim83ghc.sh
# Description	: Transfer data file for ProActive-GHC
# Author	: Linda Jefferis
# Date		: 07/18/2011
# Modifications : 08/21/2011 - Logic added for transfer to Genesis
#		: 01/20/2014 - Added prx-07 for file copy. (DME)
#		: 01/16/2015 - Logic change for new transfer method via JAMS processes (TT #9207-11).
#		: 01/27/2015 - Fixed DEST_DIR3 value; added the "wt" reference. Related to TT #9207-11 changes.
#               : 05/11/2015 - Distribution change - TT:12790-4
#		: 06/01/2015 - Updated DEST_DIR4
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_DATE=`date +%Y%m%d`
FILE_LOC=/usr/lnk/tapes
TAPE_FILE="???CL83GHC-M-GHC"
LOG_FILE="???CL83GHC-M-GHCTEXT"
MAIL_TO="Laura.Weigand@email.VeritasLTC.com jamie.parton@email.veritasltc.com"
MAIL_CC="operations@pdmi.com"
MAIL_PROG="/bin/mail"
DEST_DIR1="/usr/lnk/wt/prrx-03"
DEST_DIR2="/usr/lnk/wt/prrx-07"
DEST_DIR3="/usr/lnk/wt/oper-wt/jams-trfiles"
DEST_DIR4="/usr/lnk/wt/prrx-sftp"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_claim83ghc.sh

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
          echo "^G-*> Parse Error on Line: "${VAR}
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
	CLM_FILE=GHC_Monthly_Transactions_${FILE_DATE}.txt
	TOT_FILE=GHC_Monthly_Totals_${FILE_DATE}.txt
}

#
# Transfer Files
tr_files()
{	
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
		cp ${FILE_LOC}/${TAPE_FILE} ${DEST_DIR1}/${CLM_FILE}
                cp ${FILE_LOC}/${TAPE_FILE} ${DEST_DIR2}/${CLM_FILE}
                cp ${FILE_LOC}/${TAPE_FILE} ${DEST_DIR3}/${CLM_FILE}
                cp ${FILE_LOC}/${TAPE_FILE} ${DEST_DIR4}/${CLM_FILE}
		cp ${FILE_LOC}/${LOG_FILE} ${DEST_DIR1}/${TOT_FILE}
                cp ${FILE_LOC}/${LOG_FILE} ${DEST_DIR2}/${TOT_FILE}
                cp ${FILE_LOC}/${LOG_FILE} ${DEST_DIR3}/${TOT_FILE}
                cp ${FILE_LOC}/${LOG_FILE} ${DEST_DIR4}/${TOT_FILE}
		touch ${DEST_DIR3}/GHCfilesready.txt
		echo "The monthly GHC file is now available." | ${MAIL_PROG} -s "GHC Monthly File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
		echo "-*> Claims file does not exist..."
		exit 1
	fi
}


#
# Main routine
#

#Check command line validity, call usage if incorrect

parse_env


echo 
echo "--> Copying files..."

set_filenames

tr_files

echo "-=> Finished."

exit 0
