#!/bin/sh
#
# Program Name	: test-audit01.sh
# Description   : Create Warehouse Files from Audits 
#                 Command line arguments:
#                 -t Type of run (all | fg4 | grp | lim | pha | emb | rev | chk | crd | pde | clm | dmr)
#                 -r Rerun (date of file(s) <ccyymmdd> as argument)
#			<ccyymmdd> - date format for all audits
# Author	: Linda S. Jefferis


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
EXPORT_PATH="/usr/lnk/sqlimports/test/audit"
OUT_DIR="audit"
SQL_DIR="/usr/lnk/wt/sqlimports/test"
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
  
# Load the configuration file
#CONFIG_FILE="/home/ljefferi/audit01_variables.cfg"
CONFIG_FILE="/usr/local/etc/audit01_variables.cfg"
if [[ -f $CONFIG_FILE ]]; then
    source $CONFIG_FILE $EXPORT_PATH $EXP_DATE
else
    echo "Configuration file $CONFIG_FILE not found."
    exit 1
fi

echo "FG4AUD="${FG4AUD}
runcobol ${OBJ_DIR}/audit01 -k
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
