#!/bin/sh
#
# Program Name	: restack03.sh 
# Description   : Identify MedD Claims that need to be restacked 
#                 Command line arguments:
#		    Events List:  ACCUM-REPORT, COB, ELIG, FIR, N1, PDE-REJECT,
#	 		REVERSAL, TROOP, MISC-EVENT-1, MISC-EVENT-2	

#                 Switches:
#                 -s Cardholder Select
#                    If only selected cardholders are to be processed for that event,
#                    then add the cardholder to the CARDSEL file. The RESTK00MAS must
#                    also be updated with the cardholder and the event flag.
#                 -t Test Mode - RESTK00MAS is not updated 

# Author	: Peggy Voytilla
# Date		: 07/24/2012
# Modifications : 02/19/2014 - Add email of TOTAL file when production run (TT #419-157)
#		: 06/10/2014 - added TEST in file names when run as test-mode. (TT #10899-2)
#		: 08/18/2014 - enhancements for Ticket #11487
#		: 10/27/2014 - Coding out the MAIL_TO variable and putting the email addresses behind the mail -c option. This does not pick up properly in JAMS. (DME)
#		: 03/12/2015 - Change invidual emails to restack@pdmi.com (DME)
#		: 05/18/2015 - update script to include email of test files. (TT:13731-1)(DME)
#		: 05/21/2015 - Correct test email being sent with production Run. (DME)
#		: 03/19/2018 - TT18341-1; CLLOC00MAS assignment
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RUN="/usr/rmcobol/terminfo-d0.cfg"
TEST_MODE=0
CARDH_SELECT=0
CARDSEL="null"
DATE=`date +%Y%m%d%H%M%S`
MAIL_PROG=/usr/bin/mutt
MAIL_TO="restack@pdmi.com"
MAIL_CC="operations@pdmi.com"
FILEDIR=/usr/lnk/tmp
RSTKDIR=/usr/lnk/restack

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack03.sh [-t] [-s <select cardholder>]

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

	
# Submit restack03 program
submit_restack03()
{
      runcobol ${OBJ_DIR}/restack03 -s ${TEST_MODE}${CARDH_SELECT}  
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) CARDH_SELECT=1
	CARDSEL=$FILEDIR/CARDSEL
	export CARDSEL
        ;;
    -t) TEST_MODE=1
        ;;

  esac
  shift
done


# Parse environment variables
parse_env

CLLOC00MAS=/usr/lnk/claims/CLLOC-RESTACK; export CLLOC00MAS
RESTACKIDX=$FILEDIR/RESTACKIDX ; export RESTACKIDX
RSTKPARM=${RSTKDIR}/restack.cfg; export RSTKPARM
if [ $TEST_MODE = 1 ]
then
	RESTACK=$FILEDIR/RESTACK03-TEST-${DATE}.txt
	CARDTOT=$FILEDIR/RESTACK03-TEST-TOTALS-${DATE}.csv
else
	RESTACK=$FILEDIR/RESTACK03-${DATE}.txt
	CARDTOT=$FILEDIR/RESTACK03-TOTALS-${DATE}.csv
fi
export RESTACK
export CARDTOT

if ! test -s ${RSTKPARM}
then
	echo "Config file, ${RSTKPARM} does not exist. Aborting process." | ${MAIL_PROG} -s "Restack03 - Error" ${MAIL_CC}
	exit 99
fi


date
echo "CLAIM RESTACK REVRSALS EXPORT PATHS:"
echo "   FG4AUD=$FG4AUD"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLLOC00MAS=$CLLOC00MAS"
echo "   RESTK00MAS=$RESTK00MAS"
echo "   RESTACKIDX=$RESTACKIDX"
echo "   RSTKPARM=$RSTKPARM"
echo "   RESTACK=$RESTACK"
echo "   CARDSEL=$CARDSEL"
echo "   CARDTOT=$CARDTOT"
submit_restack03
date

if [ $TEST_MODE = 0 ]
then
	echo "Attached is the RESTACK03-TOTALS file" | ${MAIL_PROG} -s "Restack03 Totals" -a ${CARDTOT} -c ${MAIL_CC} ${MAIL_TO}
	rm -f $RESTACKIDX

	exit 0

fi
	echo "Attached is the RESTACK03-TEST-TOTALS file" | ${MAIL_PROG} -s "Restack03 Test Totals" -a ${CARDTOT} -c ${MAIL_CC} ${MAIL_TO}
	rm -f $RESTACKIDX

	exit 0
