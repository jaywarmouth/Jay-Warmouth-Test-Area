#!/bin/sh
#
# Program Name	: audit-cmp.sh
# Description	: Compares AUDIT files to see if need to do final re-update for previous day.

# Variables Used:
umask 002
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
DATE=`date -d "yesterday 0800" +%Y%m%d`
AUD_DIR="/usr/lnk/audit"
PROD_SYS="prod10"
ZIP_PROG="/usr/lnk/shell/zippass.sh"
SW="NNNYNNNN"

# Load the configuration file
CONFIG_FILE="/usr/local/etc/claim96.conf"
if [[ -f $CONFIG_FILE ]]; then
    source $CONFIG_FILE
else
    echo "Configuration file $CONFIG_FILE not found."
    exit 1
fi

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: audit-cmp.sh 

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

# Compare and claim96 process
compare_claim96() {
    local prefix=$1
    local numbers=("${!2}")
    local count=$3
    for ((i=0; i<count; i++)); do
	local filename=${prefix}-${numbers[i]}-${DATE}
        if [[ -f ${AUD_DIR}/${filename}.cmp ]]; then
		cmp -s ${AUD_DIR}/${filename}.cmp ${AUD_DIR}/${filename}.${PROD_SYS}
		if test $? -ne 0
		then
        		mv ${AUD_DIR}/${filename}.cmp ${AUD_DIR}/${filename}.${PROD_SYS}
        		AUDIT20MAS=${AUD_DIR}/${filename}.${PROD_SYS}
        		export AUDIT20MAS
        		echo -e "\nFiles not equal: "$AUDIT20MAS
        		runcobol ${OBJ_DIR}/claim96 -a ${SW}
      		else
        		echo -e "\nFiles were equal: "${AUD_DIR}/${filename}
        		rm ${AUD_DIR}/${filename}.cmp
      		fi
    	else
      		echo -e "\nCould not compare ${AUD_DIR}/${filename}.cmp --- File did not exist"
    	fi
    done
}

# Compare and claim96 process for DMR files
compare_dmr() {
    	local prefix=$1
	local filename=${prefix}
        if [[ -f ${AUD_DIR}/${filename}-${DATE}.cmp ]]; then
		cmp -s ${AUD_DIR}/${filename}-${DATE}.cmp ${AUD_DIR}/${filename}-${DATE}.${PROD_SYS}
		if test $? -ne 0
		then
        		mv ${AUD_DIR}/${filename}-${DATE}.cmp ${AUD_DIR}/${filename}-${DATE}.${PROD_SYS}
        		AUDIT20MAS=${AUD_DIR}/${filename}-${DATE}.${PROD_SYS}
        		export AUDIT20MAS
        		echo -e "\nFiles not equal: "$AUDIT20MAS
        		runcobol ${OBJ_DIR}/claim96 -a ${SW}
      		else
        		echo -e "\nFiles were equal: "${AUD_DIR}/${filename}-${DATE}
        		rm ${AUD_DIR}/${filename}-${DATE}.cmp
      		fi
    	else
      		echo -e "\nCould not compare ${AUD_DIR}/${filename}-${DATE}.cmp --- File did not exist"
    	fi
}

# Compare and claim96 process for CLAIM02 files
compare_spec() {
    	local prefix=$1
	local filename=${prefix}
        if [[ -f ${AUD_DIR}/${filename}.cmp ]]; then
		cmp -s ${AUD_DIR}/${filename}.cmp ${AUD_DIR}/${filename}-${DATE}.${PROD_SYS}
		if test $? -ne 0
		then
        		mv ${AUD_DIR}/${filename}.cmp ${AUD_DIR}/${filename}-${DATE}.${PROD_SYS}
        		AUDIT20MAS=${AUD_DIR}/${filename}-${DATE}.${PROD_SYS}
        		export AUDIT20MAS
        		echo -e "\nFiles not equal: "$AUDIT20MAS
        		runcobol ${OBJ_DIR}/claim96 -a ${SW}
      		else
        		echo -e "\nFiles were equal: "${AUD_DIR}/${filename}-${DATE}
        		rm ${AUD_DIR}/${filename}.cmp
      		fi
    	else
      		echo -e "\nCould not compare ${AUD_DIR}/${filename}.cmp --- File did not exist"
    	fi
}

# Compare only claim96 process
compare_noclaim96() {
    local prefix=$1
    local numbers=("${!2}")
    local count=$3
    for ((i=0; i<count; i++)); do
	local filename=${prefix}-${numbers[i]}-${DATE}
        if [[ -f ${AUD_DIR}/${filename}.cmp ]]; then
		cmp -s ${AUD_DIR}/${filename}.cmp ${AUD_DIR}/${filename}.${PROD_SYS}
		if test $? -ne 0
		then
        		mv ${AUD_DIR}/${filename}.cmp ${AUD_DIR}/${filename}.${PROD_SYS}
      		else
        		echo -e "\nFiles were equal: "${AUD_DIR}/${filename}
        		rm ${AUD_DIR}/${filename}.cmp
      		fi
    	else
      		echo -e "\nCould not compare ${AUD_DIR}/${filename}.cmp --- File did not exist"
    	fi
    done
}

# Zip all previous day's audit files
zipfiles()
{
	cd ${AUD_DIR}
        ${ZIP_PROG} -m auditfiles-${DATE}.zip *${DATE}.prod*
}

#
# Main routine
#

# Parse environment variables
parse_env

echo ""
echo "*** AUDIT-CMP Procedure ***"
echo ""
compare_claim96 "AUDIT" QNUMBERS[@] $QCOUNT
compare_dmr "DMR"
compare_spec "CLAIM02"
compare_claim96 "MSG" QNUMBERS[@] $QCOUNT
compare_claim96 "CLMSS" QNUMBERS[@] $QCOUNT
compare_noclaim96 "EFSS" QNUMBERS[@] $QCOUNT
compare_noclaim96 "SCSS" QNUMBERS[@] $QCOUNT


echo "--> Zipping Files"
zipfiles

date

