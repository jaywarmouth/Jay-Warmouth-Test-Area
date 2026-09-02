#!/bin/ksh
#
# Program Name	: ben55merge.sh
# Description   : Update BEN5500MAS & Add Membership       
#                 Command line arguments:
#                 -m Set run month <ccyymm>                   
# Author	: Deborah L. Wilson
# Date		: 03/23/01
# Modifications : 08/17/2001 - Added remove and print of PRINT-BENEFIT80 (LSJ)
#                 03/07/2002 - Changed name of program & print file to BEN55MERGE (DW)
#		: 09/01/2005 - Added "umask 002" command  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
MONTH=0
MISC_DIR="/usr/lnk/misc"
PRINTFILE="PRINT-BEN55MERGE"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ben55merge.sh [-m <ccyymm>]

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

# Submit ben55merge program
submit_ben55merge()
{
        runcobol ${OBJ_DIR}/ben55merge -a ${MONTH} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -m) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        MONTH=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

umask 002

echo "Benefit 55 File & Membership Update"
date
rm -f ${MISC_DIR}/${PRINTFILE}

submit_ben55merge

date

if test -s ${MISC_DIR}/${PRINTFILE}
then
   lp ${MISC_DIR}/${PRINTFILE}
fi

exit 0
