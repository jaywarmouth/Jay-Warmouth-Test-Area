#!/bin/sh
#
# Program Name	: wh_daily_files.sh
# Description	: Procedure to create extract files for Warehouses
#		  Command Line Arguments:
#		  -u <run type>
# Author	: Linda S. Jefferis
# Date		: 08/20/2012
# Modifications : 09/26/2012 - Added logic for thint01 process (was only being run weekly)
#		: 12/10/2012 - Added logic for restack11 process
#		: 04/09/2013 - Add logic for cldemrb01 process
#		: 04/26/2013 - Add logic for npicms01
#		: 12/18/2013 - Add logic for cardh60 (EMBOS00MAS extract)
#		: 09/12/2014 - Add logic for brkdem01 process (TT:10152-15)(DME)
#		: 09/22/2014 - Add logic for PNDES and PERMS files (TTs: 11892-4 and 11609-2)
#		: 11/05/2014 - Replace ohrmbrb001 logic with reimbrb01.sh logic  (TT #12131-3)
#		: 03/27/2015 - RETVAL logic for rever04 (TT #8641-9)
#		: 04/28/2015 - Add logic for nsderb01 and nsdeovrb01 (TT:12829-43, 12829-47)
#		: 04/30/2015 - TT:283-39 (reject02 logic)
#		: 06/15/2015 - TT:9621-30 (spectbrb01 logic)
#		: 06/29/2015 - TT:12938-16 (tpmrb01 logic)
#		: 08/05/2015 - TT:13950-1 (exdesrb01 logic)
#		: 08/18/2015 - TT:14187-2 (spcfgrb01 logic)(DME)
#		: 08/25/2015 - TT:13940-9 (cmsrb001 logic)
#		: 9/30/2015 - TT:13915-13 (gdesc01 logic)
#		: 11/2/2015 - TT:13507-27 re-order request
#		: 12/2/2015 - TT9621-54 (sptdsrb01,spcfdrb01 logic)
#		: 01/07/2016 - TT146709-5 (teamrb01 logic)
#		: 3/3/2016 - Change catab01 process to full file daily.
#		: 03/10/2016 - TT13309-6
#		: 03/30/2016 - TT13915-24 - Updated PDE Start date from 20110101 to 20130101.
#		: 4/11/2016 - TT12225-40 (Add bincfrb01.sh process)
#		: 07/07/2016 - TT15027-8 (rebadrb01.sh process)
#		: 09/14/2016 - move of excep_extract to Prod10 process
#		: 09/30/2016 - TT15810-10,TT13990-56 (altpr0001/enrolrb01)
#		: 11/15/2016 - TT15054-7 (benef01)
#		: 01/31/2017 - TT15456-3 (reimbrb02)
#               : 02/23/2017 - TT2879-23 (permirb01)
#		: 05/09/2017 - TT13915-50; move claim80rb and cardirb001 procedures to Prod10.
#		: 07/17/2017 - TT17453-1; fix RETVAL logic
#		: 09/06/2017 - TT8864-45,TT8864-54 (rbaddrb01,rbadmrb01)
#		: 10/30/2017 - phalock01 logic added.
#		: 11/01/2017 - TT:17652-6; prcovrb01
#		: 11/03/2017 - Added Batch Range For the rever04
#		: 11/20/2017 - TT:17552-34; ndcdm01,ndcom01 logic
#		: 12/08/2017 - TT17552-7; gdrsd01 logic
#		: 05/23/2018 - TT18207-55; rejcd01 logic
#		: 06/11/2018 - TT8864-74; removal of RBADD00MAS extract logic.
#		: 6/26/2018 - TT8864-68; rbadfrb01, rbadrrb01
#		: 07/06/2018 - TT18726-1; ovdesrb01
#		: 11/05/2018 - TT18977-29
#		: 11/12/2018 - TT18977-7; bintyrb01
#		: 12/04/2018 - TT18987-32; difctrb01
#		: 01/15/2019 - TT18824-32; npirb01
#               : 06/03/2019 - TT19688-4, TT19645-6; config01, mconfigrb01
#		: 06/17/2019 - TT19730-6, TT19736-6; rcode01, rcd01
#		: 06/17/2019 - changed MAIL_ERR
#		: 07/02/2019 - TT19747-6 rcp01
#               : 07/18/2019 - TT13915-65; move rever04 to Prod10
#		: 10/02/2019 - TT19941-4; STEXCRB001
#		: 03/06/2020 - Tasks 20025-13 20027-12; drdesrb01 and drug003rb01
#		: 12/28/2021 - Moved CLMSG to wh_prod_dly.sh
#		: 01/18/2022 - Moved SUSP/NPICMS to wh_prod_dly.sh
#		: 04/19/2022 - logic for new NDCINC0MAS/NDCINCRB001/ndcinc01
#		: 04/19/2022 - stop PDECL00MAS extract
#		: 07/18/2022 - Add new tgrpwh01.sh process and TBRBENRB001 (under existing brben01)
#		: 12/21/2022 - remove reject_extract logic; moved to wh_prod scripts
#		: 01/05/2023 - move of override01 extract to wh_prod scripts
#		: 07/18/2023 - move of gentb extract to wh_prod scripts
#		: 02/26/2024 - add stcomp01 extract process
#		: 04/11/2024 - add stcfg01 extract process
#		: 09/29/2024 - add ndchk01 extract process
#               : 03/25/2025 - Add cagrpxrb01 extract process
#               : 04/01/2025 - convert_to_batch.sh error trapping
#               : 10/23/2025 - Add cabin01.sh in sprint 551 for CABIN00MAS file extract
#               : 02/24/2026 - add AWS bucket to copy the data warehouse file to aws location
#               : 04/15/2026 - fix the IFS variable set
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
PATH=/usr/rmcobol:$PATH
RPT_DIR="/usr/lnk/rpt"
ZIP_PROG="/bin/gzip"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
AWS_DIR="s3://ga-internal-transfers/PDMI/Extracts/"
AWS_CP="/usr/local/bin/aws s3 cp"
AWS_CP_OPTS="--only-show-errors"
DATE=`date -d "yesterday 0800" +%Y%m%d`
PROCESS_DATE=`date -d "yesterday 0800" +%Y%m%d`
NET="000000000000"
SYS="00000000"
FLEX="/usr/lnk/flexgen"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
SW=0
PDE_START_DATE=20130101
PDE_END_DATE=`date -d "yesterday 0800" +%Y%m%d`
START_BATCH="A000"
END_BATCH="Z999"
RETVAL=0
ERRCNT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_daily_files.sh

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

