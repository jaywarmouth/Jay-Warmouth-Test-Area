#!/bin/ksh
#
# Program Name	: print_phdem.sh
# Description   : Print script for phdem programs 
#                 Command line arguments:
#                 -p phdem program id (01 - 06)
#                 -u username
# Author	: Linda Jefferis
# Date		: 01/08/98
# Modifications : 05/18/2006 - Logic changes for new variable name  (LSJ)
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

usage: print_phdem.sh 

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
  "01")
	PRT_FILE=${PHDEM01}
	print_file
	;;
  "02")
	PRT_FILE=${PHDEM02}
	print_file
	;;
esac

exit 0
