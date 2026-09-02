#!/bin/ksh
#
# Program Name	: wh_daily_claims.sh
# Description	: Procedure to create claims extract file for Warehouses
#		  Command Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 01/10/2011
# Modifications : 02/10/2011 - Add mail to mpaulus of claim72pdmd output
#		: 07/30/2012 - Change logic for "totals" file 
#		: 02/26/2015 - Add exit code 99 logic; TT #12593-2
#		: 03/10/2015 - Update "yesterday 0800" TT #13309-5
#		: 11/09/2016 - TT13915-40
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
PATH=/usr/rmcobol:$PATH
RPT_DIR="/usr/lnk/rpt"
ZIP_PROG="/bin/gzip"
FILE1=CL72-D-PDM
FILE2=D0CL72
DIR_1=/usr/lnk/tmp
WH_DIR=/usr/lnk/sqlimports/claims
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="claims"
DATE=`date -d "yesterday 0800" +%Y%m%d`
PROCESS_DATE=`date -d "yesterday 0800" +%Y%m%d`
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
MAIL_PROG=/bin/mail
MAIL_TO="operations@pdmi.com"
MAIL_CC="TransTeam@pdmi.com"
MAIL_ERR="OPSoncall@pdmi.com pagewarehouse@pdmi.com operations@pdmi.com warehouse@pdmi.com"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_daily_claims.sh

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


#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
	gzip ${FNAME}
	mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
	if test $? -ne 0
	then
		echo "Error with transfer of ${FNAME}"
	fi
else
	echo "${FNAME} does not exist"
fi
}



# Claims Extract
claim_extract()
{
	echo
	echo "--> Starting claims extract - claim72pdm"
	${SHELL_DIR}/claim72pdm.sh -c day > ${RPT_DIR}/claim72pdmd 2>&1
	RETVAL="$?"
	if [ ${RETVAL} = 99 ]
	then
        	echo "Error with daily claim72pdm" | ${MAIL_PROG} -s "Error-daily claim72pdm" -c ${MAIL_CC} ${MAIL_ERR}
	else
		echo "     `grep "CLAIMS READ:" ${RPT_DIR}/claim72pdmd`"
		echo "`grep "ERROR CLAIM00TAP: 9701" ${RPT_DIR}/claim72pdmd`"
		mv ${DIR_1}/???${FILE1} ${WH_DIR}/${FILE2}-${DATE}

		if test -s ${WH_DIR}/CL72-COUNTS-D
		then
			mv ${WH_DIR}/CL72-COUNTS-D ${WH_DIR}/CL72-COUNTS-D-${DATE}
			FNAME=${WH_DIR}/CL72-COUNTS-D-${DATE}
			file_transfer
		else
			echo ""
			echo "-*> The file, ${WH_DIR}/CL72-COUNTS-D is not available"
		fi

		FNAME=${WH_DIR}/${FILE2}-${DATE}
		file_transfer
		mail_process
	fi
}


# Email to Operations
mail_process()
{
cat ${RPT_DIR}/claim72pdmd | ${MAIL_PROG} -s "claim72pdmd output for ${PROCESS_DATE}" ${MAIL_TO}
}


#
# Main routine
#

umask 111

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

claim_extract

exit $RETVAL
