#!/bin/ksh
#
# Program Name	: wh_daily_prod.sh
# Description	: Procedure to create extract files for Warehouses
#		  Command Line Arguments:
#		  -u <run type>
# Author	: Linda S. Jefferis
# Date		: 01/09/2010
# Modifications : 03/29/2010 - Changed "copy_to_remote" logic for large PDE file
#		: 05/12/2010 - Added "copy_to_clientfiles.sh" logic
#               : 07/28/2010 - Added logic for new SITERB001 extract process
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
ZIP_DIR="/usr/lnk/sort"
ZIP_PROG="/usr/bin/zip"
FILE1=CL72-D-PDM
FILE2=CL72
DIR_1=/usr/lnk/tmp
DIR_2=/usr/lnk/tmp/rb_export
SQL_MISC=/usr/lnk/sqlimports/misc
SQL_CLMS=/usr/pdm/sqlimports/claims
DATE=`date +%m%d%y`
DAY=`date +%w`
PROCESS_DATE=`date -d "yesterday 0800" +%Y%m%d`
NET="000000000000"
SYS="00000000"
FLEX="/usr/lnk/flexgen"
REIMB_EXTRACT="${SQL_MISC}/ohrmbrb001"
REJ_EXTRACT="${SQL_MISC}/ohrejrb001"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
SW=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_daily_prod.sh

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
	claim_extract
  	claim80_extract
  	cardi_extract
  	grp_extract
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
  	susp_extract
  	check_extract
  	catab_extract
  	gentb_extract
  	phys_extract
  	diftb_extract
  	firtr_extract
	site_extract
  	pdecl_extract

	if [ ${DAY} = 3 ]
  	then
        	drug_extract
        	mednam_extract
        	medndc_extract
        	medval_extract
        	step_extract
  	fi
}

# Copies to Remote Systems
copy_to_remote()
{
if [ ${HOSTNAME} = "prod11" ]
then
        if [ ${DAY} -ne 0 ]
        then
                cd ${SQL_MISC}
                find . -type f ! -name "*-files.zip" ! -name "PDECLRB001*" -mtime 0 -print | zip ${DATE}-files.zip -@
                scp -q ${DATE}-files.zip prod21:${DIR_2}
                ssh prod21 "unzip -od ${DIR_2} ${DIR_2}/${DATE}-files.zip"
		gzip PDECLRB001
		ssh prod21 "rm -f ${DIR_2}/PDECLRB001*"
		scp PDECLRB001.gz prod21:${DIR_2}
		ssh prod21 "gunzip ${DIR_2}/PDECLRB001.gz"
		gunzip PDECLRB001.gz
		touch PDECLRB001.done
		scp PDECLRB001.done prod21:${DIR_2}
        fi
fi

if [ ${HOSTNAME} = "prod10" ]
then
        cd ${SQL_CLMS}
        scp -q CL72.${DATE}.sql* prod20:${DIR_2}
        scp -q wh_daily_claims_count prod20:${DIR_2}
fi
}