# Check for process errors
check_errors()
{
	ERRCNT=`grep "ERROR" ${RPT_DIR}/${RPTNAME} | wc -l`
	if [ ${ERRCNT} -gt 0 ]
	then
		eval_errors
		case ${ERRFLG} in
		  "Y")
			MSG="File Error during process. No extract file provided."
			error_process
			ERRCNT=0
			;;
		  "N")
			file_transfer
			;;
		esac
	else
		file_transfer
	fi
}

# Evaluate errors
eval_errors()
{
	ERRFLG="N"
	grep "ERROR" ${RPT_DIR}/${RPTNAME} > /tmp/whexterrors.txt
	for line in `cat /tmp/whexterrors.txt`
	do
		ERRCD=`echo $line | awk -F, '{ print $2 }'`
		if [ ${ERRCD} -ne 23 ]
		then
			ERRFLG="Y"
		fi
	done
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
benef_extract
sponsor_extract
mac_extract
admin_extract
rebad_extract
rbadm_extract
rbadf_extract
rbadr_extract
spcfg_extract
sptds_extract
spcfds_extract
spectb_extract
gdesc_extract
ovdes_extract
clcmp_extract
clcob_extract
ndcdm_extract
ndcom_extract
ndcinc_extract
copay_extract
reimb_extract
reimb2_extract
phys_extract
diftb_extract
stcomp_extract
stcfg_extract
ndchk_extract
firtr_extract
check_extract
thint_extract
cldem_extract
step_extract
sdesc_extract
stgdes_extract
mednam_extract
medndc_extract
medval_extract
site_extract
stptg_extract
rebfe_extract
exclu_extract
macfa_extract
pdeds_extract
brkdem_extract
perms_extract
pndes_extract
tpm_extract
nsde_extract
nsdeovr_extract
exdes_extract
cmshosp_extract
team_extract
tgrp_extract
bincf_extract
brben_extract
binty_extract
phalock_extract
prcov_extract
gdrsd_extract
rejcd_extract
difct_extract
config_extract
mconfig_extract
rcode_extract
rcd_extract
rcp_extract
stexc_extract
drdes_extract
drug003_extract
restack_extract
npi_extract
emboss_extract
cagrpxw_extract
cabin_extract
}

