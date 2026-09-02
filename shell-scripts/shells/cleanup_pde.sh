#!/bin/sh
#
#
# Shell for archiving and cleaning up files from PDE2011 process
# Version 1.0
# Modifications : 06/20/2014 - replace ault-32 with medd-wt for web transfer. (DME)
#		: 11/24/2014 - add archiving for  PDECL2011-ERRORS-ymddR.csv and PDECL2011-ERRORS-ymddS.csv. (TT:8252-103)(DME)
#		: 11/24/2014 - replace wkohuth@pdmi.com with  drudawsky@pdmi.com (DME) (TT:8252-103)
#		: 01/14/2015 - add coding to look for the rchive directory and make the directory if it doesn't exists. (DME)
#		: 02/11/2015 - corrected coding for Arch directory and error reports. (DME)
#		: 11/19/2015 - remove ault-24 from File upload. (TT:14622-1 DME)
#		: 11/20/2018 - replace pvoytilla and drudawsky emails with  transteam@pdmi.com(TT:16553-110; DME)
#
#

ERR_DIR=/usr/lnk/misc
RPT_DIR=/usr/lnk/rpt
TAPE_DIR=/usr/lnk/tapes/pde
WT_DIR_1=/usr/lnk/wt/ault-10
WT_DIR_3=/usr/lnk/wt/medd-wt
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="pvoytilla@pdmi.com"
MAIL_CC="operations@pdmi.com"
RESUB="null"

#
#Usage Rountine
usage()
{
        echo "USAGE:"
        echo "pde_cleanup.sh <ccyymmdd> <prefix>"
        echo "pde_cleanup.sh -r <ccyymmdd> <prefix>"
	echo "   where <prefix> is batch prefix for process"
	echo "      e.g. LK07"
	echo "-r        - resubmission"
	exit 1
}

if [ $# -lt 2 ]
then
	usage
	exit 1
fi

if [ "$1" = "-r"  ]
then
	RESUB=1
	DATE=$2
	PREFIX=$3
else
	RESUB=0
	DATE=$1
	PREFIX=$2
fi

YEAR=`echo $DATE | cut -c1-4`
ARCH_DIR=/usr/wrk/pde/${YEAR}

if [ $RESUB = "null" ]
then
	usage
fi

#check Hostname
if [ "$HOSTNAME" != "prod10" ]
then
	echo "-*> This script must be run on PROD10..."
	exit 1
fi

#Check for Archive directory
if ! test -d ${ARCH_DIR}
then
	mkdir -m 770 ${ARCH_DIR}
fi

mv /usr/upd/claims/PDECL00WRK-${DATE}-?????? ${ARCH_DIR}
file_list=/usr/lnk/wrk/pde-tape-list
ls -1 ${TAPE_DIR} > $file_list
for file in `cat $file_list`
do
	if test -s ${TAPE_DIR}/$file
	then
		scp ${TAPE_DIR}/$file robin:/usr/lnk/shares/ftp-tmp
		cp ${TAPE_DIR}/$file ${WT_DIR_1}
		cp ${TAPE_DIR}/$file ${WT_DIR_3}
		mv ${TAPE_DIR}/$file ${ARCH_DIR}/$file-${DATE}
	fi
done

if [ $RESUB = 1 ]
then
	if test -s ${ERR_DIR}/PDECL2011-ERRORS-${PREFIX}R
	then
		mv ${ERR_DIR}/PDECL2011-ERRORS-${PREFIX}R ${ARCH_DIR}
	fi

	if test -s ${ERR_DIR}/PDECL2011-ERRORS-${PREFIX}R.csv
        then
                mv ${ERR_DIR}/PDECL2011-ERRORS-${PREFIX}R.csv ${ARCH_DIR}
        fi
	
	echo "pdecl2011 resubmission process is completed." | ${MAIL_PROG} -s "PDECL2011 Resubmission" -c ${MAIL_CC} ${MAIL_TO} -a ${RPT_DIR}/pdecl2011-R-${DATE}??????.pdf
	mv ${RPT_DIR}/pdecl2011-R-${DATE}?????? ${ARCH_DIR}
	mv ${RPT_DIR}/pdecl2011-R-${DATE}??????.pdf ${ARCH_DIR}
else
	if test -s ${ERR_DIR}/PDECL2011-ERRORS-${PREFIX}
	then
		mv ${ERR_DIR}/PDECL2011-ERRORS-${PREFIX} ${ARCH_DIR}
	fi
        
	if test -s ${ERR_DIR}/PDECL2011-ERRORS-${PREFIX}S.csv
        then
                mv ${ERR_DIR}/PDECL2011-ERRORS-${PREFIX}S.csv ${ARCH_DIR}
        fi
	
	echo "pdecl2011 process is completed." | ${MAIL_PROG} -s "PDECL2011" -c ${MAIL_CC} ${MAIL_TO} -a ${RPT_DIR}/pdecl2011-${DATE}??????.pdf
	mv ${RPT_DIR}/pdecl2011-${DATE}?????? ${ARCH_DIR}
	mv ${RPT_DIR}/pdecl2011-${DATE}??????.pdf ${ARCH_DIR}
fi

exit 0
