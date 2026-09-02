#!/bin/sh
#
# Program Name	: audit_mv.sh
# Description	: Rename and reset select audit files
# Author	: Linda S. Jefferis
# Date		: 07/29/97
# Modifications :
#		  10/17/2005 - Changes for linux  (LSJ)
#		  12/05/2005 - Changes for new system names  (LSJ)
#		  03/20/2006 - Addition of CRDAUD-FG file  (LSJ)
#		  03/29/2006 - Addition of PDEAUD file  (LSJ)
#		  05/19/2006 - Addition of logic for crdmerge01 process  (LSJ)
#		  06/05/2006 - Eliminate CRDAUD-78 file  (LSJ)
#		  07/11/2006 - Addition of test processes for crdmerge01  (LSJ)
#		  07/13/2006 - Commented out crdmerge01 procedures for now  (LSJ)
#		  11/06/2006 - Added the assignment of the AUDCTRL variable  (LSJ)
#		  12/11/2007 - Commented out crdmerge01 testing processes  (LSJ)
#		  10/21/2008 - Added BACKUP_4 (s1rook)  (LSJ)
#		  11/23/2009 - Added BACKUP_5 (prod11) and changed s1rook to prod10 (LSJ)
#		  01/25/2011 - Added logic for creation of blank STPTMP0MAS-ccyymmdd each morning
#		  08/09/2011 - Changed DATE format
#		  07/05/2012 - Added RV601-MAN file
#		  07/11/2012 - Fixed Added CURR_DATE logic for RV601 files and changed STPTMP0MAS files to correctly use this also.
#		  08/20/2013 - Added logic for STPTMP1MAS file
#		  04/19/2022 - removed "BACKUP_4/prod20" logic.
#		  06/08/2022 - Changed "404" to "410"
#		  01/31/2022 - Removed "BACKUP_2/husk" logic.
#		  03/2024 - Logic for new switch company (700/701)
#		  03/2024 - Logic for new switch company (900/901)
#		  06/2024 - New sw40 queues (302-309)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RPT_DIR="/usr/lnk/rpt"
TMP_PATH="/usr/lnk/tmp"
AUDIT_PATH="/usr/lnk/audit"
AUDCTRL="/usr/lnk/audctrl"
DATE=`date -d "yesterday 0800" +%Y%m%d`
CURR_DATE=`date +%Y%m%d`
BACKUP_1="prod11"
BACKUP_5="prodtest10"
AUD[1]="FG4AUD"
AUD[2]="GRPAUD"
AUD[3]="LIMAUD"
AUD[4]="PHAAUD"
AUD[5]="EMBAUD"
AUD[6]="REVAUD"
AUD[7]="CHKAUD"
AUD[8]="CRDAUD"
AUD[9]="CRDAUD-RT"
AUD[10]="CRDAUD-FG"
AUD[11]="PDEAUD"
AUD[12]="CLAIM02"
MAXVALUE=12

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: audit_mv.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
      FIRSTCH=`echo ${VAR} | cut -c1`
      if [ ${FIRSTCH} != "#" ]
      then
        eval ${VAR} 2> /dev/null
        IFS=${EQUAL}
        NVAR=`echo ${VAR} | awk '{print $1}'`
        export ${NVAR}
        if [ $? -ne 0 ]
        then
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}
#
# Main routine
#

# Parse environment variables
parse_env

date

echo ""
echo "--> Moving files"

i=1
ENDVALUE=2
while [ $i -le ${ENDVALUE} ]
do
	mv ${TMP_PATH}/${AUD[i]} ${AUDIT_PATH}/${AUD[i]}.${DATE}
	if test $? -ne 0
	then
		echo ""
		echo "-*> mv of ${AUD[i]} was unsuccessful"
	else
		touch ${TMP_PATH}/${AUD[i]}
		chmod 666 ${TMP_PATH}/${AUD[i]}
		fi
		let i=i+1
done

i=3
while [ $i -le ${MAXVALUE} ]
do
	mv ${AUDIT_PATH}/${AUD[i]} ${AUDIT_PATH}/${AUD[i]}.${DATE}
	if test $? -ne 0
	then
		echo ""
		echo "-*> mv of ${AUD[i]} was unsuccessful"
	else
		touch ${AUDIT_PATH}/${AUD[i]}
		chmod 666 ${AUDIT_PATH}/${AUD[i]}
	fi
	let i=i+1
done

# STPTMP0MAS file
if ! test -e ${AUDIT_PATH}/STPTMP0MAS-${CURR_DATE}
then
	cp ${AUDIT_PATH}/STPTMP0MAS.null ${AUDIT_PATH}/STPTMP0MAS-${CURR_DATE}
	if test $? -ne 0
	then
		echo ""
		echo "-*> creation of STPTMP0MAS-${CURR_DATE} failed"
	else
		chmod 666 ${AUDIT_PATH}/STPTMP0MAS-${CURR_DATE}
		chgrp c04 ${AUDIT_PATH}/STPTMP0MAS-${CURR_DATE}
	fi
fi
if ! test -e ${AUDIT_PATH}/STPTMP1MAS-${CURR_DATE}
then
	cp ${AUDIT_PATH}/STPTMP1MAS.null ${AUDIT_PATH}/STPTMP1MAS-${CURR_DATE}
	if test $? -ne 0
	then
		echo ""
		echo "-*> creation of STPTMP1MAS-${CURR_DATE} failed"
	else
		chmod 666 ${AUDIT_PATH}/STPTMP1MAS-${CURR_DATE}
		chgrp c04 ${AUDIT_PATH}/STPTMP1MAS-${CURR_DATE}
	fi
fi

# RV601-MAN file
if ! test -e ${AUDIT_PATH}/RV601-MAN-${CURR_DATE}
then
	touch ${AUDIT_PATH}/RV601-MAN-${CURR_DATE}
	if test $? -ne 0
	then
		echo ""
		echo "-*> creation of RV601-MAN-${CURR_DATE} failed"
	else
		chmod 666 ${AUDIT_PATH}/RV601-MAN-${CURR_DATE}
	fi
fi


echo ""
echo "--> Copying CLAIM02 to BACKUP systems"
scp ${AUDIT_PATH}/CLAIM02.${DATE} ${BACKUP_1}:${AUDIT_PATH}/CLAIM02.cmp
scp ${AUDIT_PATH}/CLAIM02.${DATE} ${BACKUP_5}:${AUDIT_PATH}/CLAIM02.cmp

# CYCLERRS Files
QLIST="200 201 300 301 302 303 304 305 306 307 308 309 400 402 410 406 408 600 601 700 701 900 901 MAN"
cd ${AUDIT_PATH}
IFS=" "
for qname in `echo ${QLIST}`
do
	if test -e CYCLERRS_traffic_${qname}.csv
	then
		mv CYCLERRS_traffic_${qname}.csv CYCLERRS_traffic_${qname}_${DATE}.csv
        	if test $? -ne 0
        	then
                	echo ""
                	echo "-*> mv of CYCLERRS_traffic_${qname}.csv was unsuccessful"
        	fi
	else
		echo ""
		echo "-*> The file, CYCLERRS_traffic_${qname}.csv, does not exist"
	fi
        touch CYCLERRS_traffic_${qname}.csv
        chmod 666 CYCLERRS_traffic_${qname}.csv
done

date

exit 0
