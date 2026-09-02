#!/bin/ksh
#
# Program Name	: wh_daily_prod_new.sh
# Description	: Procedure to create extract files for Warehouses
#		  Command Line Arguments:
#		  -u <run type>
# Author	: Linda S. Jefferis
# Date		: 01/10/2011
# Modifications : 04/19/2011 - Add logic for new spons01 extract
#		: 06/07/2011 - Changed drug_extract to daily
#		: 09/23/2011 - Add rever04.sh logic
#		: 10/10/2011 - Added adminrb01.sh and rebferb01.sh logic
#		: 12/05/2011 - Add clcmprb01 and clcobrb01 logic
#		: 12/06/2011 - Add batch range logic to clcobrb01 process
#		: 01/09/2012 - Add exclurb01 logic
#		: 03/20/2012 - Add macfarb01 logic
#		: 05/01/2012 - Add clmsgrb01 logic
#		: 08/02/2012 - Move cardirb001 later in order (running too long)
#		: 03/10/2016 - TT13309-6
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
DIR_1=/usr/lnk/tmp
WH_DIR=/usr/lnk/sqlimports/misc
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
DATE=`date -d "yesterday 0800" +%Y%m%d`
DAY=`date +%w`
PROCESS_DATE=`date -d "yesterday 0800" +%Y%m%d`
NET="000000000000"
SYS="00000000"
FLEX="/usr/lnk/flexgen"
REIMB_EXTRACT="${WH_DIR}/ohrmbrb001"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
SW=0
START_DATE=20120101
PDE_START_DATE=20100101
PDE_END_DATE=`date -d "yesterday 0800" +%Y%m%d`
START_BATCH="A000"
END_BATCH="Z999"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_daily_prod_new.sh

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

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
	sponsor_extract
  	gen_extract
  	pln_extract
  	copay_extract
  	card_extract
  	phdem_extract
  	phnet_extract
  	mac_extract
  	reimb_extract
  	excep_extract
  	override_extract
	drug_extract
  	susp_extract
  	check_extract
  	catab_extract
  	gentb_extract
  	phys_extract
  	diftb_extract
  	firtr_extract
	site_extract
	admin_extract
	rebfe_extract
	rever_extract
	exclu_extract
	macfa_extract
	clcmp_extract
	clcob_extract
	pdeds_extract
	clmsg_extract
  	pdecl_extract

	if [ ${DAY} = 3 ]
  	then
        	mednam_extract
        	medndc_extract
        	medval_extract
        	step_extract
  	fi

	claim80_extract
	cardi_extract
}

#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
	gzip ${FNAME}
	mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
	if test $? -ne 0
	then
		echo "Error with transfer of ${FNAME}"
	fi
else
	echo "${FNAME} does not exist"
fi
date
}




# Claim80 Extract
claim80_extract()
{
	echo
	echo "--> claim80 extract - claim80rb"
	${SHELL_DIR}/claim80rb.sh > ${RPT_DIR}/claim80rb 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/claim80rb`"
	echo "     `grep "ERROR" ${RPT_DIR}/claim80rb`"
	mv ${CLAIM80RB1} ${CLAIM80RB1}-${DATE}
	FNAME=${CLAIM80RB1}-${DATE}
	file_transfer
}

#
# Group Extract
grp_extract()
{
	echo
	echo "--> group extract - group10"
	${SHELL_DIR}/group10.sh > ${RPT_DIR}/group10 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/group10`"
	echo "     `grep "ERROR" ${RPT_DIR}/group10`"
	mv ${GROUPRB001} ${GROUPRB001}-${DATE}
	FNAME=${GROUPRB001}-${DATE}
	file_transfer
}

#
# Plan Extract
pln_extract()
{
	echo
	echo "--> plan extract - plan01"
	${SHELL_DIR}/plan01.sh > ${RPT_DIR}/plan01 2>&1
        echo "     `grep "COUNT"  ${RPT_DIR}/plan01`"
        echo "     `grep "ERROR"  ${RPT_DIR}/plan01`"
	mv ${PLANRB001} ${PLANRB001}-${DATE}
	FNAME=${PLANRB001}-${DATE}
        file_transfer
}

