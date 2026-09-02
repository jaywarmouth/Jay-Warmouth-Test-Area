#!/bin/ksh
#
# Program Name	: ohpddpc001.sh
# Description	: Create PDEDSRB001 file for imported to warehouses
#		  -f <file> - assign alternate PDEDSRB001 name
# Author	: Linda S. Jefferis
# Date		: 02/16/2012
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_FLAG=0
FLEX="/usr/lnk/flexgen"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ohpddpc001.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   PDEDSRB001=${FILE}
   export PDEDSRB001
fi

echo "PDEDS00MAS=$PDEDS00MAS"
echo "PDEDSRB001=$PDEDSRB001"

date
echo "--> Starting - ohpddpc001"

cd ${FLEX}

cdir=`pwd`
FG4PID=$$               ;export FG4PID
TERMINFO=$cdir/terminfo ;export TERMINFO
RUNPATH=$cdir/fg4bin:$cdir/obj    ;export RUNPATH
RMPATH=$cdir            ;export RMPATH
FM4MENUI=FG4DICTI       ;export FM4MENUI
FM4MENUR=FG4DICTR       ;export FM4MENUR
FM4ERROR=FG4ERROR       ;export FM4ERROR
PDEDS00MAS=$PDEDS00MAS	;export PDEDS00MAS
FG4CSF=$PDEDSRB001	;export FG4CSF
unset FG4BATCH
./runfg4  OHPDDPC001 -k -a 'TIO=_./;;'
unset PDEDS00MAS
unset FG4CSF


echo "--> Finished" 


exit 0
