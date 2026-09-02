#!/bin/ksh
#
# Program Name	: ohrevup006.sh
# Description	: Off-hours Flexgen initialization procedure
# Author	: Linda S. Jefferis
# Date		: 09/19/2010
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/flexgen"
FLEX="/usr/lnk/flexgen"
VFAXDIR=/usr/vsifax/spool;export VFAXDIR
PATH=$PATH:/usr/vsifax/bin:/usr/pdm/bin;export PATH


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ohrevup006.sh 

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

# Parse environment variables
parse_env

cd ${FLEX}

date
echo "--> Starting - ohrevup006.cs"

cdir=`pwd`
FG4PID=$$               ;export FG4PID
TERMINFO=$cdir/terminfo ;export TERMINFO
RUNPATH=$cdir/fg4bin:$cdir/obj    ;export RUNPATH
RMPATH=$cdir            ;export RMPATH
FM4MENUI=FG4DICTI       ;export FM4MENUI
FM4MENUR=FG4DICTR       ;export FM4MENUR
FM4ERROR=FG4ERROR       ;export FM4ERROR
REVER00MAS=/usr/lnk/claims/REVER00MAS ;export REVER00MAS
echo "REVER00MAS=$REVER00MAS"
FG4BATCH=Y
runfg4  OHREVUP006 -k -a 'TIO=_./;;'
unset REVER00MAS

date
echo "--> Finished" 


exit 0
