#!/bin/ksh
#
# Program Name	: demo_extracts.sh
# Description	: Procedure to create daily files for redbrick
#		  Command Line Arguments:
#		  -u <###########> switch settings for which files to extract
#                       SW1 - CLAIMS
#                       SW2 - COPAY
#                       SW3 - GPI
#                       SW4 - GROUP
#                       SW5 - PLAN
#                       SW6 - DRUG
#                       SW7 - CARD
#                       SW8 - PHDEM
#                       SW9 - PHNET
#			SW10- CLAIM80
#			SW11- CARDI
#			SW12- MAC
#			SW13- REIMB
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
#		: 10/17/2005 (LSJ) Changes for Linux commands
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
CONV_PROG="/usr/local/bin/char_repl"
FILE1=CL72PDMD
FILE2=CL72
DIR_1=/usr/lnk/tmp
DIR_2=/usr/lnk/demo/rb_export
DATE=`date +%m%d%y`
DAY=`date +%w`
PREV_DAY=`/usr/local/bin/yesterday`
PROCESS_DATE="20${PREV_DAY}"
NET="000000000000"
SYS="00000000"
FLEX="/usr/lnk/flexgen"
REIMB_EXTRACT="/usr/lnk/demo/rb_export/ohrmbrb001"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_clms.sh [-u <###########> (1's or 0's)]

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
}

# Claims Extract
claim_extract()
{
	${SHELL_TST}/claim72pdm.sh -z -r "BA01A000CL31Z999/usr/clm_10/CL72.demo         " -f /usr/lnk/demo/CLAIM00TST -z > ${RPT_DIR}/claim72pdm.demo 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/claim72pdm.demo`"
	#cat /usr/lnk/demo/CL72.demo | ${CONV_PROG} 0 32 > ${DIR_2}/${FILE2}.${DATE}.sql
	#rm -f ${DIR_1}/???${FILE1}
}

# Claim80 Extract
claim80_extract()
{
	${SHELL_DIR}/claim80rb.sh -z -b BA01A000CL31Z999 > ${RPT_DIR}/claim80rb.demo 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/claim80rb.demo`"
}

#
# Group Extract
grp_extract()
{
	${SHELL_DIR}/group10.sh -z > ${RPT_DIR}/group10.demo 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/group10.demo`"
}

#
# Plan Extract
pln_extract()
{
	${SHELL_DIR}/plan01.sh -z > ${RPT_DIR}/plan01.demo 2>&1
        echo "     `grep "COUNT"  ${RPT_DIR}/plan01.demo`"
}

#
# Copay Extract
copay_extract()
{
	${SHELL_DIR}/copay01.sh -z > ${RPT_DIR}/copay01.demo 2>&1
        echo "     `grep "COUNT" ${RPT_DIR}/copay01.demo`"
}


#
# Generic Extract
gen_extract()
{
	${SHELL_DIR}/gener01.sh -z > ${RPT_DIR}/gener01.demo 2>&1
	echo "     `grep "COUNT" ${RPT_DIR}/gener01.demo`"
}

#
# Drug Extract
drug_extract()
{
	rm -f ${DIR_2}/DRUGRB001.zip
	${SHELL_DIR}/drug002.sh -z > ${RPT_DIR}/drug002.demo 2>&1
	echo "     `grep "COUNT" ${RPT_DIR}/drug002.demo`"
	${ZIP_PROG} -jm ${ZIP_DIR}/DRUGRB001.zip ${DRUGRB001}
	mv ${ZIP_DIR}/DRUGRB001.zip ${DIR_2}
}

#
# Card Extract
card_extract()
{
	SYS=99989999
	rm -f ${DIR_2}/CARDHRB001.zip
	${SHELL_DIR}/cardh52.sh -a ${SYS} -s -z > ${RPT_DIR}/cardh52.demo 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/cardh52.demo`"
	#${ZIP_PROG} -jm ${ZIP_DIR}/CARDHRB001.zip ${CARDHRB001}
	#mv ${ZIP_DIR}/CARDHRB001.zip ${DIR_2}
}

#
# Pharmacy Demographic Extract
phdem_extract()
{
	${SHELL_DIR}/phdem03.sh -z > ${RPT_DIR}/phdem03.demo 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/phdem03.demo`"
}

#
# Pharmacy Network Extract
phnet_extract()
{
	NET=000000999999
	rm -f ${DIR_2}/PHNETRB001.zip
	${SHELL_DIR}/phnet12.sh -a ${NET} -z > ${RPT_DIR}/phnet12.demo 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/phnet12.demo`"
	#${ZIP_PROG} -jm ${ZIP_DIR}/PHNETRB001.zip ${PHNETRB001}
	#mv ${ZIP_DIR}/PHNETRB001.zip ${DIR_2}
}

#
# CARDI extract
cardi_extract()
{
	${SHELL_DIR}/cardirb001.sh -d 2001010120021231 -z > ${RPT_DIR}/cardirb001.demo 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/cardirb001.demo`"
}

#
# MAC extract
mac_extract()
{
	${SHELL_DIR}/mac002.sh -z > ${RPT_DIR}/mac002.demo 2>&1
	echo "     `grep "WRITTEN" ${RPT_DIR}/mac002.demo`"
}

#
# REIMB extract
reimb_extract()
{
	rm -f ${REIMB_EXTRACT}
	cd ${FLEX}
	ohrmbrb001_demo.cs
	echo "    `ls -og ${REIMB_EXTRACT}`"
}
	
#
# Main routine
#

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

if [ ${SW11} = 1 ]
then
  echo 
  echo "--> Starting cardi extract - cardirb001"
  cardi_extract
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

if [ ${DAY} = 1 ]
then
  if [ ${SW6} = 1 ]
  then
    echo
    echo "--> Starting drug extract - drug002"
    drug_extract
  fi
fi

exit 0
