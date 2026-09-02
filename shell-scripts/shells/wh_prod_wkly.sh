#!/bin/sh
#
# Program Name	: wh_prod_wkly.sh
# Description	: Procedure to create extract files for Warehouses
#		  Command Line Arguments:
#		  -u <run type>
# Author	: Linda S. Jefferis
# Date		: 06/19/2016
# Modifications	: 08/18/2016 - Added carange01.sh process TT16007-3
#		: 09/14/2016 - add excep_extract to stop issues with the extract on Prod11.
#		: 05/09/2017 - TT13915-50; claim80rb/cardirb001 moved from Prod11 procedures.
#		: 06/26/2017 - TT17259-4; add onetm001 procedure.
#		: 11/28/2017 - TT17539-1; add dr340brb01 procedure.
#		: 09/18/2018 - TT13915-65; add rever04 process
#		: 05/05/2020 - TT3200-301; numotrb01
#		: 10/19/2021 - MULTOV project; multovrb01
#		: 12/30/2021 - Added clmsg (moved from wh_weekly_new.sh)
#		: 01/17/2022 - Move SUSRB001/NPICMSRB001 processes from wh_weekly_new.sh
#               : 12/21/2022 - Add REJMSGRB001 (rejmsg01) logic and move REJECRB001 (reject02) from prod11 process.
#		: 01/05/2023 - Move of override01 extract from prod11 processes
#		: 07/18/2023 - Move of gentb02 extract from prod11 processes
#		: 08/15/2023 - Add MCONF00MAS (mconfrb01) extract process
#		: 07/08/2024 - Add DRGPRCRB001 (drprc01) extract process
#               : 04/01/2025 - convert_to_batch.sh error trapping
#               : 05/11/2026 - add AWS bucket to copy the data warehouse file to aws location
#               : 05/20/2026 - DR340B0MAS file decommissioned removed from DW extract
#               : 05/20/2026 - Adding GRPGRPXMAS to extract process

#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
PATH=/usr/rmcobol:$PATH
RPT_DIR="/usr/lnk/rpt"
ZIP_PROG="/bin/gzip"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
AWS_DIR="s3://ga-internal-transfers/PDMI/Extracts/"
AWS_CP="/usr/local/bin/aws s3 cp"
AWS_CP_OPTS="--only-show-errors"
DATE=`date -d "yesterday 0800" +%Y%m%d`
SYS="00000000"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
SW=0
WK_START_DATE=`date -d "-7 days 0800" +%Y%m%d`
WK_END_DATE=`date -d "yesterday 0800" +%Y%m%d`
START_BATCH="A000"
END_BATCH="Z999"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_prod_wkly.sh

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

# Critical Process Error
error_process()
{
	MAIL_PROG=/usr/bin/mutt
	MAIL_ERR="operations@pdmi.com warehouse@pdmi.com deoncall@pdmi.com opsoncall@pdmi.com"
	echo -e "Critical error with ${PROG}\n${MSG}" | ${MAIL_PROG} -s "Warehouse Extract Error" ${MAIL_ERR}
}

# Select Run
sel_proc()
{
	${SEL_RUN}_extract
}

# Full Run
full_proc()
{
        grp_extract
        pln_extract
        gen_extract
	gentb_extract
        drug_extract
	drprc_extract
        phdem_extract
        phnet_extract
	rever_extract
  	card_extract
	reject_extract
	rejmsg_extract
        clmsg_extract
        excep_extract
        npicms_extract
  	catab_extract
	carang_extract
	multov_extract
	override_extract
	#cardi_extract
	claim80_extract
	onetm_extract
	numot_extract
	mconf_extract
	susp_extract
#	dr340b_extract
        grpxm_extract
}

