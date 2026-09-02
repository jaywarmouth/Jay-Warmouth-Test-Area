#!/bin/sh
#
# Program Name	: audit01.sh
# Description   : Create Redbrick Files from Audits 
#                 Command line arguments:
#                 -t Type of run (all | fg4 | grp | lim | pha | emb | rev | chk | crd | pde | clm | dmr)
#                 -r Rerun (date of file(s) <ccyymmdd> as argument)
#			<ccyymmdd> - date format for all audits
# Author	: Linda S. Jefferis
# Date		: 10/22/2010 
# Modifications : 08/09/2011 - Change DATE format(including DMR) and rerun option
#		: 08/23/2011 - Fix issue with DMR name being "DMR." instead of "DMR-"
#				changed how FNAME[?] variables assigned.
#		: 02/16/2012 - Added logic for EXCLU00MAS 
#		: 03/04 2013 - Add logic for "RS"
#		: 05/13/2013 - Add logic for "TC", "ZI", "CN"
#		: 09/18/2013 - Added "counts" file logic and removed email logic
#		: 03/10/2016 - TT13309-6
#		: 06/22/2016 - TT3200-65; "LA" logic
#		: 07/07/2016 - TT15027-6 "RB" logic
#		: 07/25/2016 - TT13990-58 "EN" logic
#		: 01/09/2017 - TT16324-2 "VC" and "VB" logic
#		: 08/14/2017 - TT8864-47 "RM" logic
#		: 09/08/2017 - TT8864-57 "RD" logic
#		: 09/08/2017 - TT17539-8 "DB" logic
#		: 10/16/2017 - TT17552-11, TT17652-4
#		: 05/31/2018 - TT18207-58 "RJ" logic
#		: 06/12/2018 - TT8864-69; new "RA", "RF" logic; removal of "RD"
#		: 10/19/2018 - Ticket18977; new "BF" and "BY"
#		: 05/21/2019 - 18987-19; "DI" 
#		: 05/28/2019 - TT19645-9 "CF"; TT19688-7 "MF"
#		: 06/25/2019 - TT18824-28 "NP"; TT19176-7 "CI"; TT19489-7 "MS"
#		: 07/02/2019 - TT19730-7 "RP"; TT19736-7 "RC"; TT19747-7 "RO"
#		: 10/02/2019 - TT19941-7 "SX"
#		: 03/10/2020 - TT20027-23 "D3"
#		: 05/05/2020 - TT3200-302 "NU"
#		: 10/19/2021 - New "MO" (MULTOV0MAS)
#		: 04/14/2022 - New "NI" (NDCINC0MAS)
#		: 06/13/2022 - Added "GE" (GENER00MAS)
#		: 07/14/2022 - Added "TB"(TBRBEN0MAS), "TG"(TGRP000MAS), "TT"(TITTRACMAS)
#		: 12/27/2022 - added in sprint 405 deployment:  BE(BENEF00MAS), RG(REJMSG0MAS) 
#		: 08/22/2023 - sprint 440: add MN (MCONF00MAS) Task #22386-35
#		: 02/13/2024 - sprint465: add BR (BROPREJMAS)
#		: 02/20/2024 - sprint466: add "SC" (STCOMP0MAS)
#		: 04/11/2024 - sprint473: add "SG" (STCFG00MAS)
#		: 07/16/2024 - sprint486; add "DP" (DRGPRC0MAS)
#		: 09/24/2024 - sprint497; add "NK" (NDCHK00MAS)
#		: 03/25/2025 - sprint523; add "CG" (CAGRPXWMAS)
#		: 07/28/2025 - Adding logic for s3 location to provide to AWS cloud team. (DME)
#               : 10/10/2025 - sprint551; add "CB" (CABIN00MAS)
#               : 05/19/2026 - Sprint583; add "GG" (GRPGRPXMAS)

# Variables Used:
PATH=/opt/rmcobol:$PATH
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RERUN=0
ARGUMENT=""
AUDIT_PATH="/usr/lnk/audit"
EXPORT_PATH="/usr/lnk/sqlimports/audit"
AWS_DIR="s3://ga-internal-transfers/PDMI/AuditExtracts/"
OUT_DIR="audit"
SQL_DIR="/usr/lnk/wt/sqlimports"
ZIP_PROG="/bin/gzip"
TR_ERR=0
RUN_TYPE="null"
FNAME[1]="FG4AUD."
FNAME[2]="GRPAUD."
FNAME[3]="PHAAUD."
FNAME[4]="LIMAUD."
FNAME[5]="EMBAUD."
FNAME[6]="REVAUD."
FNAME[7]="CLAIM02."
FNAME[8]="DMR-"
FNAME[9]="CHKAUD."
FNAME[10]="CRDAUD."
FNAME[11]="CRDAUD-RT."
FNAME[12]="CRDAUD-FG."
FNAME[13]="PDEAUD."

