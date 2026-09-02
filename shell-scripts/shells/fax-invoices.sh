#!/bin/ksh
#
# Program Name	: fax-invoices.sh
# Description	: Script for invoice faxing
#		  Command Line Arguments:
#		  -s <ref#> - 4 digit reference number
# Author	: Linda S. Jefferis
# Date		: 10/31/2005
# Modifications : 11/29/2005 - Changes for new system names  (LSJ)
#		: 08/22/2006 - Changes for 4-digit system number  (LSJ)
#		: 11/24/2006 - Incorporated logic from invfax.sh and added logic for sys0075/spo0492  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: fax-invoices.sh -s <sys#>
	-s <ref#> - 4-digit reference number 	(required) 

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        REF=$1
        ;;
esac
  shift
done


# Parse environment variables
#parse_env


FAXFROM="PDM,Inc." ; export FAXFROM
case ${REF} in
   "0067")
	rm -f ${PO_DIR}/sys0067/inv${REF}
	cat ${PO_DIR}/sys0067/???CL16A-P.P2 >> ${PO_DIR}/sys0067/inv${REF}
        cat ${PO_DIR}/sys0067/???CL17A-P.P2 >> ${PO_DIR}/sys0067/inv${REF}
        cat ${PO_DIR}/sys0067/spo0351/???CL16B-P.P2 >> ${PO_DIR}/sys0067/inv${REF}
        cat ${PO_DIR}/sys0067/spo0351/???CL17B-P.P2 >> ${PO_DIR}/sys0067/inv${REF}
        cat ${PO_DIR}/sys0067/spo0352/???CL16B-P.P2 >> ${PO_DIR}/sys0067/inv${REF}
        cat ${PO_DIR}/sys0067/spo0352/???CL17B-P.P2 >> ${PO_DIR}/sys0067/inv${REF}
	fax "Go2 PBM Services/Susan Bongiovanni" "${PO_DIR}/sys0067/inv${REF}" "17275444386" "port"
	;;
   "0347")
	rm -f ${PO_DIR}/sys0069/spo0347/inv${REF}
        cat ${PO_DIR}/sys0069/spo0347/???CL16B-P.P2 >> ${PO_DIR}/sys0069/spo0347/inv${REF}
        cat ${PO_DIR}/sys0069/spo0347/???CL17B-P.P2 >> ${PO_DIR}/sys0069/spo0347/inv${REF}
	fax "Tammy Corral" "${PO_DIR}/sys0069/spo0347/inv${REF}" "14193524320" "port"
	;;
   "0492")
	rm -f ${PO_DIR}/sys0075/spo0492/inv${REF}
        cat ${PO_DIR}/sys0075/spo0492/???CL16B-O.P2 >> ${PO_DIR}/sys0075/spo0492/inv${REF}
        cat ${PO_DIR}/sys0075/spo0492/???CL17B-O.P2 >> ${PO_DIR}/sys0075/spo0492/inv${REF}
	fax "Donny Dowlen" "${PO_DIR}/sys0075/spo0492/inv${REF}" "16158590324" "port"
	;;
   *)	echo "-*> Invalid reference number..."
	exit 1
	;;
esac

exit 0
