#!/bin/sh

#
# Variables:
SHELL_DIR=/usr/lnk/shell
LOG_DIR=/usr/lnk/wt/oper-wt/accumeliglogs
FILE=null
SYS=null

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh29_zz.sh [file name] -f <file> -s <sys>
        where [file name] is:
        <clientID>e<mmdd>
        -f <file>: File parameter (required)
        -s <sys>: System parameter (required, 3-4 digits only)

ENDOFUSAGE
  exit 1
}

if [ $# -lt 1 ]
then
        usage
fi

file_name=$1
HOST_SYS=`hostname -s`

while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        ;;
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS=$1
        ;;
  esac
  shift
done

# Validation checks
# Check if FILE is null
if [ "$FILE" = "null" ] || [ -z "$FILE" ]
then
    usage
fi

# Check if SYS is null
if [ "$SYS" = "null" ] || [ -z "$SYS" ]
then
    usage
fi

# Check if SYS contains only digits
case $SYS in
    ''|*[!0-9]*) usage ;;
esac

# Check if SYS has more than 4 digits
if [ ${#SYS} -gt 4 ]
then
    usage
fi

# If SYS has less than 4 digits, pad with leading zeros
if [ ${#SYS} -lt 4 ]
then
    SYS=$(printf "%04d" $SYS)
fi

# Extract CLIENT (first 2 characters) and DATE (characters 4-7)
CLIENT=$(echo "$FILE" | cut -c1-2)
DATE=$(echo "$FILE" | cut -c4-7)

echo "FILE: $FILE"                                     >  ${LOG_DIR}/${HOST_SYS}_cardh29_zz_${FILE}.txt 2>&1
echo "SYS: $SYS"                                       >> ${LOG_DIR}/${HOST_SYS}_cardh29_zz_${FILE}.txt 2>&1
echo "CLIENT: $CLIENT"                                 >> ${LOG_DIR}/${HOST_SYS}_cardh29_zz_${FILE}.txt 2>&1
echo "DATE: $DATE"                                     >> ${LOG_DIR}/${HOST_SYS}_cardh29_zz_${FILE}.txt 2>&1
echo "Processing with file: $FILE and system: $SYS"    >> ${LOG_DIR}/${HOST_SYS}_cardh29_zz_${FILE}.txt 2>&1

nohup ${SHELL_DIR}/cardh29.sh -c ${CLIENT} -d ${DATE}  -s ${SYS}  > ${LOG_DIR}/${HOST_SYS}_cardh29_zz_${FILE}.txt 2>&1