#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
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
		echo "Error with transfer of ${FNAME}"
		PROG="WH Extract File Transfer"
		MSG="Error with transfer of ${FNAME}-${DATE}.gz"
		error_process
	fi
	mv ${CNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${CNAME}"
		PROG="WH Extract Count File Transfer"
		MSG="Error with transfer of ${CNAME}.gz"
		error_process
        fi
else
	echo "${FNAME} does not exist"
fi
date
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
	FNAME=${GROUPRB001}
	file_transfer
}

#
# Plan Extract
pln_extract()
{
	echo
	echo "--> plan extract - plan01"
	${SHELL_DIR}/plan01.sh > ${RPT_DIR}/plan01 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${PLANRB001}`"
	FNAME=${PLANRB001}
        file_transfer
}

#
# Copay Extract
copay_extract()
{
	echo
	echo "--> copay extract - copay01"
	${SHELL_DIR}/copay01.sh > ${RPT_DIR}/copay01 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${COPAYRB001}`"
	FNAME=${COPAYRB001}
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
	FNAME=${GENERRB001}
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
	RPTNAME=phdem03; PROG=phdem03
	FNAME=${PHDEMRB001}
        check_errors
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
	RPTNAME=phnet12; PROG=phnet12
	FNAME=${PHNETRB001}
	check_errors
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
	FNAME=${MAC00RB001}
        file_transfer
}

#
# REIMB extract
reimb_extract()
{
	echo
	echo "--> reimb extract - reimbrb01"
	${SHELL_DIR}/reimbrb01.sh > ${RPT_DIR}/reimbrb01 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${REIMBRB001}`"
	FNAME=${REIMBRB001}
        file_transfer
}
	
#
# REIMB2 extract
reimb2_extract()
{
	echo
	echo "--> reimb2 extract - reimbrb02"
	${SHELL_DIR}/reimbrb02.sh -f /usr/lnk/log/WH_REIMBPRM.txt > ${RPT_DIR}/reimbrb02 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${REIMBEXTR}`"
	FNAME=${REIMBEXTR}
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
	FNAME=${OVERIRB001}
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
	FNAME=${GENTBRB001}
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
	FNAME=${PHYSIRB001}
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
	FNAME=${DIFTBRB001}
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
	FNAME=${FIRTRRB001}
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
	FNAME=${SITERB001}
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
	FNAME=${DRUGRB001}
        file_transfer
}

#
# DRUG003MAS Extract
drug003_extract()
{
	echo
	echo "--> DRUG003MAS extract - drug003rb01"
        ${SHELL_DIR}/drug003rb01.sh > ${RPT_DIR}/drug003rb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/drug003rb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/drug003rb01`"
	FNAME=${DRUG003RB001}
        file_transfer
}

#
# DRDES00MAS Extract
drdes_extract()
{
	echo
	echo "--> DRDES00MAS extract - drdesrb01"
        ${SHELL_DIR}/drdesrb01.sh > ${RPT_DIR}/drdesrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/drdesrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/drdesrb01`"
	FNAME=${DRDESRB001}
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
	FNAME=${MEDNAME}
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
	FNAME=${MEDNDC}
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
	FNAME=${MEDVAL}
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
	FNAME=${STEPTRB001}
        file_transfer
}

#
# SDESC File Extract
sdesc_extract()
{
        echo "--> SDESC00MAS extract - sdesc01"
        ${SHELL_DIR}/sdesc01.sh > ${RPT_DIR}/sdesc01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/sdesc01`"
        echo "     `grep "ERROR" ${RPT_DIR}/sdesc01`"
        FNAME=${SDESCRB001}
        file_transfer
}

#
# STGDES File Extract
stgdes_extract()
{
        echo "--> STGDES0MAS extract - stgdes01"
        ${SHELL_DIR}/stgdes01.sh > ${RPT_DIR}/stgdes01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/stgdes01`"
        echo "     `grep "ERROR" ${RPT_DIR}/stgdes01`"
        FNAME=${STGDESRB01}
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
	FNAME=${SUSPRB001}
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
	FNAME=${CHECKRB001}
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
	FNAME=${SPONSRB001}
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
	FNAME=${ADMINRB001}
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
	FNAME=${REBFERB001}
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
	FNAME=${CLCMPRB001}
        file_transfer
}

