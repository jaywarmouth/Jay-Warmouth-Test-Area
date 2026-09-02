#!/bin/ksh
#
# Program Name	: cat_nhin.sh
# Description	: Concatenates individual payment tapes
#		  Command Line Arguments:
#		  -p <p/e Prefix>  e.g. J15
#		  -f <Alternate tape path>
# Author	: Linda S. Jefferis
# Date		: 10/16/2000
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
LIST="/usr/lnk/tapes/nhin-list"
TAPE_DIR="/usr/lnk/tapes"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cat-nhin.sh [-p <p/e prefix>] [-f <directory>]

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
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	PREFIX=$1
	;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	TAPE_DIR=$1
	;;
  esac
  shift
done

if test -a ${TAPE_DIR}/${PREFIX}NHIN
then
   rm ${TAPE_DIR}/${PREFIX}NHIN
fi

for FNAME in `cat ${LIST}`
do
  if test -s ${TAPE_DIR}/${PREFIX}${FNAME}
  then
	echo "--> Adding ${PREFIX}${FNAME} to ${PREFIX}NHIN"
	cat ${TAPE_DIR}/${PREFIX}${FNAME} >> ${TAPE_DIR}/${PREFIX}NHIN
  else
	echo "-*> No payment tape file found for ${PREFIX}${FNAME}"
  fi
done


exit 0
