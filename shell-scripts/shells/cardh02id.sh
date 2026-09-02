#!/bin/sh
#
# Program Name  : cardh02id.sh
# Description   : Cardh02id Card Embossing Extract
#		  Command Line Arguments:
#		  -c <client code> (2-char)
#                 -m (Manual Process Called From Flexgen)
#		  -f <filename> - Alternate CARDHIDWRK name
#		  -r Rerun Flag
# Author        : Sean Romigh
# Date          : 12/15/06
# Modifications : 01/25/2007 - Had to add test for exisiting files before doing email.  Need to have programming investigate an alternative way to know if there are records in the CARDHIDWRK before going into the cardh02id procedure.
#		: 02/13/2007 - Changes in PRG run so emails are correctly only sent when new file is created. (Code was added to cardh29 program to not create empty CARDHIDWRK file if no ID card records).
#		: 08/20/2007 - Added logic for new -f option  (LSJ)
#		: 09/18/2007 - Removed Sherman from email as per email request from Joyce Potter  (LSJ)
#		: 03/28/2008 - Added "-r" for rerun to not do archive and email
#		: 05/19/2008 - Added Lori Kinsbury to email as per request from Joyce Potter @ URX  (LSJ)
#		: 05/18/2010 - Changed Kinsbury email to Walsh as per email request from Joyce Potter.
#		: 05/16/2016 - added Vickie Battle (battle@universalrx.com) to email notifications. (TT:14937-2; DME)
#		: 06/13/2019 - TT19608-6; email address updates
#		: 05/06/2024 - Removed "husk" archival dependancy
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
CARD_ARCH="/usr/lnk/cards"
#ARCH_SYS="husk"
DATE=`date +%m%d%Y%H%M%S`
MAIL_TO="benefits@universalrx.com,operations@pdmi.com"
MAIL_PROG="/usr//bin/mutt"
DEST_LOC="/usr/lnk/wt/urx-wt"
MANUAL=0
FILE_FLAG=0
RERUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh02id.sh [-c <2-char client code>] [-m] [-f <filename>]

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

# E-Mail Procedure
email_notification()
{
     if [ $RERUN = 0 ]
     then
	echo "An eligibility card file has been created at PDM" | ${MAIL_PROG} -s "URX CARD FILE NOTIFICATION" ${MAIL_TO}
     fi

}

# Archive process
archive()
{
     if [ $RERUN = 0 ]
     then
	mv ${CARDHIDWRK} ${CARD_ARCH}/CARDHIDWRK_${DATE}_${CLIENT}
 	if test $? -ne 0
   	then
      		echo "-*> Please see supervisor -- CARDHIDWRK did not get archived" | ${MAIL_PROG}
		exit 1
	fi
     fi
}


# Submit cardh02id program
submit_cardh02id()
{
        runcobol ${OBJ_DIR}/cardh02id  -s ${MANUAL}  

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
    -m) MANUAL=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	FILE=$1
	FILE_FLAG=1
	;;
    -r) RERUN=1
	;;        
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ $MANUAL = 1 ]
then
	CARDHIDWRK=$HOME/CARDHIDWRK
	submit_cardh02id
	rm -f $CARDHIDWRK
fi
if [ $MANUAL = 0 ]
then
	if [ $FILE_FLAG = 1 ]
	then
		CARDHIDWRK=$FILE
		export CARDHIDWRK
	fi
	if test -s $CARDHIDWRK
	then
		submit_cardh02id
		email_notification
		archive
	fi
fi
		 
exit 0