#
# CLCOB00MAS File Extract
clcob_extract()
{
	echo
	echo "--> clcob file extract - clcobrb01"
	CLCOB_START_BATCH=`${SHELL_DIR}/convert_to_batch.sh ${PROCESS_DATE}`${START_BATCH}
	if test $? -ne 0
	then
		echo "-*> Error with convert_to_batch.sh process. WH extract did not run."
		PROG=clcobrb01
		MSG="Issue with convert_to_batch.sh process, so clcobrb01 WH extract did not run"
		error_process	
	else
        	CLCOB_END_BATCH=`${SHELL_DIR}/convert_to_batch.sh ${PROCESS_DATE}`${END_BATCH}
        	CLCOB_BATCH_RANGE=${CLCOB_START_BATCH}${CLCOB_END_BATCH}
		${SHELL_DIR}/clcobrb01.sh -b ${CLCOB_BATCH_RANGE} > ${RPT_DIR}/clcobrb01 2>&1
		echo "     `grep "WRITTEN" ${RPT_DIR}/clcobrb01`"
		echo "     `grep "ERROR" ${RPT_DIR}/clcobrb01`"
		FNAME=${CLCOBRB001}
        	file_transfer
	fi
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
	FNAME=${EXCLURB001}
        file_transfer
}

#
# STPTG00MAS File Extract
stptg_extract()
{
        echo
        echo "--> STPTG00MAS file extract - stptgrb01"
        ${SHELL_DIR}/stptgrb01.sh -f > ${RPT_DIR}/stptgrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/stptgrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/stptgrb01`"
	FNAME=${STPTGRB001}
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
	FNAME=${MACFARB001}
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
	FNAME=${PDEDSRB001}
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
	FNAME=${CLMSGRB001}
        file_transfer
}

#
# Therapeutic Interchange File Extract
thint_extract()
{
        echo "--> THINT00MAS extract - thint01"
        ${SHELL_DIR}/thint01.sh -f > ${RPT_DIR}/thint01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/thint01`"
        echo "     `grep "ERROR" ${RPT_DIR}/thint01`"
        FNAME=${THINTRB001}
        file_transfer
}

#
# Restack File Extract
restack_extract()
{
        echo "--> RESTK00MAS extract - restack11"
        ${SHELL_DIR}/restack11.sh > ${RPT_DIR}/restack11 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/restack11`"
        echo "     `grep "ERROR" ${RPT_DIR}/restack11`"
        FNAME=${RESTKRB001}
        file_transfer
}


#
# CLDEM File Extract
cldem_extract()
{
        echo "--> CLDEM00MAS extract - cldemrb01"
        ${SHELL_DIR}/cldemrb01.sh > ${RPT_DIR}/cldemrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/cldemrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/cldemrb01`"
        FNAME=${CLDEMRB001}
        file_transfer
}

#
# NPICMS File Extract
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
# EMBOS00MAS File Extract
emboss_extract()
{
        echo "--> EMBOS00MAS extract - cardh60"
        ${SHELL_DIR}/cardh60.sh > ${RPT_DIR}/cardh60 2>&1
        echo "     `grep "RECORDS READ" ${RPT_DIR}/cardh60`"
        echo "     `grep "ERROR" ${RPT_DIR}/cardh60`"
        FNAME=${EMBOSRB001}
        file_transfer
}
#
# BRKDEMB0MAS File Extract
brkdem_extract()
{
        echo
        echo "--> BRKDEMB0MAS file extract - brkdem01"
        ${SHELL_DIR}/brkdem01.sh > ${RPT_DIR}/brkdem01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/brkdem01`"
        echo "     `grep "ERROR" ${RPT_DIR}/brkdem01`"
        FNAME=${BRKDEMB01}
        file_transfer
}

#
# PERMI00MAS File Extract
perms_extract()
{
        echo
        echo "--> PERMI00MAS file extract - permirb01"
        ${SHELL_DIR}/permirb01.sh > ${RPT_DIR}/permirb01 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${PERMIRB001}`"
        FNAME=${PERMIRB001}
        file_transfer
}