MAXVALUE=13

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: audit01.sh [-t all|fg4|grp|lim|pha|emb|rev|clm|dmr|chk|crd|pde] [-r <mmddyy><yymmdd>]

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
# Set date
set_date()
{
  if [ ${RERUN} = 1 ]
    then
        DATE=`echo ${ARGUMENT} | cut -c1-8`
        #zcat ${AUDIT_PATH}/${AUD_NAME}${DATE} > ${AUDIT_PATH}/AUDTMP-${DATE}
        #FG4AUD=${AUDIT_PATH}/AUDTMP-${DATE}
	FG4AUD=${AUDIT_PATH}/${AUD_NAME}${DATE}
	EXP_DATE=`echo ${ARGUMENT} | cut -c1-8`
    else
        DATE=`date -d "yesterday 0800" +%Y%m%d`
	EXP_DATE=`date -d "yesterday 0800" +%Y%m%d`
        FG4AUD=${AUDIT_PATH}/${AUD_NAME}${DATE}
  fi
}


#
# Submit audit01
submit_audit01()
{
    AO=${EXPORT_PATH}/AO-${EXP_DATE};export AO	# ADDON00MAS
    AD=${EXPORT_PATH}/AD-${EXP_DATE};export AD	# ADMIN00MAS
    BC=${EXPORT_PATH}/BC-${EXP_DATE};export BC  # BRCFG00MAS
    BB=${EXPORT_PATH}/BB-${EXP_DATE};export BB  # BRBEN00MAS
    BE=${EXPORT_PATH}/BE-${EXP_DATE};export BE  # BENEF00MAS
    BF=${EXPORT_PATH}/BF-${EXP_DATE};export BF  # BINCF00MAS
    BH=${EXPORT_PATH}/BH-${EXP_DATE};export BH  # BRCHN00MAS
    BR=${EXPORT_PATH}/BR-${EXP_DATE};export BR  # BROPREJMAS
    BY=${EXPORT_PATH}/BY-${EXP_DATE};export BY  # BINTY00MAS
    BZ=${EXPORT_PATH}/BZ-${EXP_DATE};export BZ  # BRZIP00MAS
    CA=${EXPORT_PATH}/CA-${EXP_DATE};export CA	# Cardholder	
    CF=${EXPORT_PATH}/CF-${EXP_DATE};export CF	# CONFIG0MAS	
    CG=${EXPORT_PATH}/CG-${EXP_DATE};export CG	# CAGRPXWMAS	
    CI=${EXPORT_PATH}/CI-${EXP_DATE};export CI	# CLID000MAS	
    CK=${EXPORT_PATH}/CK-${EXP_DATE};export CK	# Check
    CL=${EXPORT_PATH}/CL-${EXP_DATE};export CL	# Claims
    CN=${EXPORT_PATH}/CN-${EXP_DATE};export CN	# CARANGEMAS
    CO=${EXPORT_PATH}/CO-${EXP_DATE};export CO	# Copay
    CT=${EXPORT_PATH}/CT-${EXP_DATE};export CT	# CATAB00MAS
    CW=${EXPORT_PATH}/CW-${EXP_DATE};export CW   # CACWA00MAS
    CB=${EXPORT_PATH}/CB-${EXP_DATE};export CB  # CABIN00MAS
    DB=${EXPORT_PATH}/DB-${EXP_DATE};export DB	# DR340B
    DC=${EXPORT_PATH}/DC-${EXP_DATE};export DC	# Dose Check
    DI=${EXPORT_PATH}/DI-${EXP_DATE};export DI  # DIFCT00MAS Differential Types
    DR=${EXPORT_PATH}/DR-${EXP_DATE};export DR	# Drug
    DP=${EXPORT_PATH}/DP-${EXP_DATE};export DP  # DRGPRC0MAS Drug Pricing
    D3=${EXPORT_PATH}/D3-${EXP_DATE};export D3  # DRUG003MAS
    DT=${EXPORT_PATH}/DT-${EXP_DATE};export DT	# Differential Table
    ED=${EXPORT_PATH}/ED-${EXP_DATE};export ED	# Exception DEA
    EF=${EXPORT_PATH}/EF-${EXP_DATE};export EF   # EFT0000MAS
    EL=${EXPORT_PATH}/EL-${EXP_DATE};export EL   # EXCLU00MAS
    EM=${EXPORT_PATH}/EM-${EXP_DATE};export EM	# Emboss
    EN=${EXPORT_PATH}/EN-${EXP_DATE};export EN	# ENROL00MAS
    EX=${EXPORT_PATH}/EX-${EXP_DATE};export EX	# Exception
    GD=${EXPORT_PATH}/GD-${EXP_DATE};export GD	# GDESC00MAS
    GE=${EXPORT_PATH}/GE-${EXP_DATE};export GE  # GENER00MAS
    GG=${EXPORT_PATH}/GG-${EXP_DATE};export GG  # GRPGRPXMAS
    GR=${EXPORT_PATH}/GR-${EXP_DATE};export GR	# Group
    GS=${EXPORT_PATH}/GS-${EXP_DATE};export GS	# GDRSD00MAS
    GT=${EXPORT_PATH}/GT-${EXP_DATE};export GT	# Generic Table
    IL=${EXPORT_PATH}/IL-${EXP_DATE};export IL	# INLOG00MAS
    LA=${EXPORT_PATH}/LA-${EXP_DATE};export LA	# Limit Archive
    LI=${EXPORT_PATH}/LI-${EXP_DATE};export LI	# Limit
    MC=${EXPORT_PATH}/MC-${EXP_DATE};export MC	# MAC
    MF=${EXPORT_PATH}/MF-${EXP_DATE};export MF	# MCONFIGMAS
    MN=${EXPORT_PATH}/MN-${EXP_DATE};export MN  # MCONF00MAS
    MS=${EXPORT_PATH}/MS-${EXP_DATE};export MS	# MESG000MAS
    MO=${EXPORT_PATH}/MO-${EXP_DATE};export MO  # MULTOV0MAS
    NC=${EXPORT_PATH}/NC-${EXP_DATE};export NC	# NDCOM00MAS
    ND=${EXPORT_PATH}/ND-${EXP_DATE};export ND	# Network Demographic
    NI=${EXPORT_PATH}/NI-${EXP_DATE};export NI	# NDCINC0MAS
    NK=${EXPORT_PATH}/NK-${EXP_DATE};export NK  # NDCHK00MAS NDC Prerequisite File
    NL=${EXPORT_PATH}/NL-${EXP_DATE};export NL	# NDCLOCKMAS
    NM=${EXPORT_PATH}/NM-${EXP_DATE};export NM	# NDCDM00MAS
    NO=${EXPORT_PATH}/NO-${EXP_DATE};export NO  # NSDEOVRMAS
    NP=${EXPORT_PATH}/NP-${EXP_DATE};export NP  # NPI0000MAS
    NS=${EXPORT_PATH}/NS-${EXP_DATE};export NS  # NSDE000MAS
    NU=${EXPORT_PATH}/NU-${EXP_DATE};export NU  # NUMOT00MAS
    ON=${EXPORT_PATH}/ON-${EXP_DATE};export ON   # ONETM00MAS
    OV=${EXPORT_PATH}/OV-${EXP_DATE};export OV	# Override
    PC=${EXPORT_PATH}/PC-${EXP_DATE};export PC	# PCP
    PD=${EXPORT_PATH}/PD-${EXP_DATE};export PD	# Pharmacy Demographic
    PE=${EXPORT_PATH}/PE-${EXP_DATE};export PE   # PDECL00MAS
    PH=${EXPORT_PATH}/PH-${EXP_DATE};export PH	# PHO
    PL=${EXPORT_PATH}/PL-${EXP_DATE};export PL	# Plan
    PN=${EXPORT_PATH}/PN-${EXP_DATE};export PN	# Pharmacy Network
    PO=${EXPORT_PATH}/PO-${EXP_DATE};export PO	# PRCOV00MAS
    PY=${EXPORT_PATH}/PY-${EXP_DATE};export PY	# Physician
    RB=${EXPORT_PATH}/RB-${EXP_DATE};export RB  # REBAD00MAS
    RC=${EXPORT_PATH}/RC-${EXP_DATE};export RC  # RCD0000MAS
    RJ=${EXPORT_PATH}/RJ-${EXP_DATE};export RJ	# REJCD00MAS
    RA=${EXPORT_PATH}/RA-${EXP_DATE};export RA  # RBADR00MAS
    RF=${EXPORT_PATH}/RF-${EXP_DATE};export RF  # RBADF00MAS
    RG=${EXPORT_PATH}/RG-${EXP_DATE};export RG  # REJMSG0MAS
    RM=${EXPORT_PATH}/RM-${EXP_DATE};export RM  # RBADM00MAS
    RN=${EXPORT_PATH}/RN-${EXP_DATE};export RN	# Rented Network Description
    RO=${EXPORT_PATH}/RO-${EXP_DATE};export RO  # RCODE00MAS
    RP=${EXPORT_PATH}/RP-${EXP_DATE};export RP  # RCP0000MAS
    RR=${EXPORT_PATH}/RR-${EXP_DATE};export RR	# Reimbursement Rate
    RS=${EXPORT_PATH}/RS-${EXP_DATE};export RS   # RESTK00MAS
    RV=${EXPORT_PATH}/RV-${EXP_DATE};export RV	# Reversals
    SP=${EXPORT_PATH}/SP-${EXP_DATE};export SP	# SPONS00MAS
    ST=${EXPORT_PATH}/ST-${EXP_DATE};export ST	# Step Therapy
    SU=${EXPORT_PATH}/SU-${EXP_DATE};export SU	# SUSP000MAS
    SX=${EXPORT_PATH}/SX-${EXP_DATE};export SX	# STEXC00MAS
    SY=${EXPORT_PATH}/SY-${EXP_DATE};export SY	# SYSTE00MAS
# Below commented out since WH doesn't have anything for this and conflicts withother CR variable assignment for env_var
    #CR=${EXPORT_PATH}/CR-${EXP_DATE};export CR   # CLMRS00MAS
    SB=${EXPORT_PATH}/SB-${EXP_DATE};export SB	# SPECTB0MAS
    SC=${EXPORT_PATH}/SC-${EXP_DATE};export SC  # STCOMP0MAS
    SG=${EXPORT_PATH}/SG-${EXP_DATE};export SG  # STCFG00MAS
    SS=${EXPORT_PATH}/SS-${EXP_DATE};export SS	# SPTDS00MAS
    SF=${EXPORT_PATH}/SF-${EXP_DATE};export SF	# SPCFG00MAS
    SD=${EXPORT_PATH}/SD-${EXP_DATE};export SD	# SPCFDS0MAS
    TB=${EXPORT_PATH}/TB-${EXP_DATE};export TB	# TBRBEN0MAS
    TC=${EXPORT_PATH}/TC-${EXP_DATE};export TC	# TCZIP00MAS
    TG=${EXPORT_PATH}/TG-${EXP_DATE};export TG	# TGRP000MAS
    TP=${EXPORT_PATH}/TP-${EXP_DATE};export TP	# TPM00MAS
    TT=${EXPORT_PATH}/TT-${EXP_DATE};export TT	# TITTRACMAS
    VC=${EXPORT_PATH}/VC-${EXP_DATE};export VC  # VRXCF00MAS
    VB=${EXPORT_PATH}/VB-${EXP_DATE};export VB  # VRXBP00MAS
    ZI=${EXPORT_PATH}/ZI-${EXP_DATE};export ZI  # ZIPTT00MAS
  echo "FG4AUD="${FG4AUD}
  runcobol ${OBJ_DIR}/audit01 -k
}

