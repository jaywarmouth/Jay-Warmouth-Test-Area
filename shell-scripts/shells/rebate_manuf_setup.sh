#!/bin/ksh
#
# Program Name	: rebate_manuf_setup.sh
# Description	: Creates requested manuf. directory and associated link
#		  Command Line Arguments:
#		  -m <manuf. abbrev. name> - enter in uppercase
#		  -s <sys# - 4-digits>
# Author	: Linda S. Jefferis
# Date		: 08/16/2001
# Modifications : 10/16/2001 - Changed input of manuf. to Uppercase 
#		: 02/11/2002 - Fixed for switch from pdm01 to Crow  (LSJ)
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 12/03/2005 - Changes for new system names (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
HOST=`/usr/lnk/shell/get_hostname.sh`
MAN=""
SYS=""
REB_DIR="/usr/lnk/rebate"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebate_manuf_setup.sh -m <manuf> -s <sys#>
	<manuf> is the manufacturer's abbreviation in uppercase
	<sys#> is 4-digit system number

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
# Convert to Uppercase
make_caps()
{
	CAP_MAN=`echo ${MAN} | sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/'`
}

#
# Convert to Lowercase
make_lower()
{
	LOWER_MAN=`echo ${MAN} | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 4 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -m) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	MAN=$1
	make_lower
	;;
    -s) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SYS=$1
	;;
  esac
  shift
done


# Parse environment variables
#parse_env

if [ $SYS = "" ]
then
	usage
	exit 1
fi

if [ ${HOST} = "husk" -o ${HOST} = "robin" ]
then
   cd ${REB_DIR}/sys${SYS}
   mkdir -m 775 ${LOWER_MAN}
   chgrp pdm ${LOWER_MAN}
   ln -s ${LOWER_MAN} ${MAN}
else
   echo ""
   echo "THIS PROCEDURE CAN ONLY BE RUN ON Husk or Robin"
   exit 1
fi

exit 0
