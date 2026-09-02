#!/bin/ksh
#
# Program Name	: drug017.sh
# Description   : Drug Update from 1 type code to another for pricing.
#		  Command Line Arguments:
#		  -i <alternate PARMFILE> - this is optional, the default file is /usr/lnk/log/PARMFILE-DRUG017.csv
# Date		: 12/16/96
# Modifications : 08/26/97 (LSJ) Added env_var & OBJ_DIR logic
#		: 08/22/2006 - Added HOSTNAME logic  (LSJ)
#		: 03/29/2016 - TT3454-34
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
FILEFLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug017.sh -i <alternate PARMFILE>

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

# Submit drug017 program
submit_drug017()
{
        runcobol ${OBJ_DIR}/drug017 
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
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	FILEFLG=1
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

if [ $FILEFLG = 1 ]
then
	PARMFILE=$FILE
else
	PARMFILE=/usr/lnk/log/PARMFILE-DRUG017.csv
fi
export PARMFILE

XRFDRUG000MAS=$DRUG000MAS; export XRFDRUG000MAS
NEWDRUG000MAS=$DRUG000MAS; export NEWDRUG000MAS

echo "Drug Update for Medispan Pricing for other Type Codes"
echo "HOSTNAME=$HOSTNAME"
echo "ASSIGNED FILES:"
echo "   PARMFILE=$PARMFILE"

date
submit_drug017   
date

exit 0
