#!/bin/ksh
#
# Program Name	: copy_to_clientfiles.sh.sh
# Description	: Copy existing warehouse extract files to clientfiles/sqlimports
# Author	: Linda S. Jefferis
# Date		: 05/11/2010
# Modifications : TT13309-6
#
# Variables Used:
DATE=`date -d "yesterday 0800" +%Y%m%d`
OUT_DIR="/usr/lnk/wt/sqlimports/misc"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copy_to_clientfiles.sh.sh <file name> <local directory>

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
fi

FILE=$1
LOCAL_DIR=$2

if test -e ${LOCAL_DIR}/${FILE}
then
	cp ${LOCAL_DIR}/${FILE} /tmp
	mv /tmp/${FILE} /tmp/${FILE}-${DATE}
	gzip /tmp/${FILE}-${DATE}
	mv /tmp/${FILE}-${DATE}.gz ${OUT_DIR}
else
	echo "--*> The file ${LOCAL_DIR}/${FILE} does not exist."
fi

exit 0
