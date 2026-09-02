#!/bin/sh
#

SHELL_DIR=/usr/lnk/shell
SYSNAME=`/usr/lnk/shell/get_hostname.sh`
DIR=/usr/lnk/wt/oper-wt/ClaimsCOB
cd ${DIR}
for file in `ls -1 month_claimscob_opcoveragetype_cc2020????.csv`
do
	YRMO=`echo $file | cut -c34-39`
	AUDFILE=/usr/files/misc/CLAIM02-claimupdt01-${YRMO}
	${SHELL_DIR}/claimupdt01.sh -i ${DIR}/${file} -o ${DIR}/Output/${SYSNAME}-errorfile-${YRMO} -a ${AUDFILE} >> /usr/lnk/rpt/claimupdt01 2>&1
done

exit 0
