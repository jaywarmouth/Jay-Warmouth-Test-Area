#!/bin/ksh
#
# Program Name	: field_init.sh
# Description	: Off-hours Flexgen initialization procedure
# Author	: Linda S. Jefferis
# Date		: 05/20/2005
# Modifications : 01/11/2006 - Changed ohclaup001 to ohclaup003  (LSJ)
#		: 02/03/2006 - Changed ohclaup003 to ohclaup004  (LSJ)
#		: 12/22/2006 - Changed ohclaup004 to ohclaup006  (LSJ)
#		: 09/20/2007 - Changed ohclaup006 to ohclaup007 and commented out extra runs  (LSJ)
#		: 12/03/2008 - Changed ohclaup007 to ohclaup012
#		: 12/03/2008 - Added ohrevup005
#		: 12/05/2008 - Removed ohrevup005. Only needs run on Rook
#		: 02/16/2012 - Changes for ohclaup012
#		: 09/19/2012 - Changed to run OHLIMUP004
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: field_init.sh 

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

date
echo "--> Starting - OHLIMUP004"
cd /usr/lnk/flexgen
echo "LIMIT00MAS=$LIMIT00MAS"
cdir=`pwd`
FG4PID=$$               ;export FG4PID
TERMINFO=$cdir/terminfo ;export TERMINFO
RUNPATH=$cdir/fg4bin:$cdir/obj    ;export RUNPATH
RMPATH=$cdir            ;export RMPATH
FM4MENUI=FG4DICTI       ;export FM4MENUI
FM4MENUR=FG4DICTR       ;export FM4MENUR
FM4ERROR=FG4ERROR       ;export FM4ERROR
unset FG4BATCH
./runfg4  OHLIMUP004 -k -a 'TIO=_./;;'
unset LIMIT00MAS

echo "--> Finished."
date

exit 0
