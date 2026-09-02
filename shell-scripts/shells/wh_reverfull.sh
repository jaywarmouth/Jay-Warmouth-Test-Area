#!/bin/sh
#
# Program Name	: wh_reverfull.sh
# Description	: Procedure to run weekly full REVER00MAS warehouse extract
# Author	: Linda S. Jefferis
# Date		: 04/08/2019

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PATH=/usr/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
DATE=`date -d "yesterday 0800" +%Y%m%d`
ZIP_PROG="/bin/gzip"
RETVAL=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_reverfull.sh

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
# Reversal File Extract
rever_extract()
{
	echo
        echo "--> reversal file extract - rever04"
        ${SHELL_DIR}/rever04.sh -o ${REVERRB001}FULL > ${RPT_DIR}/rever04-full 2>&1
        RETVAL=$?
	cat ${RPT_DIR}/rever04-full
        if [ ${RETVAL} = 99 ]
        then
                echo "  -*> ERROR with REVER04 - Weekly Full file extract"
		exit ${RETVAL}	
        else
                FNAME=${REVERRB001}FULL
                file_transfer
        fi
}


#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

date

rever_extract

exit ${RETVAL}
