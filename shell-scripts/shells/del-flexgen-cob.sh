#!/bin/ksh
#
# Variables Used:
FLEX_DIR="/usr/lnk/flexgen"
COB_SUFFIX=".COB"
INPUT_FILE="/usr/lnk/flexgen/lsj-only-cob"
CR="
"
HOST_SYS=`/usr/ucb/hostname`

date
echo "Host System = ${HOST_SYS}"
IFS=${OLDIFS}
IFS=${CR}
cd ${FLEX_DIR}
for FILE in `cat ${INPUT_FILE}`
do
    rm ${FILE}${COB_SUFFIX}
    STATUS="$?"
    if [ "$STATUS" -ne "0" ]
    then
	echo ""
	echo "ERROR: Unable to remove ${FLEX_DIR}/${FILE}${COB_SUFFIX}"
    else
    	echo "Removed ${FILE}${COB_SUFFIX}"
    fi
done
IFS=${OLDIFS}
date

exit 0
