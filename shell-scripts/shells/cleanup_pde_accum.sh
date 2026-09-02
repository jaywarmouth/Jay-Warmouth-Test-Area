#!/bin/sh
#
#
# Shell for archiving and cleaning up files from PDECL06 process
# Version 1.0

usage()
{
        echo "USAGE:"
        echo "cleanup_pde_accum.sh <year>
	exit 1
}

IN_DIR="/usr/lnk/pde/in"
FILE_DIR=/usr/lnk/misc
RPT_DIR=/usr/lnk/rpt
ARCH_DIR=/usr/lnk/pde/arch
WT_DIR_1=/usr/lnk/wt/ault-10
WT_DIR_2=/usr/lnk/wt/ault-24
WT_DIR_3=/usr/lnk/wt/ault-32
WT_DIR_4=/usr/lnk/wt/ault-105
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="rschrock@aultcare.com cscarpino2@aultman.com kgoff@aultman.com kdouglass@aultcare.com"
MAIL_CC="pvoytilla@pdmi.com wkohuth@pdmi.com operations@pdmi.com"

if [ $# -lt 1 ]
then
	usage
	exit 1
fi

YEAR=$1
	
if [ "$HOSTNAME" != "prod10" ]
then
	echo "-*> This script must be run on PROD10..."
	exit 1
fi

scp ${FILE_DIR}/PDECL06-* robin:/usr/lnk/wrk/pde
mv ${IN_DIR}/RPT.DDPS_P2P_PDE_ACUM_PDP.* ${ARCH_DIR}/${YEAR}
cp ${FILE_DIR}/PDECL06-* ${WT_DIR_1}
cp ${FILE_DIR}/PDECL06-* ${WT_DIR_2}
cp ${FILE_DIR}/PDECL06-* ${WT_DIR_3}
cp ${FILE_DIR}/PDECL06-* ${WT_DIR_4}
mv ${FILE_DIR}/PDECL06-* ${ARCH_DIR}/${YEAR}

echo "The reformatted PDE Accumulator files are uploaded to your web transfer areas. | ${MAIL_PROG} -s "Return PDE Accum Files" -c ${MAIL_CC} ${MAIL_TO}

exit 0