#
# Transfer file
file_transfer()
{
        ${ZIP_PROG} ${FNAME}
	/usr/local/bin/aws s3 cp ${FNAME}.gz ${AWS_DIR} --only-show-errors
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
	  set_date
	  submit_audit01
	  let i=i+1
	done
       ;;
    "fg4")
	AUD_NAME="${FNAME[1]}"
	set_date
	submit_audit01
       ;;
    "grp")
	AUD_NAME="${FNAME[2]}"
        set_date
        submit_audit01
       ;;
    "lim")
	AUD_NAME="${FNAME[4]}"
        set_date
        submit_audit01
       ;;
    "pha")
	AUD_NAME="${FNAME[3]}"
        set_date
        submit_audit01
       ;;
    "emb")
	AUD_NAME="${FNAME[5]}"
        set_date
        submit_audit01
       ;;
    "rev")
        AUD_NAME="${FNAME[6]}"
        set_date
        submit_audit01
       ;;
    "clm")
	AUD_NAME="${FNAME[7]}"
        set_date
        submit_audit01
       ;;
    "dmr")
	AUD_NAME="${FNAME[8]}"
        set_date
        submit_audit01
	;;
    "chk")
	AUD_NAME="${FNAME[9]}"
	set_date
	submit_audit01
	;;
    "crd")
	AUD_NAME="${FNAME[10]}"
	set_date
	submit_audit01
	AUD_NAME="${FNAME[11]}"
	set_date
        submit_audit01
	AUD_NAME="${FNAME[12]}"
	set_date
        submit_audit01
	;;
    "pde")
        AUD_NAME="${FNAME[13]}"
        set_date
        submit_audit01
       ;;
  esac
fi

cd $EXPORT_PATH
echo $EXP_DATE
wc -l ??-$EXP_DATE | awk -v d=$EXP_DATE '{ print $2","$1","d }' > $EXPORT_PATH/auditfile-counts-$EXP_DATE
FNAME=$EXPORT_PATH/auditfile-counts-$EXP_DATE
file_transfer
#rm -f $EXPORT_PATH/auditfile-counts-$EXP_DATE.gz

find $EXPORT_PATH -name "??-$EXP_DATE" -print > /tmp/audit01-file-list

IFS=$CR
for FNAME in `cat /tmp/audit01-file-list`
do
	file_transfer
done
rm -f /tmp/audit01-file-list

date

exit 0
