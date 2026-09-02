#!/bin/ksh
#
# Program Name	: mv_resp.sh
# Description	: Move select resp files to new name
#		  Command Line Arguments:
#		  -d <mmddyy>
#		  -n <suffix name>
# Author	: Linda S. Jefferis
# Date		: 10/09/98
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PID=$$
RSP_DIR="/usr/lnk/rsp"
FLIST=/tmp/flist.resp.${PID}

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv_resp.sh -d <mmddyy> -n <suffix name>

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
    -n) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        SUFFIX=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

cd ${RSP_DIR}
ls resp-??-${DATE} > ${FLIST}

for FNAME in `cat ${FLIST}`
do
   mv ${FNAME} ${FNAME}.${SUFFIX}
done

exit 0
