#!/bin/ksh
#
# Program Name	: invfax.sh
# Description	: Script for invoice faxing
#		  Command Line Arguments:
#		  -s <sys#> - 4 digits
# Author	: Linda S. Jefferis
# Date		: 11/02/2001
# Modifications : 05/10/2004 - Added sys67  (LSJ)
#		  07/02/2004 - Added sys46  (LSJ)
#		: 01/03/2005 - Changes for newcycle filenames  (LSJ)
#		: 10/31/2005 - Added sys75  (LSJ)
#		: 10/31/2005 - Removed sys43 and sys46  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: invfax.sh -s <sys#>
	-s <sys#> - 4-digit system number 	(required) 

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
        SYS=$1
        ;;
esac
  shift
done


# Parse environment variables
#parse_env

rm -f ${PO_DIR}/sys${SYS}/inv${SYS}
case ${SYS} in
   "0017")
	cat ${PO_DIR}/sys${SYS}/???CL16A-O.P2 >> ${PO_DIR}/sys${SYS}/inv${SYS}
	;;
   "0067")
	cat ${PO_DIR}/sys${SYS}/???CL16A-P.P2 >> ${PO_DIR}/sys${SYS}/inv${SYS}
	cat ${PO_DIR}/sys${SYS}/???CL17A-P.P2 >> ${PO_DIR}/sys${SYS}/inv${SYS}
	cat ${PO_DIR}/sys${SYS}/spo0351/???CL16B-P.P2 >> ${PO_DIR}/sys${SYS}/inv${SYS}
	cat ${PO_DIR}/sys${SYS}/spo0351/???CL17B-P.P2 >> ${PO_DIR}/sys${SYS}/inv${SYS}
	cat ${PO_DIR}/sys${SYS}/spo0352/???CL16B-P.P2 >> ${PO_DIR}/sys${SYS}/inv${SYS}
	cat ${PO_DIR}/sys${SYS}/spo0352/???CL17B-P.P2 >> ${PO_DIR}/sys${SYS}/inv${SYS}
	;;
   "0069")
	rm -f ${PO_DIR}/sys0069/spo0347/inv0347
	cat ${PO_DIR}/sys${SYS}/spo0347/???CL16B-P.P2 >> ${PO_DIR}/sys${SYS}/spo0347/inv0347
	cat ${PO_DIR}/sys${SYS}/spo0347/???CL17B-P.P2 >> ${PO_DIR}/sys${SYS}/spo0347/inv0347
	;;
   "0075")
	rm -f ${PO_DIR}/sys0075/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0388/???CL17C-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0395/???CL16B-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0395/???CL17B-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0397/???CL16B-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0397/???CL17B-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0405/???CL16B-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0405/???CL17B-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0420/???CL16B-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	cat ${PO_DIR}/sys${SYS}/spo0405/???CL17B-O.P2 >> ${PO_DIR}/sys${SYS}/inv-abc
	;;
   *)	echo "-*> Invalid system number..."
	exit 1
	;;
esac

exit 0
