#!/bin/sh
#
# Program Name  : eft01.sh
# Description   : EFT0000TAP FILE LOAD
#		  Command Line Arguments:
#                 -f File Name - Assign alternate input filename
# Author        : James Masluk
# Date          : 03/01/10
# Modifications : 11/04/2014 - Import into JAMs. Modify and combine with coding from eft_update.sh (TT:4805-3)(DME) 
#		: 07/15/2015 - update MAIL_TO to benefits@pdmi.com and create MAIL_CC assigned as operations@pdmi.com (TT:4805-15)
#		: 09/16/2015 - replace benefits@pdmi.com with 835@pdmi.com in email notifcation. (TT:13310-41)(DME)
#		: 03/10/2016 - Change so email with attached PDF doesn't get created if no EFT file generated.  (LSJ)
#		: 03/10/2016 - add finance@pdmi.com for email notification.
#		: 06/28/2017 - Fix "-f" option logic.
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_FLAG=0
TEST_MODE=0
DATE=`date +%Y%m%d`
FILE_DIR="/usr/lnk/wt/EFT"
MISC_DIR="/usr/lnk/misc"
EFT0000TAP="${FILE_DIR}/EFT-${DATE}.txt"
EFT_RPT="${MISC_DIR}/EFT-RPT-${DATE}"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="835@pdmi.com"
MAIL_CC="operations@pdmi.com,finance@pdmi.com"
RPT_DIR="/usr/lnk/rpt"
RETVAL=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: eft01.sh  [-t] -f [file name] 

ENDOFUSAGE
  exit 99
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


# Submit eft01 program
submit_eft01()
{
    runcobol ${OBJ_DIR}/eft01 -s ${TEST_MODE}
	RETVAL=$?

}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
	if [ $# -le 0 ]
        then
           usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
    -t) TEST_MODE=1
	;;
  esac
  shift
done
	

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
	EFT0000TAP=$FILE
fi

export EFT0000TAP


echo "EFT0000TAP File Load"
echo ""
echo "FILE PATHS:"
echo "     EFT0000TAP=$EFT0000TAP"
echo "     EFT0000MAS=$EFT0000MAS"
echo "     EFT0000WRK=$EFT0000WRK"
echo ""
date
submit_eft01
date

if test -s $EFT_RPT
then
	enscript -rg -f Courier9 --non-printable-format=space -o - $EFT_RPT  | ps2pdf - $EFT_RPT.pdf
	echo "Attached is an EFT review report. Create new TT under Ticket #2351 with this report included." | ${MAIL_PROG} -a $EFT_RPT.pdf -s "EFT Review Report" -c ${MAIL_CC} ${MAIL_TO}
fi

echo "RETVAL = $RETVAL"
exit $RETVAL

