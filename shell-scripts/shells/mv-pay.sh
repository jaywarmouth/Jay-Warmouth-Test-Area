#!/bin/ksh
#
# Program Name	: mv-pay.sh
# Description	: Moving pay-cycle files to rptarch
#		  Command line arguments:
#		  -p <p/e prefix>  e.g. K29
# Author	: Linda S. Jefferis
# Date		: 09/25/98
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
RPTARCH="/usr/lnk/rptarch"
PREFIX="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv-pay.sh [-p <p/e prefix>]

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
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PREFIX=$1
        ;;
esac
  shift
done


# Parse environment variables
#parse_env

if [ ${PREFIX} = "null" ]
then
   usage
else
   cd ${PO_DIR}
   find . -name "*CL07*" -print -exec compress {} \;
   find . -name "*CL20*" -print -exec compress {} \;
   find . -name "*CL28?.P1" -print -exec compress {} \;
   find . -name "*CL28?.REJ" -print -exec compress {} \;
   find . -name "*CL30*" -print -exec compress {} \;
   find . -name "*CL05*" -print -exec compress {} \;
   find . -name "*CL06*" -print -exec compress {} \;
   find . -name "*CL37*" -print -exec compress {} \;
   find . -name "*CL60*" -print -exec compress {} \;
   find . -name "*CL61*" -print -exec compress {} \;
   find . -name "*CL1[6-7]*" -print -exec compress {} \;
   find . -name "*LI10*" -print -exec compress {} \;
   find sys17 -name "*CL09*" -print -exec compress {} \;
   find sys20/spo0087 -name "*CL09*" -print -exec compress {} \;
   find sys20/spo0253 -name "*CL09*" -print -exec compress {} \;
   find misc -name "${PREFIX}CL88P" -print -exec compress {} \;
   find misc -name "${PREFIX}CHKINVFILE" -print -exec compress {} \;
   find misc -name "${PREFIX}MKTINVFILE" -print -exec compress {} \;
   find . -name "*CL07*" -print  > ${PO_DIR}/pink1
   find . -name "*CL20*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL28?.P1*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL28?.REJ*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL30*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL05*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL06*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL37*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL60*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL61*" -print  >> ${PO_DIR}/pink1
   find . -name "*CL1[6-7]*" -print  >> ${PO_DIR}/pink1
   find . -name "*LI10*" -print  >> ${PO_DIR}/pink1
   find sys17 -name "*CL09*" -print >> ${PO_DIR}/pink1
   find sys20/spo0087 -name "*CL09*" -print >> ${PO_DIR}/pink1
   find sys20/spo0253 -name "*CL09*" -print >> ${PO_DIR}/pink1
   find misc -name "${PREFIX}CL88P*" -print >> ${PO_DIR}/pink1
   find misc -name "${PREFIX}CHKINVFILE*" -print >> ${PO_DIR}/pink1
   find misc -name "${PREFIX}MKTINVFILE*" -print >> ${PO_DIR}/pink1
   cat ${PO_DIR}/pink1 | cpio -ocvdB > ${PO_DIR}/pink2
   cd ${RPTARCH}
   cpio -icvdB < ${PO_DIR}/pink2
   rm ${PO_DIR}/pink?
fi

exit 0
