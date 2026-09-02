#!/bin/sh
#
# Program Name	:
# Description	: Copy previous day's switchfiles from Prod10 to Robin
# Author	: Linda Jefferis
# Date		: 10/28/2015
# Modifications : 06/01/2016 - TT3454-39 Add webclaimfiles logic
#		: 06/13/2016 - changes to webclaimfiles logic; added test for available files on Prod10.
#		: 6/14/2016 - correction to "ssh prod10" logic.
#
# Variables Used:
PROD_DIR=/usr/lnk/daily
LOCAL_DIR=/usr/devl/common/switchfiles
ZIP_PROG="/usr/lnk/shell/zippass.sh"
PREVDAY=`date -d "yesterday 0800" +%Y%m%d`
ZIPDATE=`date -d "yesterday 0800" +%Y%m`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: robinswitchfilecopy.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#


## Switch Files
scp prod10:${PROD_DIR}/switch??/switch??-${PREVDAY}* ${LOCAL_DIR}
if test $? -ne 0
then
	echo "Copy of switch files from Prod10 Failed"
	RETVAL=99
	exit ${RETVAL}
fi
${ZIP_PROG} -jm ${LOCAL_DIR}/switchfiles-${ZIPDATE}.zip ${LOCAL_DIR}/switch??-${PREVDAY}*
if test $? -ne 0
then
	echo "Zip of switch files Failed"
	RETVAL=99
	exit ${RETVAL}
fi

## Webclaim Files
FILECNT=`ssh prod10 "ls -1 ${PROD_DIR}/webclaim/*-${PREVDAY} | wc -l"`
if [ $FILECNT -gt 0 ]
then
   scp prod10:${PROD_DIR}/webclaim/*-${PREVDAY} ${LOCAL_DIR}/webclaim
   if test $? -ne 0
   then
	   echo "Copy of webclam files from Prod10 Failed"
	   RETVAL=99
	   exit ${RETVAL}
   fi
   ${ZIP_PROG} -jm ${LOCAL_DIR}/webclaimfiles-${ZIPDATE}.zip ${LOCAL_DIR}/webclaim/*-${PREVDAY}
   if test $? -ne 0
   then
	   echo "Zip of webclaim files Failed"
	   RETVAL=99
	   exit ${RETVAL}
   fi
else
   echo "--> No ${PROD_DIR}/webclaim/*-${PREVDAY} files available."
fi


exit ${RETVAL}
