#!/bin/ksh
#
# Program Name	: drug005.sh
# Description   : Medispan Drug Update 
#		  Command Line Arguments:
#		  -f full file flag (optional)
# Author	: Linda S. Jefferis
# Date		: 06/17/96
# Modifications : 08/26/97 (LSJ) Added env_var & OBJ_DIR logic
#		: 06/06/01 (LSJ) Removed assignment of DRUG000TAP; its now in env_var
#               : 05/08/02 (DW) Added Full File switch
#		: 10/20/2004 (LSJ) Deleted the 'rm $DRUG000TAP' line
#		: 08/22/2006 - Added HOSTNAME logic  (LSJ)
#		: 10/23/2017 - Add RETVAL logic (LSJ).
#		: 10/31/2018 - Cahnge switch from -s to -a
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FULLFILE_FLAG=0
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug005.sh [ -f ]

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
    -f) FULLFILE_FLAG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate variables

echo "Drug Update"
echo "HOSTNAME=$HOSTNAME"
date
runcobol ${OBJ_DIR}/drug005 -a ${FULLFILE_FLAG} 
RETVAL=$?
date

exit $RETVAL
