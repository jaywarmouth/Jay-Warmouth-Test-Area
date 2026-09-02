#!/bin/ksh
#
# Program Name	: arch_hps_elig.sh
# Description	: Automatic archiving procedure for HPS elig. files
# Author	: Linda S. Jefferis
# Date		: 06/25/2004
# Modifications : 07/26/2004 - Changed the "-mtime +1" to "-mtime +2" for selecting which files to zip and archive  (LSJ)
#		: 08/09/2004 - Upped "mtime" to +3  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#		: 10/20/2006 - Changed 4-digit system logic for filenames and added PRINT-73-HOME-????  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ARCH_DIR="/usr/lnk/elig_in_1/sys0073"
ELIG_DIR="/usr/lnk/elig_in/sys0073"
RPT_DIR="/usr/lnk/misc"
ZIP_PROG="/usr/bin/zip"
DATE=`date +%m%y`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: arch_hps_elig.sh 

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
# Main routine
#
cd ${ELIG_DIR}
find . -name "D*" -mtime +3 -print > /tmp/hps-filelist
for FILE in `cat /tmp/hps-filelist`
do
   mv $FILE ${ARCH_DIR}
   if test $? -ne 0
   then
      echo "-*> Error with elig file copy"
      exit 1
   else
      ${ZIP_PROG} -mj ${ARCH_DIR}/hp${DATE}.zip ${ARCH_DIR}/$FILE
      if test $? -ne 0
      then
         echo "-*> Error with zip of $FILE"
      fi
   fi
done
find . -name "R*" -mtime +3 -print > /tmp/hps-filelist2
for FILE2 in `cat /tmp/hps-filelist2`
do
   mv $FILE2 ${ARCH_DIR}
   if test $? -ne 0
   then
      echo "-*> Error with response file copy"
      exit 1
   else
      ${ZIP_PROG} -mj ${ARCH_DIR}/hp${DATE}.zip ${ARCH_DIR}/$FILE2
      if test $? -ne 0
      then
         echo "-*> Error with zip of $FILE2"
      fi
   fi
done
find . -name "73CA73*" -mtime +3 -print > /tmp/hps-filelist4
for FILE4 in `cat /tmp/hps-filelist4`
do
   mv $FILE4 ${ARCH_DIR}
   if test $? -ne 0
   then
      echo "-*> Error with elig out file copy"
      exit 1
   else
      ${ZIP_PROG} -mj ${ARCH_DIR}/hp${DATE}.zip ${ARCH_DIR}/$FILE4
      if test $? -ne 0
      then
         echo "-*> Error with zip of $FILE4"
      fi
   fi
done

cd ${RPT_DIR}
find . -name "PRINT-73-????" -mtime +3 -print > /tmp/hps-filelist3
find . -name "PRINT-73-HOME-????" -mtime +3 -print >> /tmp/hps-filelist3
for FILE3 in `cat /tmp/hps-filelist3`
do
   mv $FILE3 ${ARCH_DIR}
   if test $? -ne 0
   then
      echo "-*> Error with error report file copy"
   else
      ${ZIP_PROG} -mj ${ARCH_DIR}/hp${DATE}.zip ${ARCH_DIR}/$FILE3
      if test $? -ne 0
      then
         echo "-*> Error with zip of $FILE3"
      fi
   fi
done

rm /tmp/hps-filelist
rm /tmp/hps-filelist2
rm /tmp/hps-filelist3
rm /tmp/hps-filelist4
   
exit 0
