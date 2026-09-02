#!/bin/sh
#
# Program Name	: nsdeovrb01.sh
# Description   : Export NSDEOVRMAS file to Warehouse
#                
#          Command Line Arguments: 
#          -b <runtype>
#	   -o <alt NSDEOVRB001 filename>
#          Program uses no switches.  
#                 
# Author	: Dave Rudawsky
# Date		: 03/31/2015
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RUNTYPE=0
FILEFLG=0
FILEDIR=/usr/lnk/sqlimports/misc

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nsdeovrb01.sh -b <runtype> -o <alt extract filename>

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


# Submit nsdeovrb01 program
submit_nsdeovrb01()
{
     runcobol ${OBJ_DIR}/nsdeovrb01 -a ${RUNTYPE} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RUNTYPE=$1
        ;;
    -o) shift
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

if [ $RUNTYPE = 0 ]
then
	usage
	exit 1
fi

# Assign alternate environment variables
if [ $FILEFLG = 1 ]
then
	NSDEOVRB001=$FILE
else
	NSDEOVRB001=${FILEDIR}/NSDEOVRB001
fi
export NSDEOVRB001

DATECARD=/usr/lnk/log/DATECARD.txt
  export DATECARD
  

echo "NSDEOVRMAS extract for Warehouse"
date
echo "NSDEOVRMAS=${NSDEOVRMAS}"
echo "NSDEOVRB001=${NSDEOVRB001}"
submit_nsdeovrb01 
date

exit 0
