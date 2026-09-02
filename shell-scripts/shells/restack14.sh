#!/bin/sh
#
# Program Name	: restack14.sh 
# Description   : Cardholder Restack status change (unlock) 
#                 Command line arguments:
#		  -i <filename> - assign alternate input file
#		  -r	reset-mode flag
# Author	: Linda Jefferis
# Date		: 07/31/2014
# Modifications	: 09/29/2014 - add reset-mode flag logic (TT #11487-12)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILEDIR=/usr/lnk/tmp
FILE_FLAG=0
RESET_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack14.sh -i <filename> -r -t
	all are optional
	-i <filename> - assign specific RESTACK03-TOTALS file to read
	-r	- set RESET-MODE switch on to change status to "O" (open) for cardholders in RESTACK03-TOTALS file.
	

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

	
# Submit restack14 program
submit_restack14()
{
      runcobol ${OBJ_DIR}/restack14 -s 0${RESET_FLG}
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
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
    -r) RESET_FLG=1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

if [ $FILE_FLAG = 1 ]
then
	CARDTOT=$FILE
else
	cd $FILEDIR
	RESTACK03TOT=`ls -1 RESTACK03-TOTALS-*.csv`
	if test $? -eq 0
	then
		CARDTOT=$FILEDIR/$RESTACK03TOT
	else
		echo "The file, $FILEDIR/RESTACK03-TOTALS-*.csv, does not exist."
		exit 99
	fi
fi
export CARDTOT

if test -s $CARDTOT
then
	date
	echo "EXPORT PATHS:"
	echo "   FG4AUD=$FG4AUD"
	echo "   RESTK00MAS=$RESTK00MAS"
	echo "   CARDTOT=$CARDTOT"
	submit_restack14
	date
else
	echo "The CARDTOT ($CARDTOT) does not exist."
	exit 99
fi

exit 0
