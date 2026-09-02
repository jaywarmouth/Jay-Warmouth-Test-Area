#!/bin/ksh
#
# Program Name	: ohclapc048.sh
# Description	: Aultcare-MEDD Twice-daily report file
# Author	: Linda S. Jefferis
# Date		: 05/23/2014
# Modifications : 01/30/2015 - Removed the separate file assignments that are are already being set by the parse_env (LSJ)
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

usage: ohclapc048.sh 

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

echo "--> Starting - ohclapc048"
date

# Parse environment variables
parse_env

cd ${FLEX}

cdir=`pwd`
FG4PID=$$               ;export FG4PID
TERMINFO=$cdir/terminfo ;export TERMINFO
RUNPATH=$cdir/fg4bin:$cdir/obj    ;export RUNPATH
RMPATH=$cdir            ;export RMPATH
FM4MENUI=FG4DICTI       ;export FM4MENUI
FM4MENUR=FG4DICTR       ;export FM4MENUR
FM4ERROR=FG4ERROR       ;export FM4ERROR
GEWRK00MAS=/usr/upd/drug/GEMEDD713NPCMAS ;export GEWRK00MAS
FG4CSF=/usr/lnk/tmp/clapc048.csv ;export FG4CSF
FG4BATCH=Y              ;export FG4BATCH
./runfg4  OHCLAPC048 -k -a 'TIO=_./;;'
unset GEWRK00MAS

echo "--> Finished" 
date


exit 0
