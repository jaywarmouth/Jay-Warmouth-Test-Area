#!/bin/ksh
#
# Program Name	: ohpenpc001.sh
# Description	: Create extract file for warehouse for PERMISSION file
#		  -f <file> - assign alternate PERMI00SEQ name
# Author	: Linda S. Jefferis
# Date		: 09/19/2014
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

usage: ohpenpc001.sh 

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
   PERMI00SEQ=${FILE}
   export PERMI00SEQ
fi

echo "PERMI00MAS=$PERMI00MAS"
echo "PERMI00SEQ=$PERMI00SEQ"

echo "--> Starting - ohpenpc001"
date

cd ${FLEX}

cdir=`pwd`
FG4PID=$$               ;export FG4PID
TERMINFO=$cdir/terminfo ;export TERMINFO
RUNPATH=$cdir/fg4bin:$cdir/obj    ;export RUNPATH
RMPATH=$cdir            ;export RMPATH
FM4MENUI=FG4DICTI       ;export FM4MENUI
FM4MENUR=FG4DICTR       ;export FM4MENUR
FM4ERROR=FG4ERROR       ;export FM4ERROR
PERMI00MAS=$PERMI00MAS ;export PERMI00MAS
PERMI00SEQ=$PERMI00SEQ ;export PERMI00SEQ
./runfg4 OHPENPC001 -k -a 'TIO=_./;;'
unset PERMI00MAS
unset PERMI00SEQ

echo "--> Finished" 
date


exit 0
