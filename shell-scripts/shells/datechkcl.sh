#!/bin/ksh
#
# Program Name	: datechkcl.sh
# Description   : Check Claim Century Dates               
# Author	: Kim Konyshak 
# Date		: 02/22/99
# Modifications : 07/07/99 - Added email of PRINT-DATECHK-CLAIM file  (LSJ)
#		  07/19/99 - Added Christina to email  (LSJ)
#		  07/21/99 - Changed variable MAIL_2 to MAIL_ALSO  (LSJ)
#		: 06/01/00 - Removed kkonyshak@pdmi.com  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/misc
REPORTS="PRINT-DATECHK-CLAIM"
USER=""
FILE_FLAG=0
MAIL_TO=charris@pdmi.com
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: datechkcl.sh [-f <filename>]

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


# Submit datechkcl program
submit_datechkcl()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/datechkcl
 
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
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

rm -f ${PRINT_DIR}/${REPORTS}

echo Century Date Check Report
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

submit_datechkcl
date
echo "THE Y2K DATECHKCL PROGRAM HAS RUN" | mail ${MAIL_TO}
if test -s ${PRINT_DIR}/${REPORTS}
then
   cat ${PRINT_DIR}/${REPORTS} | mail ${MAIL_TO}
else
   echo "The ${PRINT_DIR}/${REPORTS} is empty" | mail ${MAIL_TO}
fi

exit 0
