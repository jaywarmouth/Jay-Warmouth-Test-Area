#!/bin/ksh
#
# Program Name	: limit40.sh
# Description   : SIHO Accumulations
#                 Command line arguments:
#                 -d date suffix <mmdd> of sia file
# Author	: David Tucci
# Date		: 10/12/97
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=`echo $USER`
DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_OUT=/usr/lnk/elig_in_1

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit40.sh [ -d <mmdd> ]

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


# Submit limit40 program
submit_limit40()
{
        runcobol ${OBJ_DIR}/limit40 -a ${USER}'            '
 
}

#
# Main routine
#

#Check command line validity, call usage if incorrect
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

# Parse environment variables
parse_env

# Assign alternate environment variables
ACCUM01MAS=/usr/lnk/elig_in/sia${DATE}
export ACCUM01MAS
FG4AUD=/usr/lnk/audit/SIHO_LIMAUD-${DATE}
export FG4AUD

date
echo ${USER}
touch ${FG4AUD}
submit_limit40 
mv ${ELIG_OUT}/sia${DATE} ${ELIG_OUT}/sys029/sia${DATE}
rm ${ELIG_DIR}/sia${DATE}
date
lp /usr/lnk/rpt/limit40

exit 0
