#!/bin/sh
#
# Program Name	: group29.sh
# Description   : Group Update from Tape 
#                 Command line arguments:
# Author	: Christina M. Harris
# Date		: 08/13/97
# Modifications : 
#
#                 10/07/97 CMH ADDED [-S] FOR FULLFILE SWITCH.
#		: 12/08/2005 - Added umask  (LSJ)
#		: 10/15/2010 - Added PDF conversion and email of reports  (LSJ)
#		: 11/11/2010 - Added fix for "binary" characters problem  (LSJ)
#		: 10/08/2017 - TT16593-1; change to runcobol command 
#               : 16/06/2021 - TT20041-46: Change to reduce font size to 8
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
GROUP29TAP=""
HEADER=""
USER=""
CLIENT=""
FULLFILE=0
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="benefits@pdmi.com"
DTETM=`date +%Y%m%d-%H%M%S`
PRINT_DIR=/usr/lnk/misc
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group29.sh -s -a filename username

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


# Submit group29 program
submit_group29()
{
	runcobol ${OBJ_DIR}/group29 -a ${FULLFILE},${HEADER},${USER}
	RETVAL=$?
	
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
        GROUP29TAP=/usr/lnk/elig_in/$1
        HEADER=$1
        USER=$2
        export GROUP29TAP
        ;;
    -s) FULLFILE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=${GRPAUD}
export FG4AUD

umask 000

echo Group Update from Tape
date
submit_group29 
date
CLIENT=`echo ${HEADER} | cut -c1-2`

DONE_RPT="GROUP29-DONE-RPT-${CLIENT}"
SKIP_RPT="GROUP29-SKIP-RPT-${CLIENT}"

if test -s ${PRINT_DIR}/${SKIP_RPT}
then
	enscript -rBgj -f Courier8 --non-printable-format=space -o - ${PRINT_DIR}/${SKIP_RPT} | ps2pdf - ${PRINT_DIR}/${DTETM}-${SKIP_RPT}.pdf
else
	echo "BLANK REPORT CREATED" > ${PRINT_DIR}/${SKIP_RPT}
	enscript -rBgj -f Courier8 --non-printable-format=space -o - ${PRINT_DIR}/${SKIP_RPT} | ps2pdf - ${PRINT_DIR}/${DTETM}-${SKIP_RPT}.pdf
fi


if test -s ${PRINT_DIR}/${DONE_RPT}
then
	enscript -rBgj -f Courier8 --non-printable-format=space -o - ${PRINT_DIR}/${DONE_RPT} | ps2pdf - ${PRINT_DIR}/${DTETM}-${DONE_RPT}.pdf
else
	echo "BLANK REPORT CREATED" > ${PRINT_DIR}/${DONE_RPT}
	enscript -rBgj -f Courier8 --non-printable-format=space -o - ${PRINT_DIR}/${DONE_RPT} | ps2pdf - ${PRINT_DIR}/${DTETM}-${DONE_RPT}.pdf
fi

echo "Attached are the group change reports for client: ${CLIENT}" | ${MAIL_PROG} -s "Group Reports" ${MAIL_TO} -a ${PRINT_DIR}/${DTETM}-${SKIP_RPT}.pdf -a ${PRINT_DIR}/${DTETM}-${DONE_RPT}.pdf

rm -f ${PRINT_DIR}/${DTETM}-${SKIP_RPT}.pdf ${PRINT_DIR}/${DTETM}-${DONE_RPT}.pdf

exit $RETVAL
