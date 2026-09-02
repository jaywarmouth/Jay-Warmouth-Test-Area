#!/bin/ksh
#
# Program Name	: audit_mv_sat.sh
# Description	: Rename and reset FG4AUD, GRPAUD, LIMAUD, PHAAUD, EMBAUD, REVAUD, CHKAUD, CRDAUD, PDEAUD and CLAIM02 audits
# Author	: Linda S. Jefferis
# Date		: 07/29/97
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SHELL_DIR="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
TMP_PATH="/usr/lnk/tmp"
#AUDIT_PATH="/usr/lnk/audit"
AUDIT_PATH="/usr/lnk/audit/backup"
AUDCTRL="/usr/lnk/audctrl"
DATE=`date +%m%d%y`
DATE_2=`date +%Y%m%d`
BACKUP_1="prod11"
BACKUP_2="husk"
BACKUP_3="robin"
BACKUP_4="prod20"
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

usage: audit_mv_sat.sh 

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
if ! test -e ${AUDIT_PATH}/STPTMP0MAS-${DATE_2}
then
	cp ${AUDIT_PATH}/STPTMP0MAS.null ${AUDIT_PATH}/STPTMP0MAS-${DATE_2}
	if test $? -ne 0
	then
		echo ""
		echo "-*> creation of STPTMP0MAS-${DATE_2} failed"
	else
		chmod 666 ${AUDIT_PATH}/STPTMP0MAS-${DATE_2}
		chgrp c04 ${AUDIT_PATH}/STPTMP0MAS-${DATE_2}
	fi
fi

echo ""
echo "--> Copying CLAIM02 to BACKUP systems"
scp ${AUDIT_PATH}/CLAIM02.${DATE} ${BACKUP_1}:/${AUDIT_PATH}/CLAIM02-${DATE}.cmp
scp ${AUDIT_PATH}/CLAIM02.${DATE} ${BACKUP_2}:/${AUDIT_PATH}/CLAIM02-${DATE}.cmp
scp ${AUDIT_PATH}/CLAIM02.${DATE} ${BACKUP_3}:/${AUDIT_PATH}/CLAIM02-${DATE}.cmp
scp ${AUDIT_PATH}/CLAIM02.${DATE} ${BACKUP_4}:/${AUDIT_PATH}/CLAIM02-${DATE}.cmp
scp ${AUDIT_PATH}/CLAIM02.${DATE} ${BACKUP_5}:/${AUDIT_PATH}/CLAIM02-${DATE}.cmp

date


exit 0