# Claims Extract
claim_extract()
{
	echo
	echo "--> Starting claims extract - claim72pdm"
	find ${SQL_CLMS} -name "CL72*" -mtime +7 -exec rm {} \;
	${SHELL_DIR}/claim72pdm.sh -c day > ${RPT_DIR}/claim72pdmd 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/claim72pdmd`"
	echo "`grep "ERROR CLAIM00TAP: 9701" ${RPT_DIR}/claim72pdmd`"
	mv ${DIR_1}/???${FILE1} ${SQL_CLMS}/${FILE2}.${DATE}.sql
	REC_CNT=`wc -l ${SQL_CLMS}/${FILE2}.${DATE}.sql | awk '{ print $1 }'`
	echo ${REC_CNT}","${PROCESS_DATE} > ${SQL_CLMS}/wh_daily_claims_count
	touch ${SQL_CLMS}/${FILE2}.${DATE}.sql.done
}

# Claim80 Extract
claim80_extract()
{
	echo
	echo "--> claim80 extract - claim80rb"
	${SHELL_DIR}/claim80rb.sh > ${RPT_DIR}/claim80rb 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/claim80rb`"
	echo "     `grep "ERROR" ${RPT_DIR}/claim80rb`"
	touch ${SQL_MISC}/CLAIM80RB1.done
	${SHELL_DIR}/copy_to_clientfiles.sh CLAIM80RB1 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/GROUPRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh GROUPRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/PLANRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh PLANRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/COPAYRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh COPAYRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/GENERRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh GENERRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# Card Extract
card_extract()
{
	echo
	echo "--> card extract - cardh52"
	SYS=00019999
	rm -f ${SQL_MISC}/CARDHRB001.zip
	${SHELL_DIR}/cardh52.sh -a ${SYS} > ${RPT_DIR}/cardh52 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/cardh52`"
	echo "     `grep "ERROR" ${RPT_DIR}/cardh52`"
	${SHELL_DIR}/copy_to_clientfiles.sh CARDHRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
	${ZIP_PROG} -jm ${ZIP_DIR}/CARDHRB001.zip ${CARDHRB001}
	mv ${ZIP_DIR}/CARDHRB001.zip ${SQL_MISC}
	touch ${SQL_MISC}/CARDHRB001.zip.done
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
	touch ${SQL_MISC}/CATABRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh CATABRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/PHDEMRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh PHDEMRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# Pharmacy Network Extract
phnet_extract()
{
	echo
	echo "--> phnet extract - phnet12"
	NET=000000999999
	rm -f ${SQL_MISC}/PHNETRB001.zip
	${SHELL_DIR}/phnet12.sh -a ${NET} > ${RPT_DIR}/phnet12 2>&1
	#echo "     `grep "WRITTEN" ${RPT_DIR}/phnet12`"
	echo "     TOTAL RECORDS:  `wc -l ${PHNETRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/phnet12`"
	${SHELL_DIR}/copy_to_clientfiles.sh PHNETRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
	${ZIP_PROG} -jm ${ZIP_DIR}/PHNETRB001.zip ${PHNETRB001}
	mv ${ZIP_DIR}/PHNETRB001.zip ${SQL_MISC}
	touch ${SQL_MISC}/PHNETRB001.zip.done
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
	touch ${SQL_MISC}/CARDIRBMAS.done
	${SHELL_DIR}/copy_to_clientfiles.sh CARDIRBMAS ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/MAC00RB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh MAC00RB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# REIMB extract
reimb_extract()
{
	echo
	echo "--> reimb extract - ohrmbrb001.cs"
	rm -f ${REIMB_EXTRACT}
	cd ${FLEX}
	${FLEX}/ohrmbrb001.cs
	echo "     TOTAL RECORDS:  `wc -l ${REIMB_EXTRACT}`"
	#echo "    `ls -og ${REIMB_EXTRACT}`"
	touch ${REIMB_EXTRACT}.done
	${SHELL_DIR}/copy_to_clientfiles.sh ohrmbrb001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/EXCEPRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh EXCEPRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/OVERIRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh OVERIRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# PDECL00MAS extract
pdecl_extract()
{
	echo
	echo "--> PDECL00MAS extract - pdecl01"
	${SHELL_DIR}/pdecl02.sh > ${RPT_DIR}/pdecl02 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${PDECLRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/pdecl02`"
	#touch ${SQL_MISC}/PDECLRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh PDECLRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/GENTBRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh GENTBRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/PHYSIRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh PHYSIRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/DIFTBRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh DIFTBRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/FIRTRRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh FIRTRRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/SITERB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh SITERB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
#
# Drug Extract
drug_extract()
{
	echo
	echo "--> DRUG000MAS extract - drug002"
        rm -f ${SQL_MISC}/DRUGRB001.zip
        ${SHELL_DIR}/drug002.sh > ${RPT_DIR}/drug002 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/drug002`"
        echo "     `grep "ERROR" ${RPT_DIR}/drug002`"
	${SHELL_DIR}/copy_to_clientfiles.sh DRUGRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
        ${ZIP_PROG} -jm ${ZIP_DIR}/DRUGRB001.zip ${DRUGRB001}
        mv ${ZIP_DIR}/DRUGRB001.zip ${SQL_MISC}
        touch ${SQL_MISC}/DRUGRB001.zip.done
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
        touch ${SQL_MISC}/MEDNAME.done
	${SHELL_DIR}/copy_to_clientfiles.sh MEDNAME ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
        touch ${SQL_MISC}/MEDNDC.done
	${SHELL_DIR}/copy_to_clientfiles.sh MEDNDC ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
        touch ${SQL_MISC}/MEDVAL.done
	${SHELL_DIR}/copy_to_clientfiles.sh MEDVAL ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/STEPTRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh STEPTRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/SUSPRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh SUSPRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
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
	touch ${SQL_MISC}/CHECKRB001.done
	${SHELL_DIR}/copy_to_clientfiles.sh CHECKRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}


#
# Main routine
#

umask 111
rm -f ${SQL_MISC}/*.done
rm -f ${SQL_CLMS}/*.done

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

if [ $SW = 1 ]
then
	sel_proc
else
	full_proc
fi
copy_to_remote

exit 0
