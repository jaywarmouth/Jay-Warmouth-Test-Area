#!/bin/sh
#
# Program Name	: wh_limitrb01.sh
# Description	: Runs limitrb01.sh and gets file to sqlimports/misc area,
# Author	: Linda S. Jefferis
# Date		: 03/17/2016
# Modifications	: 05/26/2016 - TT13915-26
#		: 6/1/2016 - TT13915-26 - added missing DATE variable
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
ZIP_PROG="/bin/gzip"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
DATE=`date +%Y%m%d`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_limitrb01.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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

#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        REC_CNT=`wc -l ${FNAME} | awk '{ print $1 }'`
        CNAME=${FNAME}-counts-${DATE}
        echo ${REC_CNT}","${DATE} > ${CNAME}
        mv ${FNAME} ${FNAME}-${DATE}
        gzip ${FNAME}-${DATE}
        gzip ${CNAME}
        mv ${FNAME}-${DATE}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${FNAME}"
		RETVAL=99
        fi
        mv ${CNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${CNAME}"
        fi
else
        echo "${FNAME} does not exist"
fi
date
}

#
# Main routine
#

# Parse environment variables
parse_env


${SHELL_DIR}/limitrb01.sh -i /usr/lnk/log/LIMWHSEP-WH 2>&1
RETVAL=$?
if [ $RETVAL = 0 ]
then
	FNAME=${LIMWHSEE}
	file_transfer
fi

exit $RETVAL
