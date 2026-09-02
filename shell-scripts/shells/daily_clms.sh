#!/bin/ksh
#
# Program Name	: daily_clms.sh
# Description	: Procedure to create daily files for redbrick
#		  Command Line Arguments:
#		  -u <####################> switch settings for which files to extract
#                       SW1 - CLAIMS
#                       SW2 - COPAY
#                       SW3 - GPI
#                       SW4 - GROUP
#                       SW5 - PLAN
#                       SW6 - CATAB00MAS
#                       SW7 - CARD
#                       SW8 - PHDEM
#                       SW9 - PHNET
#			SW10- CLAIM80
#			SW11- CARDI
#			SW12- MAC
#			SW13- REIMB
#			SW14- EXCEP and OVERRIDE
#			SW15- SUSPEND
#			SW16- PDECL00MAS 
#			SW17- GENTB00MAS
#			SW18- PHYSI00MAS
#			SW19- Miscellaneous files (DIFTB00MAS, FIRTRRB001)
#			SW20- DRUG (also MDNAME, MEDNDC, MEDVAL, STEPTRB001)
# Author	: Linda S. Jefferis
# Date		: 01/09/98
# Modifications : 07/09/98 (LSJ)  Added logic for group, copay, gpi, plan, and drug extracts
#		: 09/17/98 (LSJ)  Changed procedure for status2 file
#		: 02/15/99 (LSJ)  Added logic for card extracts
#		: 03/11/99 (LSJ)  Added run switches
#		: 10/18/99 (LSJ)  Added compress of DRUGRB001 before the rcp
#		: 11/08/99 (LSJ)  Put in a "rm -f" of DRUGRB001.Z 
#		: 11/11/99 (LSJ)  Changed procedure for CARDH00MAS extract
#		: 03/30/01 (LSJ)  Added displays
#		: 04/09/01 (LSJ)  Added SW10 for CLAIM80 daily extract
#		: 05/31/01 (LSJ)  Added SW11 and other logic for CARDI extract
#		: 08/17/01 (LSJ)  Added zip of CARD and DRUG files for SQL parallell
#		: 09/10/01 (LSJ)  Added CONV_PROG for claims file for Dave
#		: 10/01/01 (LSJ)  Changed removes under card_extract and drug_extract to before the extract program
#		: 05/15/02 (LSJ)  Changes for no longer processing on Redbrick
#		: 11/21/02 (LSJ)  Added zip procedure for PHNETRB001 and changed the zip procedures for CARDHRB001 and DRUGRB001
#		: 03/10/03 (LSJ)  Added SW12 and other logic for MAC extract
#		: 04/07/03 (LSJ)  Added logic for new ohrmbrb001.cs REIMB extract procedure.
#		: 02/04/04 (LSJ)  Added all logic for new excep01 and override01 extract procedures.
#		: 05/06/04 (LSJ)  Moved the CARDI process up in the run order
#		: 05/10/04 (LSJ)  Added find and remove command right before the start of the claim72pdmd procedure.
#		: 03/07/2005 (LSJ) Changed ZIP_DIR path from /usr/lnk/sort
#		: 05/24/2005 (LSJ) Addition of logic for ohrejrb001.cs 
#		: 06/14/2005 (LSJ) Changed display to include record count for ohrmb001 and ohrejrb001
#		: 07/13/2005 (LSJ) Added 'grep "ERRORS"' for most procedures
#		: 08/08/2005 (LSJ) Changed NET range for phnet run 
#		: 09/22/2005 (LSJ) Moved DRUG extract to new wh_weekly.sh script
#		: 09/22/2005 (LSJ) Moved ohrejrb001 to new wh_weekly.sh script
#		: 10/17/2005 (LSJ) Changes for linux commands  (LSJ)
#		: 12/27/2005 (LSJ) Added logic for new PDECL00MAS extract
#		: 12/29/2005 (LSJ) changed "grep" command for record count for PDECL extract
#		: 04/27/2006 (LSJ) Changed way PHDEM record count is displayed
#		: 10/24/2006 (LSJ) Removed char_repl logic for claim72pdm process
#		: 12/13/2006 (LSJ) Added display of "ERROR CLAIM00TAP: 9701" if found in claim72pdmd.
#		: 10/29/2007 (LSJ) Fixed SYS_RANGE for cardh52.sh; changed from 00010099 to 00019999.
#		: 10/30/2007 (LSJ) Added logic for a wh_daily_claims_count file that warehouse wanted.
#		: 11/14/2007 (LSJ) Added catab01.sh
#		: 11/15/2007 (LSJ) Fixed switch problem with catab01 run
#		: 11/29/2007 (LSJ) Changed how record count is determined for excep01, pdecl02, and phnet12 due to issues within the programs with displayed count.
#		: 12/12/2007 (LSJ) Added gentb02.sh
#		: 02/07/2008 (LSJ) Added extract procedures for PHYSI00MAS
#		: 05/12/2008 (LSJ) Added creation of .done files
#		: 06/20/2008 (LSJ) Changed the CL72 find and remove command to go back +7 instead of just +2 to keep more files.
#		: 08/06/2008 (LSJ) Added DIFTB00MAS extract (SW19) logic
#		: 09/15/2008 (LSJ) Added drug002 extract if DAY=3 (Wednesday)
#		: 09/26/2008 (LSJ) Added extracts for medirb01(MEDNAME), medirb02(MEDNDC), and medirb03(MEDVAL); same timeframe as DRUG.
#		: 01/05/2009 (LSJ) Added FITRTRRB001 extract
#		: 04/09/2009 (LSJ) Added STEPTRB001 extract with Wednesday's DRUG updates
#		: 10/08/2009 (LSJ) Added zip and scp to prod11
#		: 10/13/2009 (LSJ) Added Suspend File Extract process
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PATH=/usr/lpplus2/bin:/etc:/usr/pdm/bin:/usr/pdm.bin:/home/ljefferis/bin:/usr/mlink:/usr/rmcobol:/usr/bin/X11:/usr/ccs/bin:$PATH
export PATH
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
ZIP_DIR="/usr/lnk/sort"
MAIL_TO=ljefferis@pdmi.com
ZIP_PROG="/usr/bin/zip"
FILE1=CL72-D-PDM
FILE2=CL72
DIR_1=/usr/lnk/tmp
DIR_2=/usr/lnk/tmp/rb_export
DATE=`date +%m%d%y`
DAY=`date +%w`
PROCESS_DATE=`date -d "yesterday" +%Y%m%d`
NET="000000000000"
SYS="00000000"
FLEX="/usr/lnk/flexgen"
REIMB_EXTRACT="/usr/lnk/tmp/rb_export/ohrmbrb001"
REJ_EXTRACT="/usr/lnk/rb_01/rb_export/ohrejrb001"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_clms.sh [-u <#################> (1's or 0's)]

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

# Separate switches
split_sw()
{
    SW1=`echo ${SW} | cut -c1`
    SW2=`echo ${SW} | cut -c2`
    SW3=`echo ${SW} | cut -c3`
    SW4=`echo ${SW} | cut -c4`
    SW5=`echo ${SW} | cut -c5`
    SW6=`echo ${SW} | cut -c6`
    SW7=`echo ${SW} | cut -c7`
    SW8=`echo ${SW} | cut -c8`
    SW9=`echo ${SW} | cut -c9`
    SW10=`echo ${SW} | cut -c10`
    SW11=`echo ${SW} | cut -c11`
    SW12=`echo ${SW} | cut -c12`
    SW13=`echo ${SW} | cut -c13`
    SW14=`echo ${SW} | cut -c14`
    SW15=`echo ${SW} | cut -c15`
    SW16=`echo ${SW} | cut -c16`
    SW17=`echo ${SW} | cut -c17`
    SW18=`echo ${SW} | cut -c18`
    SW19=`echo ${SW} | cut -c19`
    SW20=`echo ${SW} | cut -c20`
}

# Claims Extract
claim_extract()
{
	find ${DIR_2} -name "CL72*" -mtime +7 -exec rm {} \;
	${SHELL_DIR}/claim72pdm.sh -c day > ${RPT_DIR}/claim72pdmd 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/claim72pdmd`"
	echo "`grep "ERROR CLAIM00TAP: 9701" ${RPT_DIR}/claim72pdmd`"
	mv ${DIR_1}/???${FILE1} ${DIR_2}/${FILE2}.${DATE}.sql
	REC_CNT=`wc -l ${DIR_2}/${FILE2}.${DATE}.sql | awk '{ print $1 }'`
	echo ${REC_CNT}","${PROCESS_DATE} > ${DIR_2}/wh_daily_claims_count
	touch ${DIR_2}/${FILE2}.${DATE}.sql.done
}

# Claim80 Extract
claim80_extract()
{
	${SHELL_DIR}/claim80rb.sh > ${RPT_DIR}/claim80rb 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/claim80rb`"
	echo "     `grep "ERROR" ${RPT_DIR}/claim80rb`"
	touch ${DIR_2}/CLAIM80RB1.done
}

#
# Group Extract
grp_extract()
{
	${SHELL_DIR}/group10.sh > ${RPT_DIR}/group10 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/group10`"
	echo "     `grep "ERROR" ${RPT_DIR}/group10`"
	touch ${DIR_2}/GROUPRB001.done
}

#
# Plan Extract
pln_extract()
{
	${SHELL_DIR}/plan01.sh > ${RPT_DIR}/plan01 2>&1
        echo "     `grep "COUNT"  ${RPT_DIR}/plan01`"
        echo "     `grep "ERROR"  ${RPT_DIR}/plan01`"
	touch ${DIR_2}/PLANRB001.done
}

#
# Copay Extract
copay_extract()
{
	${SHELL_DIR}/copay01.sh > ${RPT_DIR}/copay01 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/copay01`"
        echo "     `grep "ERROR" ${RPT_DIR}/copay01`"
	touch ${DIR_2}/COPAYRB001.done
}


#
# Generic Extract
gen_extract()
{
	${SHELL_DIR}/gener01.sh > ${RPT_DIR}/gener01 2>&1
	echo "     `grep "COUNT" ${RPT_DIR}/gener01`"
	echo "     `grep "ERROR" ${RPT_DIR}/gener01`"
	touch ${DIR_2}/GENERRB001.done
}

#
# Card Extract
card_extract()
{
	SYS=00019999
	rm -f ${DIR_2}/CARDHRB001.zip
	${SHELL_DIR}/cardh52.sh -a ${SYS} > ${RPT_DIR}/cardh52 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/cardh52`"
	echo "     `grep "ERROR" ${RPT_DIR}/cardh52`"
	${ZIP_PROG} -jm ${ZIP_DIR}/CARDHRB001.zip ${CARDHRB001}
	mv ${ZIP_DIR}/CARDHRB001.zip ${DIR_2}
	touch ${DIR_2}/CARDHRB001.zip.done
}

#
# Card Table Extract
catab_extract()
{
	${SHELL_DIR}/catab01.sh > ${RPT_DIR}/catab01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/catab01`"
	echo "     `grep "ERROR" ${RPT_DIR}/catab01`"
	touch ${DIR_2}/CATABRB001.done
}

#
# Pharmacy Demographic Extract
phdem_extract()
{
	${SHELL_DIR}/phdem03.sh > ${RPT_DIR}/phdem03 2>&1
	echo "     TOTAL RECORDS:  `wc -l ${PHDEMRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/phdem03`"
	touch ${DIR_2}/PHDEMRB001.done
}

#
# Pharmacy Network Extract
phnet_extract()
{
	NET=000000999999
	rm -f ${DIR_2}/PHNETRB001.zip
	${SHELL_DIR}/phnet12.sh -a ${NET} > ${RPT_DIR}/phnet12 2>&1
	#echo "     `grep "WRITTEN" ${RPT_DIR}/phnet12`"
	echo "     TOTAL RECORDS:  `wc -l ${PHNETRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/phnet12`"
	${ZIP_PROG} -jm ${ZIP_DIR}/PHNETRB001.zip ${PHNETRB001}
	mv ${ZIP_DIR}/PHNETRB001.zip ${DIR_2}
	touch ${DIR_2}/PHNETRB001.zip.done
}

#
# CARDI extract
cardi_extract()
{
	echo "Process Date Range: ${PROCESS_DATE}${PROCESS_DATE}"
	${SHELL_DIR}/cardirb001.sh -d ${PROCESS_DATE}${PROCESS_DATE} > ${RPT_DIR}/cardirb001 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/cardirb001`"
	echo "     `grep "ERROR" ${RPT_DIR}/cardirb001`"
	touch ${DIR_2}/CARDIRBMAS.done
}

#
# MAC extract
mac_extract()
{
	${SHELL_DIR}/mac002.sh > ${RPT_DIR}/mac002 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/mac002`"
	echo "     `grep "ERROR" ${RPT_DIR}/mac002`"
	touch ${DIR_2}/MAC00RB001.done
}

#
# REIMB extract
reimb_extract()
{
	rm -f ${REIMB_EXTRACT}
	cd ${FLEX}
	${FLEX}/ohrmbrb001.cs
	echo "     TOTAL RECORDS:  `wc -l ${REIMB_EXTRACT}`"
	#echo "    `ls -og ${REIMB_EXTRACT}`"
	touch ${REIMB_EXTRACT}.done
}
	
#
# EXCEPTION extract
excep_extract()
{
	${SHELL_DIR}/excep01.sh > ${RPT_DIR}/excep01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/excep01`"
	#echo "     TOTAL RECORDS:  `wc -l ${EXCEPRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/excep01`"
	touch ${DIR_2}/EXCEPRB001.done
}

#
# OVERRIDE extract
override_extract()
{
	${SHELL_DIR}/override01.sh > ${RPT_DIR}/override01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/override01`"
	echo "     `grep "ERROR" ${RPT_DIR}/override01`"
	touch ${DIR_2}/OVERIRB001.done
}

#
# PDECL00MAS extract
pdecl_extract()
{
	${SHELL_DIR}/pdecl02.sh > ${RPT_DIR}/pdecl02 2>&1
	#echo "     `grep "PDECL RECORD COUNT:" ${RPT_DIR}/pdecl02`"
	echo "     TOTAL RECORDS:  `wc -l ${PDECLRB001}`"
	echo "     `grep "ERROR" ${RPT_DIR}/pdecl02`"
	touch ${DIR_2}/PDECLRB001.done
}

#
# GENTB extract
gentb_extract()
{
	${SHELL_DIR}/gentb02.sh -f > ${RPT_DIR}/gentb02 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/gentb02`"
	echo "     `grep "ERROR" ${RPT_DIR}/gentb02`"
	touch ${DIR_2}/GENTBRB001.done
}

#
# PHYS extract
phys_extract()
{
	${SHELL_DIR}/physi01.sh > ${RPT_DIR}/physi01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/physi01`"
	echo "     `grep "ERROR" ${RPT_DIR}/physi01`"
	touch ${DIR_2}/PHYSIRB001.done
}

#
# DIFTB extract
diftb_extract()
{
	${SHELL_DIR}/diftb01.sh > ${RPT_DIR}/diftb01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/diftb01`"
	echo "     `grep "ERROR" ${RPT_DIR}/diftb01`"
	touch ${DIR_2}/DIFTBRB001.done
}

#
# FIRTR extract
firtr_extract()
{
	${SHELL_DIR}/firtr02.sh > ${RPT_DIR}/firtr02 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/firtr02`"
	echo "     `grep "ERROR" ${RPT_DIR}/firtr02`"
	touch ${DIR_2}/FIRTRRB001.done
}

#
# Drug Extract
drug_extract()
{
        rm -f ${DIR_2}/DRUGRB001.zip
        ${SHELL_DIR}/drug002.sh > ${RPT_DIR}/drug002 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/drug002`"
        echo "     `grep "ERROR" ${RPT_DIR}/drug002`"
        ${ZIP_PROG} -jm ${ZIP_DIR}/DRUGRB001.zip ${DRUGRB001}
        mv ${ZIP_DIR}/DRUGRB001.zip ${DIR_2}
        touch ${DIR_2}/DRUGRB001.zip.done
}

#
# MEDNAM Extract
mednam_extract()
{
        ${SHELL_DIR}/medirb01.sh > ${RPT_DIR}/medirb01 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/medirb01`"
        echo "     `grep "ERROR" ${RPT_DIR}/medirb01`"
        touch ${DIR_2}/MEDNAME.done
}

#
# MEDNDC Extract
medndc_extract()
{
        ${SHELL_DIR}/medirb02.sh > ${RPT_DIR}/medirb02 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/medirb02`"
        echo "     `grep "ERROR" ${RPT_DIR}/medirb02`"
        touch ${DIR_2}/MEDNDC.done
}

#
# MEDVAL Extract
medval_extract()
{
        ${SHELL_DIR}/medirb03.sh > ${RPT_DIR}/medirb03 2>&1
        echo "     `grep "WRITTEN" ${RPT_DIR}/medirb03`"
        echo "     `grep "ERROR" ${RPT_DIR}/medirb03`"
        touch ${DIR_2}/MEDVAL.done
}

#
# Step Therapy Extract
step_extract()
{
	${SHELL_DIR}/steptrb01.sh > ${RPT_DIR}/steptrb01 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/steptrb01`"
	echo "     `grep "ERROR" ${RPT_DIR}/steptrb01`"
	touch ${DIR_2}/STEPTRB001.done
}

#
# Suspend File Extract
susp_extract()
{
	${SHELL_DIR}/susp004.sh > ${RPT_DIR}/susp004 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/susp004`"
	echo "     `grep "ERROR" ${RPT_DIR}/susp004`"
	touch ${DIR_2}/SUSPRB001.done
}

#
# Main routine
#

umask 111
rm -f ${DIR_2}/*.done

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
	SW=$1
	split_sw
	;;
  esac
  shift
done

# Parse environment variables
parse_env


if [ ${SW1} = 1 ]
then
  echo 
  echo "--> Starting claims extract - claim72pdm"
  claim_extract
fi

if [ ${SW10} = 1 ]
then
  echo 
  echo "--> Starting claim80 extract - claim80rb"
  claim80_extract
fi

if [ ${SW11} = 1 ]
then
  echo 
  echo "--> Starting cardi extract - cardirb001"
  cardi_extract
fi

if [ ${SW4} = 1 ]
then
  echo
  echo "--> Starting group extract - group10"
  grp_extract
fi

if [ ${SW3} = 1 ]
then
  echo
  echo "--> Starting generic table extract - gener01"
  gen_extract
fi

if [ ${SW5} = 1 ]
then
  echo
  echo "--> Starting plan extract - plan01"
  pln_extract
fi

if [ ${SW2} = 1 ]
then
  echo
  echo "--> Starting copay extract - copay01"
  copay_extract
fi

if [ ${SW7} = 1 ]
then
  echo
  echo "--> Starting card extract - cardh52"
  card_extract
fi

if [ ${SW8} = 1 ]
then
  echo
  echo "--> Starting phdem extract - phdem03"
  phdem_extract
fi

if [ ${SW9} = 1 ]
then
  echo
  echo "--> Starting phnet extract - phnet12"
  phnet_extract
fi

if [ ${SW12} = 1 ]
then
  echo 
  echo "--> Starting mac extract - mac002"
  mac_extract
fi

if [ ${SW13} = 1 ]
then
  echo 
  echo "--> Starting reimb extract - ohrmbrb001.cs"
  reimb_extract
fi

if [ ${SW14} = 1 ]
then
  echo 
  echo "--> Starting exception extract - excep01"
  excep_extract
  echo
  echo "--> Starting override extract - override01"
  override_extract
fi

if [ ${SW15} = 1 ]
then
  echo 
  echo "--> Starting suspend file extract - susp004"
  susp_extract
fi

if [ ${SW6} = 1 ]
then
  echo 
  echo "--> Starting CATAB00MAS extract - catab01"
  catab_extract
fi

if [ ${SW17} = 1 ]
then
  echo 
  echo "--> Starting GENTB00MAS extract - gentb02"
  gentb_extract
fi

if [ ${SW18} = 1 ]
then
  echo 
  echo "--> Starting PHYSI00MAS extract - physi01"
  phys_extract
fi

if [ ${SW19} = 1 ]
then
  echo 
  echo "--> Starting DIFTB00MAS extract - diftb01"
  diftb_extract
  echo 
  echo "--> Starting FIRTR00MAS extract - firtr02"
  firtr_extract
fi

if [ ${SW16} = 1 ]
then
  echo 
  echo "--> Starting PDECL00MAS extract - pdecl01"
  pdecl_extract
fi

if [ ${SW20} = 1 ]
then
  if [ ${DAY} = 3 ]
  then
  	echo 
  	echo "--> Starting DRUG000MAS extract - drug002" 
  	drug_extract
	echo
	echo "--> Starting MEDNAM0MAS extract - medirb01"
	mednam_extract
	echo
	echo "--> Starting MEDNDC0MAS extract - medirb02"
	medndc_extract
	echo
	echo "--> Starting MEDVAL0MAS extract - medirb03"
	medval_extract
	echo
	echo "--> Starting STEPT00MAS extract - steptrb01"
	step_extract
  fi
fi

if [ ${HOSTNAME} = "firefly" ]
then
	cd ${DIR_2}
	find . -type f -mtime 0 -print | zip ${DATE}-files.zip -@
	scp -q ${DATE}-files.zip prod11:/store/sqlimports/misc
	ssh prod11 "unzip -od /store/sqlimports/misc /store/sqlimports/misc/${DATE}-files.zip"
        ssh prod11 "rm -f /store/sqlimports/misc/CL72-*"	
fi

if [ ${HOSTNAME} = "rook" ]
then
        cd ${DIR_2}
        scp -q CL72.${DATE}.sql* s1rook:/store/sqlimports/claims
        scp -q wh_daily_claims_count s1rook:/store/sqlimports/claims
fi

exit 0
