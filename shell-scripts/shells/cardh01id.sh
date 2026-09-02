#!/bin/ksh
#
# Program Name  : cardh01id.sh
# Description   : Cardh01id Card Embossing Extract
#		  Command Line Arguments:
#		  -c <client code> (2-char)
# Author        : James Masluk
# Date          : 12/20/01
# Modifications : 02/12/2002 - Add logic for archiving the CARDHIDWRK (LSJ)
#		: 02/14/2002 - Added logic for the "-c" command line argument  (LSJ)
#		: 02/21/2002 - Added rm of CARDHIDWRK after archive  (LSJ)
#		: 03/15/2002 - Email notification created  (LSJ)
#		: 04/04/2002 - Added zip procedure  (LSJ)
#		: 06/26/2002 - Changed the zip and email section to test for existence of the *PRG.txt file first  (LSJ)
#		: 09/11/2002 - Added logic for .des file  (LSJ)
#		: 05/16/2005 - Addition of "umask 002" command  (LSJ)
#		: 10/20/2005 - Changes for linux commands  (LSJ)
#		: 12/03/2005 - Changes for new system names  (LSJ)
#		: 01/10/2006 - Fixed logic for testing for *PGR.txt files  (LSJ)
#		: 04/24/2006 - Changed MAIL_TO  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
ERROR_RPT="/usr/lnk/misc/EMBOSS-ERR-??"
CARD_ARCH="/usr/lnk/cards/pla"
ARCH_SYS="husk"
DATE=`date +%m%d%Y%H%M%S`
#MAIL_TO=ljefferis@pdmi.com
MAIL_TO="potter@universalrx.com sherman@universalrx.com computers@pdmi.com"
MAIL_PROG="/bin/mail"
ZIP_FILE="PRG.zip"
DES_FILE="PRG.zip.des"
DEST_LOC="/usr/lnk/wt/urx-wt"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh01id.sh [-c <2-char client code>]

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

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


# Submit cardh01id program
submit_cardh01id()
{
        runcobol ${OBJ_DIR}/cardh01id  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	CLIENT=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

rm -f ${ERROR_RPT}

echo "Creating CARDH01ID"
echo "CARDHIDWRK=${CARDHIDWRK}"
date
submit_cardh01id
date

if test -s ${ERROR_RPT}
then
   echo ""
   echo "***************************************"
   echo "--> An Emboss Error Report will print"
   echo "--> Please give to Benefits"
   echo "***************************************"
   lp ${ERROR_RPT}
fi

# Archive CARDHIDWRK
if test -s ${CARDHIDWRK}
then
   scp ${CARDHIDWRK} ${ARCH_SYS}:${CARD_ARCH}/CARDHIDWRK_${DATE}_${CLIENT}
   if test $? -ne 0
   then
      echo "-*> Please see supervisor -- CARDHIDWRK did not get archived"
   else
      rm -f ${CARDHIDWRK}
   fi
fi

# Zip files
ls ${DEST_LOC}/*PRG.txt > /tmp/cardh01id-lst
if test $? -eq 0
then
	${ZIP_PROG} -jm ${DEST_LOC}/${ZIP_FILE} ${DEST_LOC}/*PRG.txt
	echo "I.D. Card file from eligibility file update" > ${DEST_LOC}/${DES_FILE}
	# Email notification
	echo "An eligibility card file has been created at PDM" | ${MAIL_PROG} -s "CARD FILE NOTIFICATION" ${MAIL_TO}
fi

exit 0
