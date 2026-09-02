#!/bin/ksh
#
# Program Name	: ohclapc046.sh
# Description	: Aultcare-MEDD Twice-daily report file
# Author	: Linda S. Jefferis
# Date		: 05/23/2014
# Modifications : 09/15/2014 - TT #10923-58
#		: 01/30/2015 - Removed the separate file assignments that are are already being set by the parse_env (LSJ)
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

usage: ohclapc046.sh 

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

echo "--> Starting - ohclapc046 (last changed 9/15/2014)"
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
DOSAGFORM=/usr/lnk/drug/DOSAGEFORMMAS; export DOSAGFORM
FG4CSF=/usr/lnk/tmp/clapc046.csv ;export FG4CSF
FG4BATCH=Y              ;export FG4BATCH
./runfg4  OHCLAPC046 -k -a 'TIO=_./;;'

echo "--> Finished" 
date


exit 0
