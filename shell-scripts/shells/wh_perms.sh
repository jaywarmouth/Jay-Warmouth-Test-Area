#!/bin/ksh
#
# Program Name	: wh_perms.sh
# Description	: Runs flexgen procedures to produce extract file for Warehouse.
# Author	: Linda S. Jefferis
# Date		: 10/24/2002
# Modifications : 12/12/2002 - Added permt008.cs and permt009.cs  (LSJ) 
#		: 12/26/2002 - Added copy of flexgen/permissions/PERMI00MAS
#		: 01/21/2003 - Added permt012.cs and permt013.cs  (LSJ)
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 02/22/2006 - Changed umask command  (LSJ)
#		: 04/04/2006 - Removed some procedures  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/rb_01"
FLEX="/usr/lnk/flexgen"
EXTRACT_FILE1="permission-all"
EXTRACT_FILE2="perm-user-menu3"
REMOTE_SYS="prod10"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_perms.sh 

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
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

umask 002

if test -a ${FILE_PATH}/${EXTRACT_FILE1}
then
   rm -f ${FILE_PATH}/${EXTRACT_FILE1}
fi
if test -a ${FILE_PATH}/${EXTRACT_FILE2}
then
   rm -f ${FILE_PATH}/${EXTRACT_FILE2}
fi

cd ${FLEX}

scp -q ${REMOTE_SYS}:${FLEX}/permissions/PERMI00MAS permissions

date
echo "--> Creating ${EXTRACT_FILE1} - perpc007.cs"
${FLEX}/perpc007.cs

date
echo "--> Running - perbt001.cs"
${FLEX}/perbt001.cs

date
echo "--> Running - perbt002.cs"
${FLEX}/perbt002.cs

date
echo "--> Running - perbt003.cs"
${FLEX}/perbt003.cs

date
echo "--> Running - permt012.cs"
${FLEX}/permt012.cs

date
echo "--> Creating ${EXTRACT_FILE2} - permt013.cs"
${FLEX}/permt013.cs
date

exit 0
