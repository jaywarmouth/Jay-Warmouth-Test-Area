#!/bin/ksh
#
# Program Name	: ohclaup010.sh
# Description	: Off-hours Flexgen initialization procedure
#		  Command Line arguments:
#		  -f <claims file name>
# Author	: Linda S. Jefferis
# Date		: 09/15/2010
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FLEX="/usr/lnk/flexgen"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ohclaup010.sh 

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
        FILE=$1
        ;;
  esac
  shift
done


# Parse environment variables
#parse_env

date
echo "--> Starting - ohclaup010"

cd ${FLEX}

cdir=`pwd`
FG4PID=$$               ;export FG4PID
TERMINFO=$cdir/terminfo ;export TERMINFO
RUNPATH=$cdir/fg4bin:$cdir/obj    ;export RUNPATH
RMPATH=$cdir            ;export RMPATH
FM4MENUI=FG4DICTI       ;export FM4MENUI
FM4MENUR=FG4DICTR       ;export FM4MENUR
FM4ERROR=FG4ERROR       ;export FM4ERROR
CLAIM00MAS=$FILE ;export CLAIM00MAS
echo "CLAIM00MAS=$CLAIM00MAS"
FG4BATCH=Y
runfg4  OHCLAUP010 -k -a 'TIO=_./;;'
unset CLAIM00MAS

date
echo "--> Finished" 


exit 0
