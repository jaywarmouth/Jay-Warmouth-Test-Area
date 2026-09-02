#!/bin/ksh
#
# Program Name	: rejects.sh
# Description	: Runs reject01 and limit30 or limitcms01 with sw2 on.
# Author	: Dave Tucci
# Date		: 05/13/98
# Modifications : 11/11/99 - Added demo switch logic  (LSJ)
#		: 02/24/2006 - Added umask command  (LSJ)
#		: 03/10/2006 - Changes for limitcms01 procedure  (LSJ)
#		: 07/21/2010 - Removed "rm" command before run of limit30; LIMIT30 is now assigned via env_var to HOME directories.
#		: 03/31/2017 - TT16858-6; RV60100MAS logic.
#			and remove special CLLOC00MAS.preproc assignment.
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

usage: rejects.sh -a ["userclass&username"] 

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

# Parse out Reject file to get sponsor

parse_rej_file()
{
    SPONSOR=`cat ${REJOUTFILE} | cut -c 17-20`
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

AUDIT20MAS=${AUDIT_DIR}/CLAIM02
export AUDIT20MAS
RV60100MAS=${AUDIT_DIR}/RV601-MAN-${DATE}
export RV60100MAS

# Submit programs

runcobol ${OBJ_DIR}/reject01 -a ${USERCLASS}${USER}'            '

parse_rej_file

if [ $SPONSOR = 0435 ]
then
   runcobol ${OBJ_DIR}/limitcms01 -s 01 -a ${USERCLASS}${USER}'            '
else
   runcobol ${OBJ_DIR}/limit30 -s 01 -a ${USERCLASS}${USER}'            '
fi


exit 0
