#!/bin/ksh
#
# Program Name	: reversals.sh
# Description	: Runs rever01 and limit26 or limitcms01 with sw1 on.
# Author	: Linda S. Jefferis
# Date		: 06/10/97
# Modifications : 06/30/97 DAT Add USER to pass to COBOL Program 
#                 08/28/97 CMH Add USERCLASS for permissions
#		: 03/10/2006 - LSJ - Logic for limitcms01 procedure
#                 01/05/07 - MP - Add switch to runcobol for limitcms01
#		: 07/21/2010 - Changes for LIMIT30 now being assigned via env_var to HOME directories.
#		: 03/31/2017 - TT16858-6; RV60100MAS logic.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
USERCLASS=""
DATE=`date +%Y%m%d`
AUDIT_DIR=/usr/lnk/audit

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: reversals.sh -a ["userclass&username"]

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

# Parse out Reversal file to get sponsor

parse_rev_file()
{
    SPONSOR=`cat ${REVOUTFILE} | cut -c 17-20`
    echo $SPONSOR
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USERCLASS=$1
        USER=$2
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign Alternate Environmentals

AUDIT20MAS=/usr/lnk/audit/CLAIM02
export AUDIT20MAS
RV60100MAS=${AUDIT_DIR}/RV601-MAN-${DATE}
export RV60100MAS

runcobol ${OBJ_DIR}/rever01 -a ${USER}'            '

parse_rev_file

if [ $SPONSOR = 0435 ]
then
   runcobol ${OBJ_DIR}/limitcms01 -s 100 -a ${USERCLASS}${USER}'            '
else
   runcobol ${OBJ_DIR}/limit30 -s 100 -a ${USERCLASS}${USER}'            '
fi


exit 0