#
# Copay Extract
copay_extract()
{
	echo
	echo "--> copay extract - copay01"
	${SHELL_DIR}/copay01.sh > ${RPT_DIR}/copay01 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/copay01`"
        echo "     `grep "ERROR" ${RPT_DIR}/copay01`"
	mv ${COPAYRB001} ${COPAYRB001}-${DATE}
	FNAME=${COPAYRB001}-${DATE}
        file_transfer
}


#
# Generic Extract
gen_extract()
{
	echo
	echo "--> generic extract - gener01"
	${SHELL_DIR}/gener01.sh > ${RPT_DIR}/gener01 2>&1
	echo "     `grep "COUNT" ${RPT_DIR}/gener01`"
	echo "     `grep "ERROR" ${RPT_DIR}/gener01`"
	mv ${GENERRB001} ${GENERRB001}-${DATE}
	FNAME=${GENERRB001}-${DATE}
        file_transfer
}

#
# Card Extract
card_extract()
{
	echo
	echo "--> card extract - cardh52"
	SYS=00019999
	${SHELL_DIR}/cardh52.sh -a ${SYS} > ${RPT_DIR}/cardh52 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/cardh52`"
	mv ${CARDHRB001} ${CARDHRB001}-${DATE}
	FNAME=${CARDHRB001}-${DATE}
	file_transfer
}

#
# Card Table Extract
catab_extract()
{
	echo
	echo "--> CATAB00MAS extract - catab01"
	${SHELL_DIR}/catab01.sh > ${RPT_DIR}/catab01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/catab01`"
	echo "     `grep "ERROR" ${RPT_DIR}/catab01`"
	mv ${CATABRB001} ${CATABRB001}-${DATE}
	FNAME=${CATABRB001}-${DATE}
        file_transfer
}

#
# Pharmacy Demographic Extract
phdem_extract()
{
	echo
	echo "--> phdem extract - phdem03"
	${SHELL_DIR}/phdem03.sh > ${RPT_DIR}/phdem03 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${PHDEMRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/phdem03`"
	mv ${PHDEMRB001} ${PHDEMRB001}-${DATE}
	FNAME=${PHDEMRB001}-${DATE}
        file_transfer
}

