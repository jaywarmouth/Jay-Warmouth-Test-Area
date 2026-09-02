#!/bin/ksh
#
# Program Name	: audit01conv.sh
# Description   : Create Redbrick Files from Audits 
#                 Command line arguments:
#                 -t Type of run (all | fg4 | grp | lim | pha | emb | rev | chk | crd | pde | clm | dmr)
#                 -r Rerun (date of file(s) <mmddyy><yymmdd> as argument)
#			<mmddyy> - date format for all audits except DMR
#		  	<yymmdd> - DMR date format
# Author	: Linda S. Jefferis
# Date		: 08/19/2011 
# Modifications : 
#


# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RERUN=0
ARGUMENT=""
#AUDIT_PATH="/usr/lnk/audit"
AUDIT_PATH="/usr/lnk/audit/backup"
EXPORT_PATH="/usr/lnk/sqlimports/audit"
OUT_DIR="audit"
SQL_DIR="/usr/lnk/wt/sqlimports"
ZIP_PROG="/bin/gzip"
TR_ERR=0
RUN_TYPE="null"
FNAME[1]="FG4AUD"
FNAME[2]="GRPAUD"
FNAME[3]="PHAAUD"
FNAME[4]="LIMAUD"
FNAME[5]="EMBAUD"
FNAME[6]="REVAUD"
FNAME[7]="CLAIM02"
FNAME[8]="DMR"
FNAME[9]="CHKAUD"
FNAME[10]="CRDAUD"
FNAME[11]="CRDAUD-RT"
FNAME[12]="CRDAUD-FG"
FNAME[13]="PDEAUD"
MAIL_PROG="/bin/mail"
#MAIL_WHSE=warehouse@pdmi.com
MAIL_WHSE=ljefferis@pdmi.com

MAXVALUE=13

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: audit01conv.sh [-t all|fg4|grp|lim|pha|emb|rev|clm|dmr|chk|crd|pde] [-r <mmddyy><yymmdd>]

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

#
# Validate -t options
validate_runtype()
{
  case ${RUN_TYPE} in
    "all" | "fg4" | "grp" | "lim" | "pha" | "emb" | "rev" | "clm" | "dmr" | "chk" | "crd" | "pde")
       ;;
    *) usage
       ;;
  esac
}

#
# Set date type 1
set_date1()
{
  if [ ${RERUN} = 1 ]
    then
        DATE=`echo ${ARGUMENT} | cut -c1-6`
        FG4AUD=${AUDIT_PATH}/${AUD_NAME}.${DATE}
	EXP_DATE=`date +%C``echo ${ARGUMENT} | cut -c7-12`
    else
        DATE=`date +%m%d%y`
	EXP_DATE=`date -d "yesterday" +%Y%m%d`
        FG4AUD=${AUDIT_PATH}/${AUD_NAME}.${DATE}
  fi
}

#
# Set date for DMR
set_date2()
{
  if [ ${RERUN} = 1 ]
    then
        DATE=`echo ${ARGUMENT} | cut -c7-12`
	EXP_DATE=`date +%C``echo ${ARGUMENT} | cut -c7-12`
    else
        DATE=`/usr/local/bin/yesterday`
	EXP_DATE=`date -d "yesterday" +%Y%m%d`
  fi
  FG4AUD=${AUDIT_PATH}/DMR-${DATE}
}