#
# PNDES00MAS File Extract
pndes_extract()
{
        echo
        echo "--> PNDES00MAS file extract - pndesrb01"
        ${SHELL_DIR}/pndesrb01.sh > ${RPT_DIR}/pndesrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/pndesrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/pndesrb01`"
        FNAME=${PNDESRB001}
        file_transfer
}

#
# NSDE00MAS File Extract
nsde_extract()
{
        echo
        echo "--> NSDE00MAS file extract - nsderb01"
        ${SHELL_DIR}/nsderb01.sh -b FULL > ${RPT_DIR}/nsderb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/nsderb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/nsderb01`"
        FNAME=${NSDERB001}
        file_transfer
}

#
# NSDEOVRMAS File Extract
nsdeovr_extract()
{
        echo
        echo "--> NSDEOVRMAS file extract - nsdeovrb01"
        ${SHELL_DIR}/nsdeovrb01.sh -b FULL > ${RPT_DIR}/nsdeovrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/nsdeovrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/nsdeovrb01`"
        FNAME=${NSDEOVRB001}
        file_transfer
}

#
# SPECTB0MAS File Extract
spectb_extract()
{
        echo
        echo "--> SPECTB0MAS file extract - spectbrb01"
        ${SHELL_DIR}/spectbrb01.sh > ${RPT_DIR}/spectbrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/spectbrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/spectbrb01`"
        FNAME=${SPECTBRB001}
        file_transfer
}

#
# TPM00MAS File Extract
tpm_extract()
{
        echo
        echo "--> TPM00MAS file extract - tpmrb01"
        ${SHELL_DIR}/tpmrb01.sh > ${RPT_DIR}/tpmrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/tpmrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/tpmrb01`"
        FNAME=${TPMRB001}
        file_transfer
}

#
# EXDES00MAS File Extract
exdes_extract()
{
        echo
        echo "--> EXDES00MAS file extract - exdesrb01"
        ${SHELL_DIR}/exdesrb01.sh > ${RPT_DIR}/exdesrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/exdesrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/exdesrb01`"
        FNAME=${EXDESRB001}
        file_transfer
}

#
# OVDES00MAS File Extract
ovdes_extract()
{
        echo
        echo "--> OVDES00MAS file extract - ovdesrb01"
        ${SHELL_DIR}/ovdesrb01.sh > ${RPT_DIR}/ovdesrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/ovdesrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/ovdesrb01`"
        FNAME=${OVDESRB001}
        file_transfer
}

#
# DIFCT00MAS File Extract
difct_extract()
{
        echo
        echo "--> DIFCT00MAS file extract - difctrb01"
        ${SHELL_DIR}/difctrb01.sh > ${RPT_DIR}/difctrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/difctrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/difctrb01`"
        FNAME=${DIFCTRB001}
        file_transfer
}

#
# CONFIG0MAS File Extract
config_extract()
{
        echo
        echo "--> CONFIG0MAS file extract - config01"
        ${SHELL_DIR}/config01.sh > ${RPT_DIR}/config01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/config01`"
        echo "     `grep "ERROR" ${RPT_DIR}/config01`"
        FNAME=${CONFIGRB001}
        file_transfer
}

#
# STEXC00MAS File Extract
stexc_extract()
{
        echo
        echo "--> STEXC00MAS file extract - stexcrb01"
        ${SHELL_DIR}/stexcrb01.sh > ${RPT_DIR}/stexcrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/stexcrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/stexcrb01`"
        FNAME=${STEXCRB001}
        file_transfer
}

#
# MCONFIGMAS File Extract
mconfig_extract()
{
        echo
        echo "--> MCONFIGMAS file extract - mconfigrb01"
        ${SHELL_DIR}/mconfigrb01.sh > ${RPT_DIR}/mconfigrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/mconfigrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/mconfigrb01`"
        FNAME=${MCONFRB001}
        file_transfer
}

#
# RCODE00MAS File Extract
rcode_extract()
{
        echo
        echo "--> RCODE00MAS file extract - rcode01"
        ${SHELL_DIR}/rcode01.sh > ${RPT_DIR}/rcode01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rcode01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rcode01`"
        FNAME=${RCODERB001}
        file_transfer
}

