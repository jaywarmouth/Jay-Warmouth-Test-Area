#!/bin/sh
#
# Program Name	: cp_clmrt_files.sh.sh
# Description	: 
#		Command line Arguments:
#			-d <ccyymmdd> - alternate date
# Author	: Linda Jefferis
# Date		: 03/25/2013
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%Y%m%d`
CLMRT_DIR="/usr/lnk/daily"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_clmrt_files.sh.sh <-d ccyymmdd>
	if "-d" not used, date is yesterday

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
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
esac
  shift
done

find ${CLMRT_DIR} -follow -name "CLMRT-${DATE}" -print > /tmp/clmrt-filelist
for FILE in `cat /tmp/clmrt-filelist`
do
	scp $FILE prod10:$FILE.${HOSTNAME}
done


exit 0
