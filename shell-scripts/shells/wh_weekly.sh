#!/bin/ksh
#
# Program Name	: wh_weekly.sh
# Description	: Procedure to run weekly warehouse extracts
#		  Command Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 09/22/2005
# Modifications : 09/22/2005 - Changed name from wh_drug002.sh to wh_weekly.sh and added ohrejrb001.cs procedure
#		: 10/17/2005 - Changes for Linux commands (LSJ)
#		: 05/19/2006 - Addition of Full run of CARDH00MAS  (LSJ)
#		: 05/19/2006 - Addition of Full run of PHDEM and PHNET  (LSJ)
#		: 05/24/2006 - Commented out CARDH run for now; it is running too long  (LSJ)
#		: 11/28/2006 - Added back in the full run of CARDH  (LSJ)
#		: 11/14/2007 - Added full run of CATAB00MAS  (LSJ)
#		: 11/27/2007 - split cardh52 into two runs  (LSJ)
#		: 02/07/2008 - Added week extracts for claim80rb and cardirb001  (LSJ)
#		: 02/26/2008 - Added full extract of PHYSI00MAS (physi01)  (LSJ)
#		: 05/13/2008 - Added excep01 (full extract)  (LSJ)
#		: 05/13/2008 - Added creation of .done files  (LSJ)
#		: 05/20/2008 - Added override01 (full extract)
#		: 05/28/2008 - Added files that are in daily_clms.sh and not in this script so that on Sundays, daily_clms.sh only runs claims  (LSJ)
#		: 06/17/2008 - Added the PATH variable assignment back in  (LSJ)
#		: 08/06/2008 - Added the DIFTB00MAS extract logic  (LSJ)
#		: 09/15/2008 - Commented out drug002 process (now in daily_clms.sh for only Wednesdays)
#		: 10/07/2008 - Changed sys ranges for full cardh52 processes, eliminating sys0078  (LSJ)
#		: 01/05/2009 - Added firtr02.sh extract procedure
#		: 12/04/2009 - Added susp004.sh extract process and adjusted find and scp to COLO process
#		: 12/08/2009 - Added check04.sh
#		: 01/09/2010 - Changes for move to COLO site as production
#		: 01/21/2010 - Added gdesc01.sh
#		: 02/03/2010 - Added geninc01.sh
#		: 03/25/2010 - Addition of sdesc01.sh and stgdes01.sh
#		: 03/29/2010 - Changed "copy to remote" logic due to issue with large PDE file
#		: 04/06/2010 - Changed EXCEPRB001-FULL to a gzip
#		: 04/21/2010 - Changed geninc01 to thint01
#		: 06/22/2010 - Fixed weekly and full file logic; added file_transfer
#		: 07/28/2010 - Added logic for new SITERB001 extract process
#		: 08/24/2010 - Added logic for new GEAPRB001 extract process
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PATH=/usr/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
ZIP_DIR="/usr/lnk/sort"
ZIP_PROG="/usr/bin/zip"
DIR_2=/usr/lnk/tmp/rb_export
SQL_MISC=/usr/lnk/sqlimports/misc
DATE=`date +%m%d%y`
DAY=`date +%w`
WK_START_DATE=`date -d "-7 days" +%Y%m%d`
WK_END_DATE=`date -d "yesterday" +%Y%m%d`
START_BATCH="A000"
END_BATCH="Z999"
FLEX="/usr/lnk/flexgen"
REIMB_EXTRACT="${SQL_MISC}/ohrmbrb001"
REJ_EXTRACT="${SQL_MISC}/ohrejrb001"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
FILE_DATE=`date -d "yesterday" +%Y%m%d`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_weekly.sh

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
}