#
# RCD0000MAS File Extract
rcd_extract()
{
        echo
        echo "--> RCD0000MAS file extract - rcd01"
        ${SHELL_DIR}/rcd01.sh > ${RPT_DIR}/rcd01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rcd01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rcd01`"
        FNAME=${RCDRB001}
        file_transfer
}

#
# RCP0000MAS File Extract
rcp_extract()
{
        echo
        echo "--> RCP0000MAS file extract - rcp01"
        ${SHELL_DIR}/rcp01.sh > ${RPT_DIR}/rcp01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rcp01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rcp01`"
        FNAME=${RCPRB001}
        file_transfer
}

#
# NPI0000MAS File Extract
npi_extract()
{
        echo
        echo "--> NPI0000MAS file extract - npirb01"
        ${SHELL_DIR}/npirb01.sh > ${RPT_DIR}/npirb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/npirb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/npirb01`"
        FNAME=${NPI00RB001}
        file_transfer
}

#
# SPCFG00MAS File Extract
spcfg_extract()
{
        echo
        echo "--> SPCFG00MAS file extract - spcfgrb01"
        ${SHELL_DIR}/spcfgrb01.sh > ${RPT_DIR}/spcfgrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/spcfgrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/spcfgrb01`"
        FNAME=${SPCFGRB001}
        file_transfer
}

#
# SPTDS00MAS File Extract
sptds_extract()
{
        echo
        echo "--> SPTDS00MAS file extract - sptdsrb01"
        ${SHELL_DIR}/sptdsrb01.sh > ${RPT_DIR}/sptdsrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/sptdsrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/sptdsrb01`"
        FNAME=${SPTDSRB001}
        file_transfer
}

#
# SPCFD00MAS File Extract
spcfds_extract()
{
        echo
        echo "--> SPCFD00MAS file extract - spcfdrb01"
        ${SHELL_DIR}/spcfdrb01.sh > ${RPT_DIR}/spcfdrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/spcfdrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/spcfdrb01`"
        FNAME=${SPCFDSRB01}
        file_transfer
}

#
# CMSHOSPMAS File Extract
cmshosp_extract()
{
        echo
        echo "--> CMSHOSPMAS file extract - cmsrb001"
        ${SHELL_DIR}/cmsrb001.sh > ${RPT_DIR}/cmsrb001 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/cmsrb001`"
        echo "     `grep "ERROR" ${RPT_DIR}/cmsrb001`"
        FNAME=${CMSRB001}
        file_transfer
}

#
# GDESC00MAS File Extract
gdesc_extract()
{
        echo
        echo "--> GDESC00MAS file extract - gdesc01"
        ${SHELL_DIR}/gdesc01.sh -f > ${RPT_DIR}/gdesc01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/gdesc01`"
        echo "     `grep "ERROR" ${RPT_DIR}/gdesc01`"
        FNAME=${GDESCRB001}
        file_transfer
}

#
# TEAM000MAS File Extract
team_extract()
{
        echo
        echo "--> TEAM000MAS file extract - teamrb01"
        ${SHELL_DIR}/teamrb01.sh > ${RPT_DIR}/teamrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/teamrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/teamrb01`"
        FNAME=${TEAMRB01}
        file_transfer
}

#
# RBADM00MAS File Extract
rbadm_extract()
{
        echo
        echo "--> RBADM00MAS file extract - rbadmrb01"
        ${SHELL_DIR}/rbadmrb01.sh > ${RPT_DIR}/rbadmrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rbadmrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rbadmrb01`"
        FNAME=${RBADMRB001}
        file_transfer
}

#
# RBADF00MAS File Extract
rbadf_extract()
{
        echo
        echo "--> RBADF00MAS file extract - rbadfrb01"
        ${SHELL_DIR}/rbadfrb01.sh > ${RPT_DIR}/rbadfrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rbadfrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rbadfrb01`"
        FNAME=${RBADFRB001}
        file_transfer
}

#
# RBADR00MAS File Extract
rbadr_extract()
{
        echo
        echo "--> RBADR00MAS file extract - rbadrrb01"
        ${SHELL_DIR}/rbadrrb01.sh > ${RPT_DIR}/rbadrrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rbadrrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rbadrrb01`"
        FNAME=${RBADRRB001}
        file_transfer
}

