#!/bin/ksh
#
# Program Name  : claim110.sh
# Description   : Claims to File Transfer for Pharmacuetical Horizons
#                 Command Line Arguments:
#                 -r Rerun (<ccyymmdd> date of rerun as argument)
# Author        : David Tucci
# Date          : 01/21/99
# Modifications : 05/28/99 - Added century to input date  (LSJ)
#		  07/14/99 - Changed from email to fax  (LSJ)
#		  07/16/99 - Added needed variables for faxing to work  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
FILE_NAME="???CL110ALAN"
FILE_DIR=/usr/lnk/tapes
MAIL_2="azaenger@ee.net"
MAIL_1="cwitt@ee.net"
MAIL_3="vmorgan@ee.net"
MAIL_LOG=/usr/pdm/tapes/mail_rpt
FAX_NAME="Witt-Morgan-Zaenger"
FAX_NUM="6147816503"
ARGUMENT="00000000"
FXMAILTO="ljefferi"; export FXMAILTO
FAXFROM="PDM Data Center"
export FAXFROM
VFAXDIR=/usr/vsifax/spool;export VFAXDIR
PATH=$PATH:/usr/vsifax/bin:/usr/pdm/bin;export PATH
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim110.sh [-r <ccyymmdd>]

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit claim110 program
submit_claim110()
{
        runcobol ${OBJ_DIR}/claim110 -a ${ARGUMENT}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
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

# Assign alternate environment variables

echo Alternate and PDM group listing
date
submit_claim110
date

if test -s ${FILE_DIR}/${FILE_NAME}
then
	cd ${FILE_DIR}
	echo "Daily Claims File" > ${MAIL_LOG}
	echo "-----------------" >> ${MAIL_LOG}
	echo >> ${MAIL_LOG}
	echo "Name of File:  "`ls ${FILE_NAME}` >> ${MAIL_LOG}
	echo "Number of Claims:  "`wc -l < ${FILE_NAME}` >> ${MAIL_LOG}
	mv ${FILE_DIR}/${FILE_NAME} /home/ph/ph-tr
	#cat ${MAIL_LOG} | mail ${MAIL_1} ${MAIL_2} ${MAIL_3}
	fax ${FAX_NAME} ${MAIL_LOG} ${FAX_NUM}
else
	rm ${FILE_DIR}/${FILE_NAME}
fi
	
exit 0