#
# REJECT extract
rej_extract()
{
	echo "--> reject extract - ohrejrb001.cs"
        rm -f ${REJ_EXTRACT}
        cd ${FLEX}
        ${FLEX}/ohrejrb001.cs
        echo "    TOTAL RECORDS:  `wc -l ${REJ_EXTRACT}`"
        #echo "    `ls -og ${REJ_EXTRACT}`"
	touch ${REJ_EXTRACT}.done
	${SHELL_DIR}/copy_to_clientfiles.sh ohrejrb001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# Full Card Extract
card_extract()
{
	echo "--> full card extract - cardh52"
        rm -f ${SQL_MISC}/CARDHRB001-FULL.zip
        rm -f ${SQL_MISC}/CARDHRB001-FULL-2.zip
        SYS=00010075
        ${SHELL_DIR}/cardh52.sh -a ${SYS} -f > ${RPT_DIR}/cardh52-full 2>&1
	${SHELL_DIR}/copy_to_clientfiles.sh CARDHRB001-FULL ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
	${ZIP_PROG} -jm ${ZIP_DIR}/CARDHRB001-FULL.zip ${CARDHRB001}-FULL
        mv ${ZIP_DIR}/CARDHRB001-FULL.zip ${SQL_MISC}
        SYS=00799999
	${SHELL_DIR}/cardh52.sh -a ${SYS} -f >> ${RPT_DIR}/cardh52-full 2>&1
	mv ${CARDHRB001}-FULL ${CARDHRB001}-FULL-2
	${SHELL_DIR}/copy_to_clientfiles.sh CARDHRB001-FULL-2 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
        ${ZIP_PROG} -jm ${ZIP_DIR}/CARDHRB001-FULL-2.zip ${CARDHRB001}-FULL-2
        mv ${ZIP_DIR}/CARDHRB001-FULL-2.zip ${SQL_MISC}
        echo "     `grep "WRITTEN" ${RPT_DIR}/cardh52-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/cardh52-full`"
        echo "     `grep "BAD" ${RPT_DIR}/cardh52-full`"
	touch ${SQL_MISC}/CARDHRB001-FULL.zip.done ${SQL_MISC}/CARDHRB001-FULL-2.zip.done
}

#
# Pharmacy Demographic Extract
phdem_extract()
{
	echo "--> full phdem extract - phdem03"
        ${SHELL_DIR}/phdem03.sh -f > ${RPT_DIR}/phdem03-full 2>&1
        echo "     TOTAL RECORDS:  `wc -l ${PHDEMRB001}-FULL`"
        echo "     `grep "ERROR" ${RPT_DIR}/phdem03-full`"
	touch ${SQL_MISC}/PHDEMRB001-FULL.done
	cp ${PHDEMRB001}-FULL /tmp/PHDEMRB001-${FILE_DATE}
	FNAME=/tmp/PHDEMRB001-${FILE_DATE}
	file_transfer
}

#
# Pharmacy Network Extract
phnet_extract()
{
	echo "--> full phnet extract - phnet12"
        NET=000000999999
        rm -f ${SQL_MISC}/PHNETRB001-FULL.zip
        ${SHELL_DIR}/phnet12.sh -a ${NET} -f > ${RPT_DIR}/phnet12-full 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/phnet12-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/phnet12-full`"
	cp ${PHNETRB001}-FULL /tmp/PHNETRB001-${FILE_DATE}
        ${ZIP_PROG} -jm ${ZIP_DIR}/PHNETRB001-FULL.zip ${PHNETRB001}-FULL
        mv ${ZIP_DIR}/PHNETRB001-FULL.zip ${SQL_MISC}
	touch ${SQL_MISC}/PHNETRB001-FULL.zip.done
	FNAME=/tmp/PHNETRB001-${FILE_DATE}
	file_transfer
}

#
# Full PHYSI00MAS Extract
phys_extract()
{
	echo "--> full phys extract - physi01"
	${SHELL_DIR}/physi01.sh -f > ${RPT_DIR}/physi01-full 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/physi01-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/physi01-full`"
	touch ${SQL_MISC}/PHYSIRB001-FULL.done
	cp ${PHYSIRB001}-FULL /tmp/PHYSIRB001-${FILE_DATE} 
	FNAME=/tmp/PHYSIRB001-${FILE_DATE}
	file_transfer
}

#
# Full CATAB00MAS Extract
catab_extract()
{
	echo "--> full catab extract - catab01"
        rm -f ${SQL_MISC}/CATABRB001-FULL.zip
        ${SHELL_DIR}/catab01.sh -f > ${RPT_DIR}/catab01-full 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/catab01-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/catab01-full`"
	cp ${CATABRB001}-FULL /tmp/CATABRB001-${FILE_DATE}
        ${ZIP_PROG} -jm ${ZIP_DIR}/CATABRB001-FULL.zip ${CATABRB001}-FULL
        mv ${ZIP_DIR}/CATABRB001-FULL.zip ${SQL_MISC}
	touch ${SQL_MISC}/CATABRB001-FULL.zip.done
	FNAME=/tmp/CATABRB001-${FILE_DATE}
	file_transfer
}

#
# CLAIM80 Extract
claim80_extract()
{
	echo "--> 1 week claim80 extract - claim80rb"
        rm -f ${SQL_MISC}/CLAIM80RB1-WK
	WK_BATCH_START=`${SHELL_DIR}/convert_to_batch.sh ${WK_START_DATE}`${START_BATCH}
	WK_BATCH_END=`${SHELL_DIR}/convert_to_batch.sh ${WK_END_DATE}`${END_BATCH}
	WK_BATCH_RANGE=${WK_BATCH_START}${WK_BATCH_END}
        ${SHELL_DIR}/claim80rb.sh -b ${WK_BATCH_RANGE} -o ${SQL_MISC}/CLAIM80RB1-WK > ${RPT_DIR}/claim80rb-wk 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/claim80rb-wk`"
        echo "     `grep "ERROR" ${RPT_DIR}/claim80rb-wk`"
	touch ${SQL_MISC}/CLAIM80RB1-WK.done
	cp ${SQL_MISC}/CLAIM80RB1-WK /tmp/CLAIM80RB1-${FILE_DATE}
	FNAME=/tmp/CLAIM80RB1-${FILE_DATE}
	file_transfer
}

#
# CARDI Extract
cardi_extract()
{
	echo "--> 1 week cardi extract - cardirb001"
	rm -f ${SQL_MISC}/CARDIRBMAS-WK
	WK_DATE_RANGE=${WK_START_DATE}${WK_END_DATE}
	${SHELL_DIR}/cardirb001.sh -d ${WK_DATE_RANGE} -o ${SQL_MISC}/CARDIRBMAS-WK > ${RPT_DIR}/cardirb001-wk 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/cardirb001-wk`"
        echo "     `grep "ERROR" ${RPT_DIR}/cardirb001-wk`"
	touch ${SQL_MISC}/CARDIRBMAS-WK.done
	cp ${SQL_MISC}/CARDIRBMAS-WK /tmp/CARDIRBMAS-${FILE_DATE}
	FNAME=/tmp/CARDIRBMAS-${FILE_DATE}
	file_transfer
}

#
# Full EXCEPTION Extract
excep_extract()
{
	echo "--> full exception extract - excep01"
        rm -f ${SQL_MISC}/EXCEPRB001-FULL.gz
        ${SHELL_DIR}/excep01.sh -f > ${RPT_DIR}/excep01-full 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/excep01-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/excep01-full`"
	cp ${EXCEPRB001}-FULL /tmp/EXCEPRB001-${FILE_DATE}
	gzip ${EXCEPRB001}-FULL
	touch ${EXCEPRB001}-FULL.gz.done
	FNAME=/tmp/EXCEPRB001-${FILE_DATE}
	file_transfer
}

#
# Full OVERRIDE Extract
override_extract()
{
	echo "--> full override extract - override01"
        rm -f ${SQL_MISC}/OVERIRB001-FULL.zip
        ${SHELL_DIR}/override01.sh -f > ${RPT_DIR}/override01-full 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/override01-full`"
        echo "     `grep "ERROR" ${RPT_DIR}/override01-full`"
	cp ${OVERIRB001}-FULL /tmp/OVERIRB001-${FILE_DATE}
        ${ZIP_PROG} -jm ${ZIP_DIR}/OVERIRB001-FULL.zip ${OVERIRB001}-FULL
        mv ${ZIP_DIR}/OVERIRB001-FULL.zip ${SQL_MISC}
        touch ${SQL_MISC}/OVERIRB001-FULL.zip.done
	FNAME=/tmp/OVERIRB001-${FILE_DATE}
	file_transfer
}

#
# Group Extract
grp_extract()
{
	echo "--> group extract - group10"
        ${SHELL_DIR}/group10.sh > ${RPT_DIR}/group10 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/group10`"
        echo "     `grep "ERROR" ${RPT_DIR}/group10`"
        touch ${GROUPRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh GROUPRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# Plan Extract
pln_extract()
{
	echo "--> plan extract - plan01"
        ${SHELL_DIR}/plan01.sh > ${RPT_DIR}/plan01 2>&1
        echo "     `grep "COUNT"  ${RPT_DIR}/plan01`"
        echo "     `grep "ERROR"  ${RPT_DIR}/plan01`"
        touch ${PLANRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh PLANRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# Copay Extract
copay_extract()
{
	echo "--> copay extract - copay01"
        ${SHELL_DIR}/copay01.sh > ${RPT_DIR}/copay01 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/copay01`"
        echo "     `grep "ERROR" ${RPT_DIR}/copay01`"
        touch ${COPAYRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh COPAYRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}


#
# Generic Extract
gen_extract()
{
	echo "--> generic extract - gener01"
        ${SHELL_DIR}/gener01.sh > ${RPT_DIR}/gener01 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/gener01`"
        echo "     `grep "ERROR" ${RPT_DIR}/gener01`"
        touch ${GENERRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh GENERRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# MAC extract
mac_extract()
{
	echo "--> mac extract - mac002"
        ${SHELL_DIR}/mac002.sh > ${RPT_DIR}/mac002 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/mac002`"
        echo "     `grep "ERROR" ${RPT_DIR}/mac002`"
        touch ${MAC00RB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh MAC00RB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# REIMB extract
reimb_extract()
{
	echo "--> reimb extract - ohrmbrb001"
        rm -f ${REIMB_EXTRACT}
        cd ${FLEX}
        ${FLEX}/ohrmbrb001.cs
        echo "     TOTAL RECORDS:  `wc -l ${REIMB_EXTRACT}`"
        #echo "    `ls -og ${REIMB_EXTRACT}`"
        touch ${REIMB_EXTRACT}.done
	${SHELL_DIR}/copy_to_clientfiles.sh ohrmbrb001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# PDECL00MAS extract
pdecl_extract()
{
	echo "--> pde extract - pdecl02"
        ${SHELL_DIR}/pdecl02.sh > ${RPT_DIR}/pdecl02 2>&1
        echo "     TOTAL RECORDS:  `wc -l ${PDECLRB001}`"
        echo "     `grep "ERROR" ${RPT_DIR}/pdecl02`"
        #touch ${PDECLRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh PDECLRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# GENTB extract
gentb_extract()
{
	echo "--> gentb extract - gentb02"
        ${SHELL_DIR}/gentb02.sh -f > ${RPT_DIR}/gentb02 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/gentb02`"
        echo "     `grep "ERROR" ${RPT_DIR}/gentb02`"
        touch ${GENTBRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh GENTBRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# DIFTB extract
diftb_extract()
{
	echo "--> DIFTB00MAS extract - diftb01"
        ${SHELL_DIR}/diftb01.sh > ${RPT_DIR}/diftb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/diftb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/diftb01`"
        touch ${DIFTBRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh DIFTBRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# FIRTR extract
firtr_extract()
{
	echo "--> FIRTR00MAS extract - firtr02"
        ${SHELL_DIR}/firtr02.sh > ${RPT_DIR}/firtr02 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/firtr02`"
        echo "     `grep "ERROR" ${RPT_DIR}/firtr02`"
        touch ${FIRTRRB001}.done
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
# Suspend File Extract
susp_extract()
{
	echo "--> SUSP00MAS extract - susp004"
        ${SHELL_DIR}/susp004.sh > ${RPT_DIR}/susp004 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/susp004`"
        echo "     `grep "ERROR" ${RPT_DIR}/susp004`"
        touch ${SUSPRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh SUSPRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# Check File Extract
check_extract()
{
	echo "--> CHECK00MAS extract - check04"
        ${SHELL_DIR}/check04.sh > ${RPT_DIR}/check04 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/check04`"
        echo "     `grep "ERROR" ${RPT_DIR}/check04`"
        touch ${CHECKRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh CHECKRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# GDESC File Extract
gdesc_extract()
{
	echo "--> GDESC00MAS extract - gdesc01"
        ${SHELL_DIR}/gdesc01.sh > ${RPT_DIR}/gdesc01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/gdesc01`"
        echo "     `grep "ERROR" ${RPT_DIR}/gdesc01`"
        touch ${GDESCRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh GDESCRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# Therapeutic Interchange File Extract
thint_extract()
{
	echo "--> THINT00MAS extract - thint01"
        ${SHELL_DIR}/thint01.sh > ${RPT_DIR}/thint01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/thint01`"
        echo "     `grep "ERROR" ${RPT_DIR}/thint01`"
        touch ${THINTRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh THINTRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# SDESC File Extract
sdesc_extract()
{
	echo "--> SDESC00MAS extract - sdesc01"
        ${SHELL_DIR}/sdesc01.sh > ${RPT_DIR}/sdesc01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/sdesc01`"
        echo "     `grep "ERROR" ${RPT_DIR}/sdesc01`"
        touch ${SDESCRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh SDESCRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# STGDES File Extract
stgdes_extract()
{
	echo "--> STGDES0MAS extract - stgdes01"
        ${SHELL_DIR}/stgdes01.sh > ${RPT_DIR}/stgdes01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/stgdes01`"
        echo "     `grep "ERROR" ${RPT_DIR}/stgdes01`"
        touch ${STGDESRB01}.done
	${SHELL_DIR}/copy_to_clientfiles.sh STGDESRB01 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}

#
# GEAP File Extract
geap_extract()
{
	echo "--> GEAP000MAS extract - geap01"
        ${SHELL_DIR}/geap01.sh -f > ${RPT_DIR}/geap01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/geap01`"
        echo "     `grep "ERROR" ${RPT_DIR}/geap01`"
        touch ${GEAPRB001}.done
	${SHELL_DIR}/copy_to_clientfiles.sh GEAPRB001 ${SQL_MISC} >> ${RPT_DIR}/copy_to_clientfiles 2>&1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

rm -f ${SQL_MISC}/*.done

date

grp_extract
pln_extract
copay_extract
gen_extract
gentb_extract
mac_extract
reimb_extract
rej_extract
phdem_extract
phnet_extract
card_extract
catab_extract
claim80_extract
cardi_extract
phys_extract
excep_extract
override_extract
diftb_extract
firtr_extract
susp_extract
check_extract
gdesc_extract
thint_extract
sdesc_extract
stgdes_extract
site_extract
geap_extract
pdecl_extract

# Copy files to Remote Systems
cd ${SQL_MISC}
date
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
date

exit 0
