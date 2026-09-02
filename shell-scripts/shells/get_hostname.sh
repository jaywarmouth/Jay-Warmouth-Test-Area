#!/bin/ksh
#
# Program Name	: get_hostname.sh
# Description	: Run correct hostname command based whether Unix or Linux
# Author	: Linda S. Jefferis
# Date		: 10/17/2005
# Modifications : 10/10/2008 - Removed "-s" option for the /bin/hostname  (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: get_hostname.sh 

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

UNAME=`uname`
if [ ${UNAME} = "Linux" ]
then
   HOSTNAME=`/bin/hostname -s`
   if [ $HOSTNAME = "localhost" ]
   then
	HOSTNAME=`/bin/hostname`
   fi
else
   HOSTNAME=`/usr/ucb/hostname`
fi
echo $HOSTNAME

exit 0
