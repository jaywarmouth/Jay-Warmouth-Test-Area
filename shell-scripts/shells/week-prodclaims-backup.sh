#!/bin/sh
#
# Program Name	: week-prodclaims-backup.sh
# Description	: Runs clmcyc01.sh to extract week-cycle claims 
# Command input	: -b <batch range>
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
BATCHRNG="null"
INFILE="/usr/lnk/claims/CLAIM00MAS"
OUTFILE="/usr/lnk/tmp/CLAIM01BAK.week"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
HOSTSYS=`/usr/bin/hostname -s`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: week-prodclaims-backup.sh -b <batch range>

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Check command line validity
while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCHRNG=$1
        ;;
  esac
  shift
done

if [ ${HOSTSYS} != "prod10" ]
then
	echo "This process for normal week-cycle MUST be run on Production server (prod10)"
	exit 99
fi

if [ ${BATCHRNG} = "null" ]
then
   usage
else
   ${SHELL_DIR}/clmcyc01.sh -b ${BATCHRNG} -c W -o ${OUTFILE} > ${RPT_DIR}/week-clmcyc01 2>&1
   RETVAL=$?
fi

# Convert output files to PDF and email

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/week-clmcyc01 | ps2pdf - ${RPT_DIR}/week-clmcyc01.pdf

if [ $RETVAL = 0 ]
then
   echo "The week-cycle ${OUTFILE} file should now be created. Validate attached output report." | ${MAIL_PROG} -s "Week - clmcyc01" ${MAIL_TO} -a ${RPT_DIR}/week-clmcyc01.pdf 
else
   echo "The clmcyc01.sh process is indicating an error. See attached report." | ${MAIL_PROG} -s "Week - clmcyc01" ${MAIL_TO} -a ${RPT_DIR}/week-clmcyc01.pdf
fi

exit $RETVAL
