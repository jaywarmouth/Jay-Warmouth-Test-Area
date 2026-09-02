#!/bin/ksh
#
# Program Name	: cardh29wc.sh
# Description   : Workers Comp Eligibility 
#                 Command line arguments:
#                   -c Client Abbrev. (2 characters)
#                   -d date of file (mmdd or mmdd.###)
#		    -f <directory/filename> Assign alternate CARDH29TAP
#			default is $CARDH29_DIR/$CLIENTe$DATE
#		    -t Test mode flag
# Author	: Linda S. Jefferis
# Date		: 03/21/2008
# Modifications : 
#		 
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
ELIG_DIR="/usr/lnk/elig_in"
FG4AUD_DIR="/usr/lnk/audit"
AUDNAME="CRDAUD"
CARDH29_DIR="/usr/lnk/elig_in"
DATE="null"
CLIENT="null"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh29wc.sh -c <client abbrev.> -d <mmdd> -f <filename> 
	-c <2-character client abbreviation>	required
	-d <mmdd>				required
	-f <alt. CARDH29TAP dir and filename>	optional
		Default name is $CARDH29_DIR/$CLIENTe$DATE

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Submit cardh29 program
submit_cardh29wc()
{
     runcobol ${OBJ_DIR}/cardh29wc -s ${TEST_MODE} -a ${CLIENT}e${DATE}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 4 ]
then
	usage
	exit 0
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
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
    -f) shift
	if [ $# -le 0 ]
	then
	  usage
	fi
	FILE_FLG=1
	FILE=$1
	;;
    -t) TEST_MODE=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

umask 002

# Set Internal Variables
FG4AUD=${FG4AUD_DIR}/${AUDNAME};export FG4AUD
if [ $FILE_FLG = 1 ]
then
	CARDH29TAP=$FILE
	export CARDH29TAP
else
	CARDH29TAP=${CARDH29_DIR}/${CLIENT}e${DATE}
	export CARDH29TAP
fi


# Submit Cardh29
submit_cardh29wc 


exit 0
