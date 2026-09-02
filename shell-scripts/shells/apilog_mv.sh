#!/bin/sh
#
# Process Name	: apilog_mv.sh
#
# Variables Used:
LOG_DIR="/usr/lnk/debug"
ARCH_DIR="/usr/lnk/apilog"
FILE_DATE=`date -d "yesterday 0800" +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: apilog_mv.sh [-r <yyyymmdd>]
	where -r is optional for file date other than previous day's date.

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_DATE=$1
        ;;
  esac
  shift
done


date

echo ""
echo "--> Moving files"
echo "   FILE_DATE=${FILE_DATE}"

mv ${LOG_DIR}/DEBUG-*-${FILE_DATE}.LOG ${ARCH_DIR}
mv ${LOG_DIR}/TEST-*-${FILE_DATE}.LOG ${ARCH_DIR}
find ${ARCH_DIR} -follow -type f -mtime +30 -exec rm -f {} \;

date

exit 0
