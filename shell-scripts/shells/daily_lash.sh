#!/bin/sh
#
# Program Name	: daily_lash.sh
# Description	: Files for the LASH Group (sys80)
# Author	: Linda S. Jefferis
# Date		: 07/13/2005
# Modifications : 10/28/2005 - Changes for Linux  (LSJ)
#		: 04/16/2010 - Added logic for new LCOP file
#		: 06/29/2010 - Added logic for LRBS file
#		: 04/01/2011 - Added logic for LSUN file
#		: 12/29/2011 - Changed filenames for D.0 format
#		: 04/24/2013 - Re-added logic for LSUN file
#		: 03/12/2015 - stopped transfer of LRBS and LSUN files, but still archiving the files.
#		: 03/26/2018 - stopped transfer of LASH (sys0080) file.
#		: 01/07/2021 - Parallel of new SFTP location and filenames.
#		: 05/09/2023 - Changed logic for file archiving system and removed LRBS file logic (LSJ)
#		: 06/20/2024 - Changes for PGP migrated to GoAnywhere (LSJ)
#
# Variables Used:
DATE=`date +%m%d%Y`
DATE2=`date +%Y%m%d`
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tapes"
EXTRACT_FILE_2="CL111DAYD0-?-LCOP"
EXTRACT_FILE_4="CL111DAYD0-?-LSUN"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="LASH"
TR_ID2="LASHP-DAILY"
ARCH_DIR="/usr/lnk/rptarch/daily"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_lash.sh 

ENDOFUSAGE
  exit 1
}


# Transfer_file
transfer_file()
{
	${TR_PROG} ${TR_ID} ${TR_FILE}
	if test $? -ne 0
        then
            echo "*-> Transfer of file failed"
            clean_up
	    exit 1
        fi
}

# Transfer_ftpfile
transfer_ftpfile()
{
	${TR_PROG} ${TR_ID2} ${TR_FILE}
	if test $? -ne 0
        then
            echo "*-> Transfer of file failed"
            ftpclean_up
	    exit 1
        fi
}

# Cleanup
ftpclean_up()
{
	archfile=`basename ${TR_FILE}`
	mv ${TR_FILE} ${ARCH_DIR}/$archfile
	if test $? -ne 0
             then
		echo "*-> File Archive failed"
	fi
}

# Cleanup
clean_up()
{
	archfile=`basename ${TR_FILE}`
	mv ${TR_FILE} ${ARCH_DIR}/$archfile
	if test $? -ne 0
             then
		echo "*-> File Archive failed"
	else
	     rm ${TAPE_FILE}
	fi
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

umask 002

if test -s ${FILE_PATH}/???${EXTRACT_FILE_2}
then
   echo "      --> Transferring ${EXTRACT_FILE_2}"
   TAPE_FILE=${FILE_PATH}/???${EXTRACT_FILE_2}
   TR_FILE=${FILE_PATH}/LCOPAY_CLMS_${DATE}.txt
   cp ${TAPE_FILE} ${TR_FILE}
   transfer_ftpfile
   ftpclean_up
   date
   TR_FILE=${FILE_PATH}/Dailyclms-LCOP-${DATE2}.txt
   cp ${TAPE_FILE} ${TR_FILE}
   transfer_file
   clean_up
   date
else
   echo "-*> NO LCOPAY FILE TO PROCESS"
fi


if test -s ${FILE_PATH}/???${EXTRACT_FILE_4}
then
   echo "      --> Transferring ${EXTRACT_FILE_4}"
   TAPE_FILE=${FILE_PATH}/???${EXTRACT_FILE_4}
   TR_FILE=${FILE_PATH}/LSUN_CLMS_${DATE}.txt
   cp ${TAPE_FILE} ${TR_FILE}
   transfer_ftpfile
   ftpclean_up
   date
   TR_FILE=${FILE_PATH}/Dailyclms-LSUN-${DATE2}.txt
   cp ${TAPE_FILE} ${TR_FILE}
   transfer_file
   clean_up
   date
else
   echo "-*> NO LSUN FILE TO PROCESS"
fi


exit 0