#
# Bin Config File Extracts
brben_extract()
{
        echo
        echo "--> BIN CONFIG file extracts - brbenrb01"
        ${SHELL_DIR}/brbenrb01.sh > ${RPT_DIR}/brbenrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/brbenrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/brbenrb01`"
        FNAME=${BRCFGRB001}
        file_transfer
        FNAME=${BRBENRB001}
        file_transfer
        FNAME=${BRCHNRB001}
        file_transfer
        FNAME=${BRZIPRB001}
        file_transfer
        FNAME=${BROPREJRB01}
        file_transfer
        FNAME=${TBRBENRB001}
        file_transfer
}

#
# BINCF00MAS Extract
bincf_extract()
{
        echo
        echo "--> BINCONFIG file extracts - bincfrb01"
        ${SHELL_DIR}/bincfrb01.sh > ${RPT_DIR}/bincfrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/bincfrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/bincfrb01`"
        FNAME=${BINCFRB001}
        file_transfer
}

#
# BINTY00MAS Extract
binty_extract()
{
        echo
        echo "--> BINTY00MAS file extracts - bintyrb01"
        ${SHELL_DIR}/bintyrb01.sh > ${RPT_DIR}/bintyrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/bintyrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/bintyrb01`"
        FNAME=${BINTYRB001}
        file_transfer
}

#
# TGRP000MAS Extract
tgrp_extract()
{
        echo
        echo "--> TGRP000MAS file extracts - tgrpwh01"
        ${SHELL_DIR}/tgrpwh01.sh > ${RPT_DIR}/tgrpwh01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/tgrpwh01`"
        echo "     `grep "ERROR" ${RPT_DIR}/tgrpwh01`"
        FNAME=${TGRPRB0001}
        file_transfer
}

#
#
# REBAD00MAS File Extract
rebad_extract()
{
        echo
        echo "--> REBAD00MAS file extract - rebadrb01"
        ${SHELL_DIR}/rebadrb01.sh > ${RPT_DIR}/rebadrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rebadrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rebadrb01`"
        FNAME=${REBADRB001}
        file_transfer
}

#
# ENROL00MAS File Extract
enrol_extract()
{
        echo
        echo "--> ENROL00MAS file extract - enrolrb01"
        ${SHELL_DIR}/enrolrb01.sh > ${RPT_DIR}/enrolrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/enrolrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/enrolrb01`"
        FNAME=${ENROLRB001}
        file_transfer
}

#
# ALTPR00MAS File Extract
altpr_extract()
{
        echo
        echo "--> ALTPR00MAS file extract - altpr0001"
        ${SHELL_DIR}/altpr0001.sh > ${RPT_DIR}/altpr0001 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/altpr0001`"
        echo "     `grep "ERROR" ${RPT_DIR}/altpr0001`"
        FNAME=${ALTPR00RB1}
        file_transfer
}

#
# BENEF00MAS File Extract
benef_extract()
{
        echo
        echo "--> BENEF00MAS file extract - benef01"
        ${SHELL_DIR}/benef01.sh > ${RPT_DIR}/benef01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/benef01`"
        echo "     `grep "ERROR" ${RPT_DIR}/benef01`"
        FNAME=${BENEFRB001}
        file_transfer
}

#
# PHALOCKMAS File Extract
phalock_extract()
{
        echo
        echo "--> PHALOCKMAS file extract - phalock01"
        ${SHELL_DIR}/phalock01.sh > ${RPT_DIR}/phalock01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/phalock01`"
        echo "     `grep "ERROR" ${RPT_DIR}/phalock01`"
        FNAME=${PHALOCKRB1}
        file_transfer
}

#
# PRCOV00MAS File Extract
prcov_extract()
{
        echo
        echo "--> PRCOV00MAS file extract - prcovrb01"
        ${SHELL_DIR}/prcovrb01.sh > ${RPT_DIR}/prcovrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/prcovrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/prcovrb01`"
        FNAME=${PRCOVRB001}
        file_transfer
}