#
# Transfer file
file_transfer()
{
if test -s ${FNAME}
then
	REC_CNT=`wc -l ${FNAME} | awk '{ print $1 }'`
        CNAME=${FNAME}-counts-${DATE}
        echo ${REC_CNT}","${DATE} > ${CNAME}
        mv ${FNAME} ${FNAME}-${DATE}
        gzip ${FNAME}-${DATE}
        gzip ${CNAME}
        ${AWS_CP} ${FNAME}-${DATE}.gz ${AWS_DIR} ${AWS_CP_OPTS}
        ${AWS_CP} ${CNAME}.gz ${AWS_DIR} ${AWS_CP_OPTS}
        mv ${FNAME}-${DATE}.gz ${SQL_DIR}/${OUT_DIR}
	if test $? -ne 0
	then
		echo "Error with transfer of ${FNAME}-${DATE}.gz"
		PROG="WH Extract File Transfer"
                MSG="Error with transfer of ${FNAME}-${DATE}.gz"
                error_process
	fi
	mv ${CNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${CNAME}.gz"
		PROG="WH Extract Count File Transfer"
                MSG="Error with transfer of ${FNAME}-${DATE}.gz"
                error_process
        fi
else
        echo "${FNAME} does not exist or is zero"
        PROG="${FNAME}"
        MSG="Extract file is zero or doesn't exist"
        error_process
fi
date
}

#
# Group Extract
grp_extract()
{
        echo "--> group extract - group10"
        ${SHELL_DIR}/group10.sh > ${RPT_DIR}/group10 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/group10`"
        echo "     `grep "ERROR" ${RPT_DIR}/group10`"
        FNAME=${GROUPRB001}
        file_transfer
}

#
# GRPGRPXMAS extract
grpxm_extract()
{
        echo
        echo "--> group XMAS  extract - grpgrprb01"
        ${SHELL_DIR}/grpgrprb01.sh > ${RPT_DIR}/grpgrprb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/grpgrprb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/grpgrprb01`"
        FNAME=${GRPGRPRB001}
        file_transfer
}

#
# Plan Extract
pln_extract()
{
        echo "--> plan extract - plan01"
        ${SHELL_DIR}/plan01.sh > ${RPT_DIR}/plan01 2>&1
        echo "     `grep "COUNT"  ${RPT_DIR}/plan01`"
        echo "     `grep "ERROR"  ${RPT_DIR}/plan01`"
        FNAME=${PLANRB001}
        file_transfer
}

#
# Generic Extract
gen_extract()
{
        echo "--> generic extract - gener01"
        ${SHELL_DIR}/gener01.sh > ${RPT_DIR}/gener01 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/gener01`"
        echo "     `grep "ERROR" ${RPT_DIR}/gener01`"
        FNAME=${GENERRB001}
        file_transfer
}

#
# GENTB extract
gentb_extract()
{
        echo "--> gentb extract - gentb02"
        ${SHELL_DIR}/gentb02.sh -f > ${RPT_DIR}/gentb02 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/gentb02`"
        echo "     `grep "ERROR" ${RPT_DIR}/gentb02`"
        FNAME=${GENTBRB001}
        file_transfer
}


#
# Drug Extract
drug_extract()
{
        echo
        echo "--> DRUG000MAS extract - drug002"
        ${SHELL_DIR}/drug002.sh > ${RPT_DIR}/drug002 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${DRUGRB001}`"
        echo "     `grep "ERROR" ${RPT_DIR}/drug002`"
        FNAME=${DRUGRB001}
        file_transfer
}

#
# DRPRC Extract
drprc_extract()
{
        echo
        echo "--> DRGPRC0MAS extract - drprc01"
        ${SHELL_DIR}/drprc01.sh -f > ${RPT_DIR}/drprc01 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/drprc01`"
        echo "     `grep "ERROR" ${RPT_DIR}/drprc01`"
        FNAME=${DRGPRCRB001}
        file_transfer
}

#
# Pharmacy Demographic Extract
phdem_extract()
{
        echo "--> full phdem extract - phdem03"
        ${SHELL_DIR}/phdem03.sh -f > ${RPT_DIR}/phdem03-full 2>&1
        echo "     TOTAL RECORDS:  `wc -l ${PHDEMRB001}`"
        echo "     `grep "ERROR" ${RPT_DIR}/phdem03-full`"
        FNAME=${PHDEMRB001}
        file_transfer
}

#
# Pharmacy Network Extract
phnet_extract()
{
        echo "--> full phnet extract - phnet12"
        NET=000000999999
        ${SHELL_DIR}/phnet12.sh -a ${NET} -f > ${RPT_DIR}/phnet12-full 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${PHNETRB001}`"
        echo "     `grep -a "ERROR" ${RPT_DIR}/phnet12-full`"
        FNAME=${PHNETRB001}
        file_transfer
}

#
# Reversal File Extract
rever_extract()
{
         echo "--> REVER00MAS extract - rever04"
        REV_START_DATE=`date -d "3 years ago" +%Y%m%d`
        REV_END_DATE=`date -d "yesterday" +%Y%m%d`
        REV_BATCH_START=`${SHELL_DIR}/convert_to_batch.sh ${REV_START_DATE}`${START_BATCH}
	RETVAL1=$?
        REV_BATCH_END=`${SHELL_DIR}/convert_to_batch.sh ${REV_END_DATE}`${END_BATCH}
        RETVAL2=$?
        if [ $RETVAL1 -ne 0 -o $RETVAL2 -ne 0 ]
        then
                echo "-*> Error with convert_to_batch.sh process. WH extract did not run."
                PROG=rever04
                MSG="Issue with convert_to_batch.sh process, so rever04 WH extract did not run"
                error_process
        else
                REV_BATCH_RANGE=${REV_BATCH_START}${REV_BATCH_END}
                ${SHELL_DIR}/rever04.sh -b ${REV_BATCH_RANGE} > ${RPT_DIR}/rever04 2>&1
                RETVAL=$?
                if [ ${RETVAL} = 99 ]
                then
                        PROG=rever04
                        MSG="Program error"
                        error_process
                        echo "  -*> ERROR with REVER04"
                        RETVAL=0
                else
                        echo "     `grep "WRITTEN" ${RPT_DIR}/rever04`"
                        echo "     `grep "ERROR" ${RPT_DIR}/rever04`"
                        FNAME=${REVERRB001}
                        file_transfer
                fi
        fi
}

#
# Card Extract
card_extract()
{
	echo
	echo "--> full card extract - cardh52"
	SYS=00010075
	${SHELL_DIR}/cardh52.sh -a ${SYS} -f > ${RPT_DIR}/cardh52-full 2>&1
	mv ${CARDHRB001}-FULL ${CARDHRB001}-FULL-1

	SYS=00799999
        ${SHELL_DIR}/cardh52.sh -a ${SYS} -f >> ${RPT_DIR}/cardh52-full 2>&1
        mv ${CARDHRB001}-FULL ${CARDHRB001}-FULL-2
        cat ${CARDHRB001}-FULL-1 >> ${CARDHRB001}
        cat ${CARDHRB001}-FULL-2 >> ${CARDHRB001}
        rm -f ${CARDHRB001}-FULL-1 ${CARDHRB001}-FULL-2
	FNAME=${CARDHRB001}
	file_transfer

	echo "     `grep "WRITTEN" ${RPT_DIR}/cardh52-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/cardh52-full`"
        echo "     `grep "BAD" ${RPT_DIR}/cardh52-full`"
}

#
# Card Table Extract
catab_extract()
{
	echo
	echo "--> CATAB00MAS extract - catab01"
	${SHELL_DIR}/catab01.sh -f > ${RPT_DIR}/catab01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/catab01`"
	echo "     `grep "ERROR" ${RPT_DIR}/catab01`"
	FNAME=${CATABRB001}
        file_transfer
}

#
# Card Range Extract
carang_extract()
{
        echo
        echo "--> CARANGEMAS extract - carange01"
        ${SHELL_DIR}/carange01.sh > ${RPT_DIR}/carange01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/carange01`"
        echo "     `grep "ERROR" ${RPT_DIR}/carange01`"
        FNAME=${CARANGERB1}
        file_transfer
}

#
# MULTOV0MAS Extract
multov_extract()
{
        echo
        echo "--> MULTOV0MAS extract - multovrb01"
        ${SHELL_DIR}/multovrb01.sh > ${RPT_DIR}/multovrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/multovrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/multovrb01`"
        FNAME=${MULTOVRB01}
        file_transfer
}

#
# Full EXCEPTION Extract
excep_extract()
{
        echo "--> full exception extract - excep01"
        ${SHELL_DIR}/excep01.sh -f > ${RPT_DIR}/excep01-full 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/excep01-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/excep01-full`"
        FNAME=${EXCEPRB001}
        file_transfer
}

#
# CLAIM80 Extract
claim80_extract()
{
        echo "--> 1 week claim80 extract - claim80rb"
        WK_BATCH_START=`${SHELL_DIR}/convert_to_batch.sh ${WK_START_DATE}`${START_BATCH}
        WK_BATCH_END=`${SHELL_DIR}/convert_to_batch.sh ${WK_END_DATE}`${END_BATCH}
        WK_BATCH_RANGE=${WK_BATCH_START}${WK_BATCH_END}
        ${SHELL_DIR}/claim80rb.sh -b ${WK_BATCH_RANGE} -o ${CLAIM80RB1} > ${RPT_DIR}/claim80rb-wk 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/claim80rb-wk`"
        echo "     `grep "ERROR" ${RPT_DIR}/claim80rb-wk`"
        FNAME=${CLAIM80RB1}
        file_transfer
}

#
# CARDI Extract
cardi_extract()
{
        echo "--> 1 week cardi extract - cardirb001"
        WK_DATE_RANGE=${WK_START_DATE}${WK_END_DATE}
        ${SHELL_DIR}/cardirb001.sh -d ${WK_DATE_RANGE} -o ${CARDIRBMAS} > ${RPT_DIR}/cardirb001-wk 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/cardirb001-wk`"
        echo "     `grep "ERROR" ${RPT_DIR}/cardirb001-wk`"
        FNAME=${CARDIRBMAS}
        file_transfer
}

#
# ONETM Extract
onetm_extract()
{
        echo "--> 1 week onetm extract - onetm001"
        WK_DATE_RANGE=${WK_START_DATE}${WK_END_DATE}
        ${SHELL_DIR}/onetm001.sh -d ${WK_DATE_RANGE} > ${RPT_DIR}/onetm001-wk 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/onetm001-wk`"
        echo "     `grep "ERROR" ${RPT_DIR}/onetm001-wk`"
        FNAME=${ONETMRB001}
        file_transfer
}

# NUMOT00MAS extract
numot_extract()
{
        echo
        echo "--> numot extract - numotrb01"
        ${SHELL_DIR}/numotrb01.sh -b last7days > ${RPT_DIR}/numotrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/numotrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/numotrb01`"
        FNAME=${NUMOTRB001}
        file_transfer
}

# DR340B0MAS extract
dr340b_extract()
{
        echo
        echo "--> DR340B0MAS extract - dr340brb01"
        echo "Process Date Range: ${WK_START_DATE}${WK_END_DATE}"
        ${SHELL_DIR}/dr340brb01.sh -d ${WK_START_DATE}${WK_END_DATE} > ${RPT_DIR}/dr340brb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/dr340brb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/dr340brb01`"
        FNAME=${DR340BRB001}
        file_transfer
}

#
# CLMSG File Extract
clmsg_extract()
{
        echo
        echo "--> clmsg file extract - clmsgrb01"
        WK_BATCH_START=`${SHELL_DIR}/convert_to_batch.sh ${WK_START_DATE}`${START_BATCH}
        WK_BATCH_END=`${SHELL_DIR}/convert_to_batch.sh ${WK_END_DATE}`${END_BATCH}
        WK_BATCH_RANGE=${WK_BATCH_START}${WK_BATCH_END}
        ${SHELL_DIR}/clmsgrb01.sh -b ${WK_BATCH_RANGE} > ${RPT_DIR}/clmsgrb01-week 2>&1
        echo "     TOTAL RECORDS:  `wc -l ${CLMSGRB001}`"
        FNAME=${CLMSGRB001}
        file_transfer
}

#
# CMS File Extract
npicms_extract()
{
        echo "--> NPICMS0MAS extract - npicms01"
        ${SHELL_DIR}/npicms01.sh -f > ${RPT_DIR}/npicms01 2>&1
        echo "     `grep "RECORDS READ:" ${RPT_DIR}/npicms01`"
        echo "     `grep "ERROR" ${RPT_DIR}/npicms01`"
        FNAME=${NPICMSRB001}
        file_transfer
}

#
# Suspend File Extract
susp_extract()
{
        echo "--> SUSP00MAS extract - susp004"
        ${SHELL_DIR}/susp004.sh -f > ${RPT_DIR}/susp004 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/susp004`"
        echo "     `grep "ERROR" ${RPT_DIR}/susp004`"
        FNAME=${SUSPRB001}
        file_transfer
}

#
# REJEC00MAS File Extract
reject_extract()
{
        echo
        echo "--> REJEC00MAS file extract - reject02"
        ${SHELL_DIR}/reject02.sh > ${RPT_DIR}/reject02 2>&1
        echo "     `grep "REJECRB COUNT" ${RPT_DIR}/reject02`"
        echo "     `grep "ERROR" ${RPT_DIR}/reject02`"
        FNAME=${REJECRB001}
        file_transfer
}

#
# REJMSG0MAS File Extract
rejmsg_extract()
{
        echo
        echo "--> REJMSG0MAS file extract - rejmsg01"
        ${SHELL_DIR}/rejmsg01.sh > ${RPT_DIR}/rejmsg01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rejmsg01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rejmsg01`"
        FNAME=${REJMSGRB001}
        file_transfer
}

#
# Full OVERRIDE Extract
override_extract()
{
        echo "--> full override extract - override01"
        ${SHELL_DIR}/override01.sh -f > ${RPT_DIR}/override01-full 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/override01-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/override01-full`"
        FNAME=${OVERIRB001}
        file_transfer
}

#
# MCONF00MAS File Extract
mconf_extract()
{
        echo
        echo "--> MCONF00MAS file extract - mconfrb01"
        ${SHELL_DIR}/mconfrb01.sh > ${RPT_DIR}/mconfrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/mconfrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/mconfrb01`"
        FNAME=${MCONFMRB01}
        file_transfer
}

#
# Main routine
#

umask 111

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -u) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SW=1
	SEL_RUN=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

date

if [ $SW = 1 ]
then
	sel_proc
else
	full_proc
fi

date

exit 0