#
# Submit audit01
submit_audit01()
{
    AO=${EXPORT_PATH}/AO-${EXP_DATE};export AO	# ADDON00MAS
    AD=${EXPORT_PATH}/AD-${EXP_DATE};export AD	# ADMIN00MAS
    CA=${EXPORT_PATH}/CA-${EXP_DATE};export CA	# Cardholder	
    CK=${EXPORT_PATH}/CK-${EXP_DATE};export CK	# Check
    CL=${EXPORT_PATH}/CL-${EXP_DATE};export CL	# Claims
    CO=${EXPORT_PATH}/CO-${EXP_DATE};export CO	# Copay
    CT=${EXPORT_PATH}/CT-${EXP_DATE};export CT	# CATAB00MAS
    CW=${EXPORT_PATH}/CW-${EXP_DATE};export CW   # CACWA00MAS
    DC=${EXPORT_PATH}/DC-${EXP_DATE};export DC	# Dose Check
    DR=${EXPORT_PATH}/DR-${EXP_DATE};export DR	# Drug
    DT=${EXPORT_PATH}/DT-${EXP_DATE};export DT	# Differential Table
    ED=${EXPORT_PATH}/ED-${EXP_DATE};export ED	# Exception DEA
    EM=${EXPORT_PATH}/EM-${EXP_DATE};export EM	# Emboss
    EX=${EXPORT_PATH}/EX-${EXP_DATE};export EX	# Exception
    GR=${EXPORT_PATH}/GR-${EXP_DATE};export GR	# Group
    GT=${EXPORT_PATH}/GT-${EXP_DATE};export GT	# Generic Table
    IL=${EXPORT_PATH}/IL-${EXP_DATE};export IL	# INLOG00MAS
    LI=${EXPORT_PATH}/LI-${EXP_DATE};export LI	# Limit
    MC=${EXPORT_PATH}/MC-${EXP_DATE};export MC	# MAC
    ND=${EXPORT_PATH}/ND-${EXP_DATE};export ND	# Network Demographic
    ON=${EXPORT_PATH}/ON-${EXP_DATE};export ON   # ONETM00MAS
    OV=${EXPORT_PATH}/OV-${EXP_DATE};export OV	# Override
    PC=${EXPORT_PATH}/PC-${EXP_DATE};export PC	# PCP
    PD=${EXPORT_PATH}/PD-${EXP_DATE};export PD	# Pharmacy Demographic
    PH=${EXPORT_PATH}/PH-${EXP_DATE};export PH	# PHO
    PL=${EXPORT_PATH}/PL-${EXP_DATE};export PL	# Plan
    PN=${EXPORT_PATH}/PN-${EXP_DATE};export PN	# Pharmacy Network
    PY=${EXPORT_PATH}/PY-${EXP_DATE};export PY	# Physician
    RN=${EXPORT_PATH}/RN-${EXP_DATE};export RN	# Rented Network Description
    RR=${EXPORT_PATH}/RR-${EXP_DATE};export RR	# Reimbursement Rate
    RV=${EXPORT_PATH}/RV-${EXP_DATE};export RV	# Reversals
    SP=${EXPORT_PATH}/SP-${EXP_DATE};export SP	# SPONS00MAS
    ST=${EXPORT_PATH}/ST-${EXP_DATE};export ST	# Step Therapy
    SU=${EXPORT_PATH}/SU-${EXP_DATE};export SU	# SUSP000MAS
    SY=${EXPORT_PATH}/SY-${EXP_DATE};export SY	# SYSTE00MAS
    PE=${EXPORT_PATH}/PE-${EXP_DATE};export PE   # PDECL00MAS
    EF=${EXPORT_PATH}/EF-${EXP_DATE};export EF   # EFT0000MAS
  echo "FG4AUD="${FG4AUD}
  runcobol ${OBJ_DIR}/audit01conv -k
}

#
# Transfer file
file_transfer()
{
        ${ZIP_PROG} ${FNAME}
        cp ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
                TR_ERR=1
        fi
}

 
#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RUN_TYPE=$1
        validate_runtype
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1
        ARGUMENT=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env


echo Create Redbrick Files from Audits
date

if [ ${RUN_TYPE} = "null" ]
then
  usage
else
  case ${RUN_TYPE} in
    "all")
	i=1
	while [ $i -le $MAXVALUE ]	
	do
	  AUD_NAME=${FNAME[i]}
	  if [ ${AUD_NAME} = "DMR" ]
	  then
	    set_date2
	  else
	    set_date1
	  fi
	  submit_audit01
	  let i=i+1
	done
       ;;
    "fg4")
	AUD_NAME="FG4AUD"
	set_date1
	submit_audit01
       ;;
    "grp")
	AUD_NAME="GRPAUD"
        set_date1
        submit_audit01
       ;;
    "lim")
	AUD_NAME="LIMAUD"
        set_date1
        submit_audit01
       ;;
    "pha")
	AUD_NAME="PHAAUD"
        set_date1
        submit_audit01
       ;;
    "emb")
	AUD_NAME="EMBAUD"
        set_date1
        submit_audit01
       ;;
    "rev")
        AUD_NAME="REVAUD"
        set_date1
        submit_audit01
       ;;
    "clm")
	AUD_NAME="CLAIM02"
        set_date1
        submit_audit01
       ;;
    "dmr")
	AUD_NAME="DMR"
        set_date2
        submit_audit01
	;;
    "chk")
	AUD_NAME="CHKAUD"
	set_date1
	submit_audit01
	;;
    "crd")
	AUD_NAME="CRDAUD"
	set_date1
	submit_audit01
	AUD_NAME="CRDAUD-RT"
	set_date1
        submit_audit01
	AUD_NAME="CRDAUD-FG"
	set_date1
        submit_audit01
	;;
    "pde")
        AUD_NAME="PDEAUD"
        set_date1
        submit_audit01
       ;;
  esac
fi

cd $EXPORT_PATH
wc -l ??-$EXP_DATE | ${MAIL_PROG} -s "D0 Converted AUDIT FILE COUNTS" ${MAIL_WHSE}

find $EXPORT_PATH -name "??-$EXP_DATE" -print > /tmp/audit01-file-list
IFS=$CR
for FNAME in `cat /tmp/audit01-file-list`
do
	file_transfer
done
rm -f /tmp/audit01-file-list

date

exit 0
