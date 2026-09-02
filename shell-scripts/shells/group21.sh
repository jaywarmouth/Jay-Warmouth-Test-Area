#!/bin/ksh
#
# Program Name	: group21.sh
# Description   : Group Update from Tape 
#                 Command line arguments:
#                 -s FULLFILE
# Author	: Dave Tucci
# Date		: 02/05/97
# Modifications : 
#                 04/08/97 CMS Added USER to command line to pass to program.
#                 06/18/97 LSJ Added env_var & OBJ_DIR logic
#                 08/18/97 DAT Added [-s] for FULLFILE switch.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FULLFILE=0
OBJ_DIR=/usr/lnk/obj
GROUP21TAP=""
HEADER=""
USER=""
CHUNK=""
MAIL_TO="benefits@pdmi.com"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group21.sh -s -a ["pathname&filename&username"]

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


# Submit group21 program
submit_group21()
{
       if [ ${FULLFILE} = 1 ]
       then
        runcobol ${OBJ_DIR}/group21 -s 1 -a ${HEADER}'           '${USER}'            '
       fi
       if [ ${FULLFILE} = 0 ]
       then
        runcobol ${OBJ_DIR}/group21 -s 0 -a ${HEADER}'           '${USER}'            '
       fi
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
        GROUP21TAP=/usr/pdm/elig_in/$1
        HEADER=$1
        USER=$2
        export GROUP21TAP
        ;;
    -s) FULLFILE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=/usr/lnk/tmp/GRPAUD
export FG4AUD

echo Group Update from Tape
date
submit_group21 
date
CHUNK=`echo ${HEADER} | cut -c1-2`
lp /usr/lnk/misc/GROUP21-SKIP-RPT-${CHUNK}
lp /usr/lnk/misc/GROUP21-DONE-RPT-${CHUNK}
#cat /usr/lnk/po/misc/GROUP21-SKIP-RPT-${CHUNK} | mail ${MAIL_TO}
#cat /usr/lnk/po/misc/GROUP21-DONE-RPT-${CHUNK} | mail ${MAIL_TO}

exit 0
