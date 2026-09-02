#!/bin/sh
#
# File copy from production server to RTE Test server
# Version 1.1

PRODSYS="prod10"
LOCALSYS=`/usr/lnk/shell/get_hostname.sh`
GRPDIR="/usr/lnk/grp"
DRGDIR="/usr/lnk/drug"
ELIGDIR="/usr/lnk/elig_in"
CRDDIR="/usr/lnk/card"
FAIL=0

# evaluate copies
eval_retval()
{
if [ ${retval} -ne 0 ]
then
	echo "Copy for ${FILE} - failed"
	FAIL=1
else
	echo "Copy for ${FILE} - successful"
fi
}

scp ${PRODSYS}:${ELIGDIR}/elig.cfg ${ELIGDIR}
retval="$?"
FILE=elig.cfg
eval_retval
scp ${PRODSYS}:${ELIGDIR}/accum01.cfg ${ELIGDIR}
retval="$?"
FILE=accum01.cfg
eval_retval

scp ${PRODSYS}:${GRPDIR}/SYSTE00MAS ${GRPDIR}
retval="$?"
FILE=SYSTE00MAS
eval_retval
scp ${PRODSYS}:${GRPDIR}/SPONS00MAS ${GRPDIR}
retval="$?"
FILE=SPONS00MAS
eval_retval
scp ${PRODSYS}:${GRPDIR}/GROUP00MAS ${GRPDIR}
retval="$?"
FILE=GROUP00MAS
eval_retval
scp ${PRODSYS}:${GRPDIR}/PLAN000MAS ${GRPDIR}
retval="$?"
FILE=PLAN000MAS
eval_retval
scp ${PRODSYS}:${GRPDIR}/BRBEN00MAS ${GRPDIR}
retval="$?"
FILE=BRBEN00MAS
eval_retval
scp ${PRODSYS}:${GRPDIR}/BRCFG00MAS ${GRPDIR}
retval="$?"
FILE=BRCFG00MAS
eval_retval

scp ${PRODSYS}:${DRGDIR}/GENTB00MAS ${DRGDIR}
retval="$?"
FILE=GENTB00MAS
eval_retval

scp ${PRODSYS}:${CRDDIR}/CARANGEMAS ${CRDDIR}
retval="$?"
FILE=CARANGEMAS
eval_retval

if [ ${FAIL} = 1 ]
then
	echo "RETVAL=99"
	exit 1
else
	echo "RETVAL=0"
	exit 0
fi

