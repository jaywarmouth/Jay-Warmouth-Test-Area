#!/bin/ksh
#
# Program Name	: mv-off.sh
# Description	: Moving off-cycle files to rptarch
# Author	: Linda S. Jefferis
# Date		: 09/25/98
# Modifications : 11/30/98 - ???CL88O compress and move to rptarch  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
RPTARCH="/usr/lnk/rptarch"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv-off.sh 

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

# Parse environment variables
#parse_env

cd ${PO_DIR}
find . -name "*CL07*" -print -exec compress {} \;
find . -name "*CL20*" -print -exec compress {} \;
find . -name "*CL28?.P1" -print -exec compress {} \;
find . -name "*CL28?.REJ" -print -exec compress {} \;
find . -name "*CL30*" -print -exec compress {} \;
find . -name "*CL05*" -print -exec compress {} \;
find . -name "*CL06*" -print -exec compress {} \;
find . -name "*CL37*" -print -exec compress {} \;
find . -name "*CL97*" -print -exec compress {} \;
find . -name "*CLRMB*" -print -exec compress {} \;
find misc -name "???CL88O*" -print -exec compress {} \;
find . -name "*CL07*" -print  > ${PO_DIR}/pink1
find . -name "*CL20*" -print  >> ${PO_DIR}/pink1
find . -name "*CL28?.P1*" -print  >> ${PO_DIR}/pink1
find . -name "*CL28?.REJ*" -print  >> ${PO_DIR}/pink1
find . -name "*CL30*" -print  >> ${PO_DIR}/pink1
find . -name "*CL05*" -print  >> ${PO_DIR}/pink1
find . -name "*CL06*" -print  >> ${PO_DIR}/pink1
find . -name "*CL37*" -print  >> ${PO_DIR}/pink1
find . -name "*CL97*" -print  >> ${PO_DIR}/pink1
find . -name "*CLRMB*" -print  >> ${PO_DIR}/pink1
find misc -name "???CL88O*" -print  >> ${PO_DIR}/pink1
cat ${PO_DIR}/pink1 | cpio -ocvdB > ${PO_DIR}/pink2
cd ${RPTARCH}
cpio -icvdB < ${PO_DIR}/pink2
rm ${PO_DIR}/pink?

exit 0