#
# Pharmacy Network Extract
phnet_extract()
{
	echo
	echo "--> phnet extract - phnet12"
	NET=000000999999
	${SHELL_DIR}/phnet12.sh -a ${NET} > ${RPT_DIR}/phnet12 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${PHNETRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/phnet12`"
	mv ${PHNETRB001} ${PHNETRB001}-${DATE}
	FNAME=${PHNETRB001}-${DATE}
        file_transfer
}

#
# CARDI extract
cardi_extract()
{
	echo
	echo "--> cardi extract - cardirb001"
	echo "Process Date Range: ${PROCESS_DATE}${PROCESS_DATE}"
	${SHELL_DIR}/cardirb001.sh -d ${PROCESS_DATE}${PROCESS_DATE} > ${RPT_DIR}/cardirb001 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/cardirb001`"
	echo "     `grep "ERROR" ${RPT_DIR}/cardirb001`"
	mv ${CARDIRBMAS} ${CARDIRBMAS}-${DATE}
	FNAME=${CARDIRBMAS}-${DATE}
        file_transfer
}

#
# MAC extract
mac_extract()
{
	echo
	echo "--> mac extract - mac002"
	${SHELL_DIR}/mac002.sh > ${RPT_DIR}/mac002 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/mac002`"
	echo "     `grep "ERROR" ${RPT_DIR}/mac002`"
	mv ${MAC00RB001} ${MAC00RB001}-${DATE}
	FNAME=${MAC00RB001}-${DATE}
        file_transfer
}

#
# REIMB extract
reimb_extract()
{
	echo
	echo "--> reimb extract - ohrmbrb001.cs"
	cd ${FLEX}
	${FLEX}/ohrmbrb001.cs
	echo "     TOTAL RECORDS:  `wc -l ${REIMB_EXTRACT}`"
	mv ${REIMB_EXTRACT} ${REIMB_EXTRACT}-${DATE}
	FNAME=${REIMB_EXTRACT}-${DATE}
        file_transfer
}
	
#
# EXCEPTION extract
excep_extract()
{
	echo
	echo "--> exception extract - excep01"
	${SHELL_DIR}/excep01.sh > ${RPT_DIR}/excep01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/excep01`"
	#echo "     TOTAL RECORDS:  `wc -l ${EXCEPRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/excep01`"
	mv ${EXCEPRB001} ${EXCEPRB001}-${DATE}
	FNAME=${EXCEPRB001}-${DATE}
        file_transfer
}

#
# OVERRIDE extract
override_extract()
{
	echo
	echo "--> override extract - override01"
	${SHELL_DIR}/override01.sh > ${RPT_DIR}/override01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/override01`"
	echo "     `grep "ERROR" ${RPT_DIR}/override01`"
	mv ${OVERIRB001} ${OVERIRB001}-${DATE}
	FNAME=${OVERIRB001}-${DATE}
        file_transfer
}

#
# PDECL00MAS extract
pdecl_extract()
{
	echo
	echo "--> PDECL00MAS extract - pdecl02"
	PDE_START_BATCH=`${SHELL_DIR}/convert_to_batch.sh ${PDE_START_DATE}`${START_BATCH}
        PDE_END_BATCH=`${SHELL_DIR}/convert_to_batch.sh ${PDE_END_DATE}`${END_BATCH}
        PDE_BATCH_RANGE=${PDE_START_BATCH}${PDE_END_BATCH}
	${SHELL_DIR}/pdecl02.sh -b ${PDE_BATCH_RANGE} > ${RPT_DIR}/pdecl02 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${PDECLRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/pdecl02`"
	mv ${PDECLRB001} ${PDECLRB001}-${DATE}
	FNAME=${PDECLRB001}-${DATE}
        file_transfer
}

#
# GENTB extract
gentb_extract()
{
	echo
	echo "--> GENTB00MAS extract - gentb02"
	${SHELL_DIR}/gentb02.sh -f > ${RPT_DIR}/gentb02 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/gentb02`"
	echo "     `grep "ERROR" ${RPT_DIR}/gentb02`"
	mv ${GENTBRB001} ${GENTBRB001}-${DATE}
	FNAME=${GENTBRB001}-${DATE}
        file_transfer
}

#
# PHYS extract
phys_extract()
{
	echo
	echo "--> PHYSI00MAS extract - physi01"
	${SHELL_DIR}/physi01.sh > ${RPT_DIR}/physi01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/physi01`"
	echo "     `grep "ERROR" ${RPT_DIR}/physi01`"
	mv ${PHYSIRB001} ${PHYSIRB001}-${DATE}
	FNAME=${PHYSIRB001}-${DATE}
        file_transfer
}

#
# DIFTB extract
diftb_extract()
{
	echo
	echo "--> DIFTB00MAS extract - diftb01"
	${SHELL_DIR}/diftb01.sh > ${RPT_DIR}/diftb01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/diftb01`"
	echo "     `grep "ERROR" ${RPT_DIR}/diftb01`"
	mv ${DIFTBRB001} ${DIFTBRB001}-${DATE}
	FNAME=${DIFTBRB001}-${DATE}
        file_transfer
}

#
# FIRTR extract
firtr_extract()
{
	echo
	echo "--> FIRTR00MAS extract - firtr02"
	${SHELL_DIR}/firtr02.sh > ${RPT_DIR}/firtr02 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/firtr02`"
	echo "     `grep "ERROR" ${RPT_DIR}/firtr02`"
	mv ${FIRTRRB001} ${FIRTRRB001}-${DATE}
	FNAME=${FIRTRRB001}-${DATE}
        file_transfer
}

#
# SITE extract
site_extract()
{
        echo
        echo "--> SITE000MAS extract - site01"
        ${SHELL_DIR}/site01.sh > ${RPT_DIR}/site01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/site01`"
        echo "     `grep "ERROR" ${RPT_DIR}/site01`"
	mv ${SITERB001} ${SITERB001}-${DATE}
	FNAME=${SITERB001}-${DATE}
	file_transfer
}

#
# Drug Extract
drug_extract()
{
	echo
	echo "--> DRUG000MAS extract - drug002"
        ${SHELL_DIR}/drug002.sh > ${RPT_DIR}/drug002 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/drug002`"
        echo "     `grep "ERROR" ${RPT_DIR}/drug002`"
	mv ${DRUGRB001} ${DRUGRB001}-${DATE}
	FNAME=${DRUGRB001}-${DATE}
        file_transfer
}

#
# MEDNAM Extract
mednam_extract()
{
	echo
	echo "--> MEDNAM0MAS extract - medirb01"
        ${SHELL_DIR}/medirb01.sh > ${RPT_DIR}/medirb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/medirb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/medirb01`"
	mv ${MEDNAME} ${MEDNAME}-${DATE}
	FNAME=${MEDNAME}-${DATE}
        file_transfer
}

#
# MEDNDC Extract
medndc_extract()
{
	echo
	echo "--> MEDNDC0MAS extract - medirb02"
        ${SHELL_DIR}/medirb02.sh > ${RPT_DIR}/medirb02 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/medirb02`"
        echo "     `grep "ERROR" ${RPT_DIR}/medirb02`"
	mv ${MEDNDC} ${MEDNDC}-${DATE}
	FNAME=${MEDNDC}-${DATE}
        file_transfer
}

#
# MEDVAL Extract
medval_extract()
{
	echo
	echo "--> MEDVAL0MAS extract - medirb03"
        ${SHELL_DIR}/medirb03.sh > ${RPT_DIR}/medirb03 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/medirb03`"
        echo "     `grep "ERROR" ${RPT_DIR}/medirb03`"
	mv ${MEDVAL} ${MEDVAL}-${DATE}
	FNAME=${MEDVAL}-${DATE}
        file_transfer
}

#
# Step Therapy Extract
step_extract()
{
	echo
	echo "--> STEPT00MAS extract - steptrb01"
	${SHELL_DIR}/steptrb01.sh > ${RPT_DIR}/steptrb01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/steptrb01`"
	echo "     `grep "ERROR" ${RPT_DIR}/steptrb01`"
	mv ${STEPTRB001} ${STEPTRB001}-${DATE}
	FNAME=${STEPTRB001}-${DATE}
        file_transfer
}

#
# Suspend File Extract
susp_extract()
{
	echo
	echo "--> suspend file extract - susp004"
	${SHELL_DIR}/susp004.sh > ${RPT_DIR}/susp004 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/susp004`"
	echo "     `grep "ERROR" ${RPT_DIR}/susp004`"
	mv ${SUSPRB001} ${SUSPRB001}-${DATE}
	FNAME=${SUSPRB001}-${DATE}
        file_transfer
}

#
# Check File Extract
check_extract()
{
	echo
	echo "--> check file extract - check04"
	${SHELL_DIR}/check04.sh > ${RPT_DIR}/check04 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/check04`"
	echo "     `grep "ERROR" ${RPT_DIR}/check04`"
	mv ${CHECKRB001} ${CHECKRB001}-${DATE}
	FNAME=${CHECKRB001}-${DATE}
        file_transfer
}

#
# Sponsor File Extract
sponsor_extract()
{
	echo
	echo "--> sponsor file extract - spons01"
	${SHELL_DIR}/spons01.sh > ${RPT_DIR}/spons01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/spons01`"
	echo "     `grep "ERROR" ${RPT_DIR}/spons01`"
	mv ${SPONSRB001} ${SPONSRB001}-${DATE}
	FNAME=${SPONSRB001}-${DATE}
        file_transfer
}

#
# Reversal File Extract
rever_extract()
{
	echo
	echo "--> reversal file extract - rever04"
	${SHELL_DIR}/rever04.sh > ${RPT_DIR}/rever04 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/rever04`"
	echo "     `grep "ERROR" ${RPT_DIR}/rever04`"
	mv ${REVERRB001} ${REVERRB001}-${DATE}
	FNAME=${REVERRB001}-${DATE}
        file_transfer
}

#
# Admin File Extract
admin_extract()
{
	echo
	echo "--> admin file extract - adminrb01"
	${SHELL_DIR}/adminrb01.sh > ${RPT_DIR}/adminrb01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/adminrb01`"
	echo "     `grep "ERROR" ${RPT_DIR}/adminrb01`"
	mv ${ADMINRB001} ${ADMINRB001}-${DATE}
	FNAME=${ADMINRB001}-${DATE}
        file_transfer
}

#
# REBFE00MAS File Extract
rebfe_extract()
{
	echo
	echo "--> rebfe file extract - rebferb01"
	${SHELL_DIR}/rebferb01.sh > ${RPT_DIR}/rebferb01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/rebferb01`"
	echo "     `grep "ERROR" ${RPT_DIR}/rebferb01`"
	mv ${REBFERB001} ${REBFERB001}-${DATE}
	FNAME=${REBFERB001}-${DATE}
        file_transfer
}

#
# CLCMP00MAS File Extract
clcmp_extract()
{
	echo
	echo "--> clcmp file extract - clcmprb01"
	${SHELL_DIR}/clcmprb01.sh > ${RPT_DIR}/clcmprb01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/clcmprb01`"
	echo "     `grep "ERROR" ${RPT_DIR}/clcmprb01`"
	mv ${CLCMPRB001} ${CLCMPRB001}-${DATE}
	FNAME=${CLCMPRB001}-${DATE}
        file_transfer
}

#
# CLCOB00MAS File Extract
clcob_extract()
{
	echo
	echo "--> clcob file extract - clcobrb01"
	CLCOB_START_BATCH=`${SHELL_DIR}/convert_to_batch.sh ${PROCESS_DATE}`${START_BATCH}
        CLCOB_END_BATCH=`${SHELL_DIR}/convert_to_batch.sh ${PROCESS_DATE}`${END_BATCH}
        CLCOB_BATCH_RANGE=${CLCOB_START_BATCH}${CLCOB_END_BATCH}
	${SHELL_DIR}/clcobrb01.sh -b ${CLCOB_BATCH_RANGE} > ${RPT_DIR}/clcobrb01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/clcobrb01`"
	echo "     `grep "ERROR" ${RPT_DIR}/clcobrb01`"
	mv ${CLCOBRB001} ${CLCOBRB001}-${DATE}
	FNAME=${CLCOBRB001}-${DATE}
        file_transfer
}

#
# EXCLU00MAS File Extract
exclu_extract()
{
        echo
        echo "--> exclu00mas file extract - exclurb01"
        ${SHELL_DIR}/exclurb01.sh > ${RPT_DIR}/exclurb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/exclurb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/exclurb01`"
        mv ${EXCLURB001} ${EXCLURB001}-${DATE}
        FNAME=${EXCLURB001}-${DATE}
        file_transfer
}

#
# MACFA00MAS File Extract
macfa_extract()
{
        echo
        echo "--> macfa00mas file extract - macfarb01"
        ${SHELL_DIR}/macfarb01.sh > ${RPT_DIR}/macfarb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/macfarb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/macfarb01`"
        mv ${MACFARB001} ${MACFARB001}-${DATE}
        FNAME=${MACFARB001}-${DATE}
        file_transfer
}

#
# PDEDS00MAS File Extract
pdeds_extract()
{
        echo
        echo "--> pdeds00mas file extract - ohpddpc001"
        ${SHELL_DIR}/ohpddpc001.sh > ${RPT_DIR}/ohpddpc001 2>&1
        echo "     TOTAL RECORDS:  `wc -l ${PDEDSRB001}`"
        mv ${PDEDSRB001} ${PDEDSRB001}-${DATE}
        FNAME=${PDEDSRB001}-${DATE}
        file_transfer
}

#
# CLMSG File Extract
clmsg_extract()
{
        echo
        echo "--> clmsg file extract - clmsgrb01"
        ${SHELL_DIR}/clmsgrb01.sh > ${RPT_DIR}/clmsgrb01 2>&1
        echo "     TOTAL RECORDS:  `wc -l ${CLMSGRB001}`"
        mv ${CLMSGRB001} ${CLMSGRB001}-${DATE}
        FNAME=${CLMSGRB001}-${DATE}
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
