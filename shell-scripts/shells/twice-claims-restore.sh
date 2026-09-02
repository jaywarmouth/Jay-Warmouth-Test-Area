#!/bin/sh
#
# Program Name	: twice-claims-restore.sh
# Description	: Runs clmcyc02.sh to update twice-cycle claims on backup/test server(s)
# Command input	: -b <batch range>
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
BATCHRNG="null"
OUTFILE="/usr/lnk/claims/CLAIM00MAS"
INFILE="/usr/lnk/tmp/CLAIM01BAK.twice"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
HOSTSYS=`/usr/bin/hostname -s`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice-claims-restore.sh -b <batch range>

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

if [ ${HOSTSYS} = "prod10" ]
then
	echo "This process for normal twice-cycle MUST NOT be run on Production server (prod10). It should be run on bacup/test server"
	exit 99
fi

if [ ${BATCHRNG} = "null" ]
then
   usage
else
   ${SHELL_DIR}/clmcyc02.sh -b ${BATCHRNG} -c T -i ${INFILE} > ${RPT_DIR}/twice-clmcyc02 2>&1
   RETVAL=$?
fi

# Convert output files to PDF and email

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/twice-clmcyc02 | ps2pdf - ${RPT_DIR}/twice-clmcyc02.pdf

if [ $RETVAL = 0 ]
then
   echo "The twice-cycle ${OUTFILE} file should now be updated to CLAIM00MAS. Validate attached output report." | ${MAIL_PROG} -s "twice - ${HOSTSYS} clmcyc02" ${MAIL_TO} -a ${RPT_DIR}/twice-clmcyc02.pdf 
else
   echo "The clmcyc02.sh process is reporting an error. See attached report." | ${MAIL_PROG} -s "twice - ${HOSTSYS} clmcyc02" ${MAIL_TO} -a ${RPT_DIR}/twice-clmcyc02.pdf
fi

exit $RETVAL
