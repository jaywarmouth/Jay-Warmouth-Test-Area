#!/bin/sh
#
# Program Name	: drug072.sh  
# Description   : Create new type code drug records from input file of NDCs.    
#                 Command line arguments:
#		  -c <4digit typecode>
#		  -i <alternate DRUG072TAP file> - default is /usr/lnk/tmp/DRUG072TAP.txt
#		  -f <alternate DRUG000MAS file to update>
#                 Switches:
#		  -t Test mode (no file updates)
# Author	: Dave Rudawsky
# Date		: 06/25/2015
# Modifications : 06/29/2015 - Changes for production version (LSJ) 
#		  10/21/2015 - Add logic for type code input (TT:14502-7)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TEST_MODE=0
INFLAG=0
OUTFLAG=0
TCODE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug072.dr [-c <typecode>] [-t] [-i <DRUG072TAP file>] [-f <DRUG000MAS file>]

	-c <4digit typecode> is required
	all other arguments are optional
	

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

# Submit drug072 program
submit_drug072()
{
     runcobol ${OBJ_DIR}/drug072 -a ${TCODE} -s ${TEST_MODE}

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
    -c) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	TCODE=$1
	;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	INFLAG=1
	IN_FILE=$1
	;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	OUTFLAG=1
	OUT_FILE=$1
	;;
  esac
  shift
done

if [ ${TCODE} = "null" ]
then
	usage
fi

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $INFLAG = 1 ]
then
	DRUG072TAP=${IN_FILE}
	export DRUG072TAP
else
	DRUG072TAP=/usr/lnk/tmp/DRUG072TAP.txt
	export DRUG072TAP
fi
if [ $OUTFLAG = 1 ]
then
	DRUG000MAS=${OUT_FILE}
	export DRUG000MAS
fi


echo "RUNNING DRUG072 TO CREATE TYPE CODE DRUG RECORDS"
date
echo "EXPORT PATHS:"
echo "   DRUG072TAP=$DRUG072TAP"
echo "   DRUG000MAS=$DRUG000MAS"
echo "   Type Code: ${TCODE}"

submit_drug072

date

exit 0
