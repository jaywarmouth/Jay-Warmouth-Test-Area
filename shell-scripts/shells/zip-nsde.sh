#!/bin/ksh
#
# Program Name	: zip-nsde.sh
# Description	: Zipping nsde files 
# Author	: Linda S. Jefferis
# Date		: 10/31/2014
# Modifications : 11/13/2014 - some cleanup items.
#		: 04/28/2015 - TT:12829-32 updates.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
RPTARCH="/usr/lnk/rptarch/nsde"
MISC_DIR="/usr/lnk/misc"
TMP_DIR="/tmp"
RPT_DIR="/usr/lnk/rpt"
ZIP_PROG="/usr/bin/zip"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-nsde.sh [-d <ccyymmdd>]
	<ccyymmdd> is the current date 

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


# Parse environment variables
parse_env

date

zip -mj ${TMP_DIR}/nsde-${DATE}.zip /usr/lnk/misc/NSDE*-${DATE}.csv

zip -mj ${TMP_DIR}/nsde-${DATE}.zip /usr/upd/drug/NSDE000WRK-${DATE}

zip -mj ${TMP_DIR}/nsde-${DATE}.zip /usr/lnk/wt/oper-wt/MEDD/CMSNSDE.csv

zip -mj ${TMP_DIR}/nsde-${DATE}.zip /usr/lnk/rpt/nsde-*

mv ${TMP_DIR}/nsde-${DATE}.zip ${RPTARCH}
if test $? -ne 0
then
	echo "-*> The archive/copy of nsde-${DATE}.zip to ${RPTARCH} failed"
	exit 1
fi

date

exit 0
