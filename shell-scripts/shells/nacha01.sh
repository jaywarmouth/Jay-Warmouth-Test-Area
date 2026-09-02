#!/bin/sh
#
# Program Name  : nacha01.sh
# Description   : NACHA FILE CREATION
#		  Command Line Arguments:
#		  -f <filename> - Assign alternate input CHKWRK file
#			Default is set as /usr/upd/claims/CHKWRK-C
#		  -o <filename> - Assign output NACHA01TAP file name
#			Default is /usr/lnk/wt/EFT/NACHA-${DATE}
#			where ${DATE} is current date ccyymmdd
#		  -d <ccyymmdd> - Assign alternate settlement date
#			Default is 2 days from current date
#		  -i <file ID> - 1 character; default is A
#			Assign different <file ID> id running another file with same settlement and run date.
#                 -t Test Mode 
# Author        : James Masluk
# Date          : 03/16/10
# Modifications : 06/04/2010 - Made several updates and added email_report
#		: 11/11/2019 - Change "a2ps" to "enscript"
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TEST_MODE=0
S_DATE="00000000"
FILE_DIR="/usr/lnk/wt/EFT"
TAPE_DIR="/usr/lnk/tapes"
FILE_ID=" "
CHK_FILE_FLAG=0
NACH_FILE_FLAG=0
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
MISC_DIR="/usr/lnk/misc"
DATE=`date +%Y%m%d`
NACHA_RPT=$MISC_DIR/NACHA01-$DATE

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nacha01.sh -t -d <mmddccyy> -i <id> -f <filename> -o <filename>
	-t		Test Flag	(optional)
	-s <mmddccyy>	Alternate settlement date	(optional)
	-i <id>		Assign new file ID for second or more file
			with same settlement and run date (optional)
	-f <filename>	Assign alternate input CHKWRK filename  (optional)
			Default is CHKWRK-C
	-o <filename>	Assign output NACHA01TAP file	(optional)
			Default is /usr/lnk/wt/EFT/NACHA-<ccyymmdd>
			where <ccyymmdd> is Tuesday check date

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file...                                                 "

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
        IFS=${EQUAL}
        set $VAR
        NVAR=$1
        export ${NVAR}
        if [ $? -ne 0 ]
        then
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit nacha01 program
submit_nacha01()
{
    runcobol ${OBJ_DIR}/nacha01 -s ${TEST_MODE} -a ${S_DATE}${FILE_ID}

}

# Email report
email_report()
{
	enscript -rBgj -f Courier9 --newline=r --non-printable-format=space -o - ${NACHA_RPT} | ps2pdf - ${NACHA_RPT}.pdf
	echo -e "EFT-NACHA file:\n\n${NACHA01TAP}" | ${MAIL_PROG} -s "EFT Report and File Notification" ${MAIL_TO} -a ${NACHA_RPT}.pdf
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        S_DATE=$1
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_ID=$1
        ;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	CHK_FILE_FLAG=1
        IN_FILE=$1
        ;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	NACH_FILE_FLAG=1
        OUT_FILE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${CHK_FILE_FLAG} = 1 ]
then
	CHECK00MAS=${IN_FILE}
else
	CHECK00MAS=/usr/upd/claims/CHKWRK-C
fi
export CHECK00MAS

if [ ${NACH_FILE_FLAG} = 1 ]
then
	NACHA01TAP=${OUT_FILE}
else
	NACHA01TAP=${FILE_DIR}/NACHA-${DATE}
fi
export NACHA01TAP

# Make copy of EFT0000WRK file
echo "Make backup copy of EFT0000WRK"
echo ""
cp ${EFT0000WRK} /usr/lnk/tmp/EFT0000WRK-${DATE}


echo "NACHA File Creation"
date
echo ""
echo "FILE ASSIGNMENTS:"
echo "     CHECK00MAS=$CHECK00MAS"
echo "     NACHA01TAP=$NACHA01TAP"
echo ""
submit_nacha01

email_report

date

exit 0
