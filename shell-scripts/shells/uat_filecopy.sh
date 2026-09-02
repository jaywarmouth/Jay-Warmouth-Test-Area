#!/bin/sh
#
# File copy from production server to UAT Test server
# Version 1.0

PRODSYS="prod10"
LOCALSYS=`/usr/lnk/shell/get_hostname.sh`
GRPDIR="/usr/lnk/grp"
FAIL=0

# evaluate copies
eval_retval()
{
if [ ${retval} -ne 0 ]
then
	FAIL=1
fi
}

scp ${PRODSYS}:${GRPDIR}/SYSTE00MAS ${GRPDIR}
retval="$?"
eval_retval
scp ${PRODSYS}:${GRPDIR}/SPONS00MAS ${GRPDIR}
retval="$?"
eval_retval
scp ${PRODSYS}:${GRPDIR}/GROUP00MAS ${GRPDIR}
retval="$?"
eval_retval
scp ${PRODSYS}:${GRPDIR}/PLAN000MAS ${GRPDIR}
retval="$?"
eval_retval

if [ ${FAIL} = 1 ]
then
	exit 1
else
	exit 0
fi

