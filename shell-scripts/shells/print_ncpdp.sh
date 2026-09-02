#!/bin/ksh
#
# Program Name	: print_ncpdp.sh
# Description   : Print script for ncpdp programs 
#                 Command line arguments:
#                 -p ncpdp program id (02M,02D,02ERROR,02CHAIN,02NPI,03)
#                 -u username
# Author	: Linda Jefferis
# Date		: 01/08/98
# Modifications : 03/29/06 - Redirect to users home directory and add 09-15
#		: 05/18/2006 - Changed logic for the printing  (LSJ)
#		: 05/04/2007 - Added NCPDP02NPI file  (LSJ)
#               : 06/16/2008 - Added NCPDP04M file (MJP)
#		: 06/18/2008 - Fixed missing ;;  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PROG_ID=""
USER=""
ARGUMENT=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: print_ncpdp.sh [-p 02M|02D|02ERROR|02CHAIN|02NPI|03|04M] [-u <username>]

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

# Print the file
print_file()
{
	mv ${PRT_FILE} ${PRT_FILE}.bak
	lp ${PRT_FILE}.bak
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	PROG_ID=$1
        ;;
    -u) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ARGUMENT=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

# Print procedure
#

case ${PROG_ID} in
  "03")
	PRT_FILE=${NCPDP03}
	print_file
	;;
  "02M")
	PRT_FILE=${NCPDP02M}
	print_file
	;;
  "02D")
	PRT_FILE=${NCPDP02D}
	print_file
	;;
  "02ERROR")
	PRT_FILE=${NCPDP02ERROR}
	print_file
	;;
  "02CHAIN")
	PRT_FILE=${NCPDP02CHAIN}
	print_file
	;;
  "02NPI")
	PRT_FILE=${NCPDP02NPI}
	print_file
	;;
  "04M")
        PRT_FILE=${NCPDP04M}
        print_file
	;;
esac


exit 0
