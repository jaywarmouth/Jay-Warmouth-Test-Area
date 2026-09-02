#!/bin/sh
#
# Program Name	: nightly_accum_process.sh
# Description	: Nightly Accumulator Processing 
#		: 03/02/2020 - TT19774-3,DME; Changing TR_ID for LVHN to use LVHNL so will go to oper-wt/sftpexport/LVHNL instead of former lvhn-ftp location.
#		: 6/22/2020 - Removal of TSCPLA logic and other commented and/or old terminated logic.
#		: 08/28/2020 - TT20270-5; APRXMBEN ("rm") logic.
#		: 06/02/2021 - Remove terminated logic for SMSTimesHMA files (167/1341)
#		: 11/30/2022 - Remove terminated logic for APRXMBEN files
#		: 12/02/2022 - Remove logic for upcoming terminating TSCIUH
#		: 05/02/2023 - Change of TR_ID for MEDBEN files from MEDBEN to MEDB
#		: 01/01/2025 - Deactivate terminated client/TPA files (TSCSIHO, TSCWEBTPA, TSCKHA)


# Variables Used:
PATH=/usr/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO=operations@pdmi.com
FULL_DATE=`date +%Y%m%d`
FILE_DIR="/usr/lnk/accum_out"
LOG="$RPT_DIR/nightly_accum"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
SPEC_PROC=0
RUN_DATE=`date +%Y%m%d`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nightly_accum_process.sh 

ENDOFUSAGE
  exit 1
}

#
# File Process
file_proc()
{
	ACCUM_FILE=${CLIENT_NAME}-LIMIT-${FULL_DATE}
	${SHELL_DIR}/accum01.sh -c ${CLIENT} -f >> ${LOG} 2>&1

	if test $? -eq 0
	then
	  if [ $SPEC_PROC = 1 ]
	  then
		mv ${FILE_DIR}/${ACCUM_FILE} ${FILE_DIR}/${ALT_NAME} >> ${LOG}
		echo "--> Encrypting and transferring file" >> ${LOG}
		${TR_PROG} ${TR_ID} ${FILE_DIR}/${ALT_NAME} >> ${LOG}
		echo "--> Cleanup" >> ${LOG}
		rm -f ${FILE_DIR}/${ALT_NAME} >> ${LOG}
	  else
		echo "--> Encrypting and transferring file" >> ${LOG}
		${TR_PROG} ${TR_ID} ${FILE_DIR}/${ACCUM_FILE} >> ${LOG}

		echo "--> Cleanup" >> ${LOG}
		rm -f ${FILE_DIR}/${ACCUM_FILE} >> ${LOG}
	  fi
	else
	  echo "--*> No ${CLIENT_NAME}-LIMIT-${FULL_DATE} to transfer." >> ${LOG}
	fi
	SPEC_PROC=0
}

#
# Main routine
#

date > ${LOG}


echo "" >> ${LOG}
echo "--> Process MedBen (sys0049)" >> ${LOG}
CLIENT_NAME="MEDBEN"
TR_ID="MEDB"
CLIENT="mb"
file_proc

date >> ${LOG}
echo "" >> ${LOG}
echo "--> Process URX-IMG (sys0058)" >> ${LOG}
CLIENT_NAME="IMG"
TR_ID="IMGACCUM"
CLIENT="ig"
file_proc

date >> ${LOG}
echo "" >> ${LOG}
echo "--> Process LVHN (sys0162)" >> ${LOG}
CLIENT_NAME="LVHN"
TR_ID="LVHNL"
CLIENT="lv"
file_proc

	
#date >> ${LOG}
#echo "" >> ${LOG}
#echo "--> Process TSC-SIHO (163/SIHO)" >> ${LOG}
#CLIENT_NAME="TSCSIHO"
#TR_ID="SIHO"
#CLIENT="gp"
#file_proc


#EFF_DATE=20170101
#if [ $RUN_DATE -gt $EFF_DATE ]
#then
#        date >> ${LOG}
#        echo "" >> ${LOG}
#        echo "--> Process TSC-HTGE (163/HTGE)" >> ${LOG}
#        CLIENT_NAME="TSCHTGE"
#        TR_ID="TSCHTGE"
#        CLIENT="xh"
#        file_proc
#fi
EFF_DATE=0



## Files effective 1/1/2018
#
EFF_DATE=20180101
if [ $RUN_DATE -gt $EFF_DATE ]
then
#	date >> ${LOG}
#	echo "" >> ${LOG}
#	echo "--> Process TSC-IUH (163/IUH)" >> ${LOG}
#	CLIENT_NAME="TSCIUH"
#	TR_ID="TSCIUH"
#	CLIENT="xi"
#	file_proc

#	date >> ${LOG}
#	echo "" >> ${LOG}
#	echo "--> Process TSC-KHA (163/KHA)" >> ${LOG}
#	CLIENT_NAME="TSCKHA"
#	TR_ID="TSCKHA"
#	CLIENT="kh"
#	file_proc

#	date >> ${LOG}
#	echo "" >> ${LOG}
#	echo "--> Process TSC-WTPA (163/WebTPA)" >> ${LOG}
#	CLIENT_NAME="TSCWTPA"
#	TR_ID="TSCWTPA"
#	CLIENT="xw"
#	file_proc

        date >> ${LOG}
        echo "" >> ${LOG}
        echo "--> Process TSC-MBEN (163/MBEN)" >> ${LOG}
        CLIENT_NAME="TSCMBEN"
        TR_ID="TSCMBENACCUM"
        CLIENT="xm"
        file_proc
fi
EFF_DATE=0

## End effective 1/1/2018 files


date >> ${LOG}

cat ${LOG} | ${MAIL_PROG} -s "Nightly Accumulator Process" ${MAIL_TO}


exit 0
