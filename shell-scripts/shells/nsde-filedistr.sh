#!/bin/sh
#
# Program Name	: nsde-filedistr.sh
# Description	: Distribute NSDE process error files
#		  Command Line options:
#		  -d <ccyymmdd> - alternate file date; default is current date.
# Author	: Linda S. Jefferis
# Date		: 11/03/2014
# Modifications : 11/24/2014 - add pvoytilla@pdmi.com to email list. (DME) 
#		: 04/28/2015 - TT:12829-32; nsde003 files
#		: 08/05/2015 - Ticket #10021 - Aultcare implementation/migration
#		: 08/11/2015 - Replace individual emails with NSDE@pdmi.com. TT:13835-2 (DME)
#
#
# Variables Used:
RPT_DIR="/usr/lnk/misc"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
DATE=`date +%Y%m%d`
WT_DIR=/usr/lnk/wt/medd-wt


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nsde-filedistr.sh -d <ccyymmdd>
	<ccyymmdd> - alternate file date; default is current date.

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done

NSDE003CSV=${RPT_DIR}/NSDE003RPT-${DATE}.csv
export NSDE003CSV

# Distribute error reports
cp ${NSDE003CSV} ${WT_DIR}

echo "NSDE File is attached" | ${MAIL_PROG} -a ${NSDE003CSV} -s "NSDE Update Log" NSDE@pdmi.com operations@pdmi.com

exit 0
