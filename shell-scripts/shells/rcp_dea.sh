#!/bin/ksh
#
# Program Name	: rcp_dea.sh
# Description	: Copies the dea file from pdm01 to the production machine for updating. 
# Author	: Linda S. Jefferis
# Date		: 10/25/2001
# Modifications : 10/24/2005 - Changes for Linux  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DEST_DIR="/usr/lnk/sort"
LOAD_PATH="/usr/lnk/rb_01"
REMOTE="raven"
DEA_FILE="DEA00RB001"
STAT_DIR="/tmp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rcp_dea.sh 

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

#
# Copy files
copy_files()
{
	scp ${LOAD_PATH}/${DEA_FILE} ${REMOTE}:${DEST_DIR}
	if test $? -ne 0
	then
	   echo ""
	   echo "-*> The copy of ${LOAD_PATH}/${DEA_FILE} was unsuccessful..."
	   date
	   exit 1
	else
	   touch ${STAT_DIR}/cpdea_flag
	   scp ${STAT_DIR}/cpdea_flag ${REMOTE}:${STAT_DIR}
	   rm ${STAT_DIR}/cpdea_flag
	fi
}


#
# Main routine
#
# Check command line validity, call usage if incorrect

date

echo
echo "--> Copying file to ${REMOTE}"
echo
copy_files

date

# Parse environment variables
#parse_env

exit 0
