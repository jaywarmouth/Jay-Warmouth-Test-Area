#!/bin/ksh
#
# Program Name	: datechk.sh
# Description   : Check Century Dates               
#                 Command Line Arguments:
#                 -f <filename> Name of file for run. (optional)
# Author	: Debbie Wilson
# Date		: 07/14/98
# Modifications : 07/19/99 - Added Christina to mail  (LSJ)
#		: 06/01/00 - Removed kkonyshak@pdmi.com  (LSJ)
#		: 07/26/00 - Change email message that is sent  (LSJ)
#		: 01/30/2008 - Changed MAIL_TO from charris to programmers  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/misc
REPORTS="PRINT-DATECHK-*"
USER=""
FILENAME="null"
SELECT_FILE=0
MAIL_TO=programmers@pdmi.com
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: datechk.sh [-f <filename 10-chars>]

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


# Submit datechk program
submit_datechk()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/datechk -s ${SELECT_FILE} -a ${FILENAME}'          '
 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
   -f) shift
       if [ $# -le 0 ]
       then
         usage
       fi
       FILENAME=$1
       SELECT_FILE=1
       ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

rm -f ${PRINT-DIR}/${REPORTS}

echo Century Date Check Report
echo "FILE SENT IN:"
echo "    FILENAME=$FILENAME"
date
submit_datechk
date
echo "THE DATECHK PROGRAM HAS RUN" | mail ${MAIL_TO}

exit 0
