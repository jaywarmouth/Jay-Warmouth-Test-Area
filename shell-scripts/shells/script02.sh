#!/bin/ksh
#
# Program Name  : script02.cbl
# Description   : Creates directories. (COBOL Version)
#                 Command line arguments:
#                 -r <0|1> -  1 to do all directories (po, xp, elig_in, elig_out, fax)
#			      0 does not do (fax, elig_in, elig_out)
# Author        : Joel C. Kampfer
# Date          : 08/06/96
# Modifications : 07/28/97 - LSJ - Added env_var & OBJ_DIR logic.
#		: 10/24/2005 - Changes for Linux  (LSJ)
#
# Variables Used:
PATH=$PATH:/opt/rmcobol:/usr/local/bin
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HOST=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: script02.sh [-r <0|1>]
	0 - only updates po and xp directories
	1 - updates all directories (po, xp, fax, elig_in, elig_out)

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


# Submit script02 program
submit_script02()
{
        runcobol ${OBJ_DIR}/script02 -s "${ARGUMENT}"
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ ! $# -eq 2 ]
then usage
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
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

date

echo "HOSTNAME=${HOST}"
submit_script02

date

exit 0
~

