#!/bin/sh
#
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
AUDIT_PATH="/usr/lnk/audit"
DATE=`date -d "yesterday 0800" +%Y%m%d`
CURR_DATE=`date +%Y%m%d`
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

# DMR file
if ! test -e ${AUDIT_PATH}/DMR-${CURR_DATE}
then
	touch ${AUDIT_PATH}/DMR-${CURR_DATE}
	if test $? -ne 0
	then
		echo ""
		echo "-*> creation of DMR-${CURR_DATE} failed"
	else
		chmod 666 ${AUDIT_PATH}/DMR-${CURR_DATE}
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