#
# NDCDM00MAS File Extract
ndcdm_extract()
{
        echo
        echo "--> NDCDM00MAS file extract - ndcdm01"
        ${SHELL_DIR}/ndcdm01.sh > ${RPT_DIR}/ndcdm01 2>&1
       	echo "     `grep "WRITTEN" ${RPT_DIR}/ndcdm01`"
	echo "     `grep "ERROR" ${RPT_DIR}/ndcdm01`"
       	FNAME=${NDCDMRB001}
       	file_transfer
}

#
# NDCOM00MAS File Extract
ndcom_extract()
{
        echo
        echo "--> NDCOM00MAS file extract - ndcom01"
        ${SHELL_DIR}/ndcom01.sh > ${RPT_DIR}/ndcom01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/ndcom01`"
        echo "     `grep "ERROR" ${RPT_DIR}/ndcom01`"
        FNAME=${NDCOMRB001}
        file_transfer
}

#
# NDCINC0MAS File Extract
ndcinc_extract()
{
        echo
        echo "--> NDCINC0MAS file extract - ndcinc01"
        ${SHELL_DIR}/ndcinc01.sh > ${RPT_DIR}/ndcinc01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/ndcinc01`"
        echo "     `grep "ERROR" ${RPT_DIR}/ndcinc01`"
        FNAME=${NDCINCRB001}
        file_transfer
}

#
# GDRSD00MAS File Extract
gdrsd_extract()
{
        echo
        echo "--> GDRSD00MAS file extract - gdrsd01"
        ${SHELL_DIR}/gdrsd01.sh > ${RPT_DIR}/gdrsd01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/gdrsd01`"
        echo "     `grep "ERROR" ${RPT_DIR}/gdrsd01`"
        FNAME=${GDRSDRB001}
        file_transfer
}

#
# REJCD00MAS File Extract
rejcd_extract()
{
        echo
        echo "--> REJCD00MAS file extract - rejcd01"
        ${SHELL_DIR}/rejcd01.sh > ${RPT_DIR}/rejcd01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/rejcd01`"
        echo "     `grep "ERROR" ${RPT_DIR}/rejcd01`"
        FNAME=${REJCDRB001}
        file_transfer
}

#
# STCOMP0MAS File Extract
stcomp_extract()
{
        echo
        echo "--> STCOMP0MAS file extract - stcomp01"
        ${SHELL_DIR}/stcomp01.sh > ${RPT_DIR}/stcomp01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/stcomp01`"
        echo "     `grep "ERROR" ${RPT_DIR}/stcomp01`"
        FNAME=${STCOMPRB001}
        file_transfer
}

#
# STCFG00MAS File Extract
stcfg_extract()
{
        echo
        echo "--> STCFG00MAS file extract - stcfg01"
        ${SHELL_DIR}/stcfg01.sh > ${RPT_DIR}/stcfg01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/stcfg01`"
        echo "     `grep "ERROR" ${RPT_DIR}/stcfg01`"
        FNAME=${STCFGRB001}
        file_transfer
}

#
# NDCHK00MAS File Extract
ndchk_extract()
{
        echo
        echo "--> NDCHK00MAS file extract - ndchk01"
        ${SHELL_DIR}/ndchk01.sh > ${RPT_DIR}/ndchk01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/ndchk01`"
        echo "     `grep "ERROR" ${RPT_DIR}/ndchk01`"
        FNAME=${NDCHKRB001}
        file_transfer
}

#
# CAGRPXWMAS File Extract
cagrpxw_extract()
{
        echo
        echo "--> CAGRPXWMAS file extract - cagrpxrb01"
        ${SHELL_DIR}/cagrpxrb01.sh > ${RPT_DIR}/cagrpxrb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/cagrpxrb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/cagrpxrb01`"
        FNAME=${CAGRPXRB001}
        file_transfer
}

#
# Cabin master  Extract
cabin_extract()
{
        echo
        echo "--> CABIN00MAS file  extract - cabin01"
        ${SHELL_DIR}/cabin01.sh > ${RPT_DIR}/cabin01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/cabin01`"
        echo "     `grep "ERROR" ${RPT_DIR}/cabin01`"
        FNAME=${CABINRB001}
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
