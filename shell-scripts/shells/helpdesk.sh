#!/bin/ksh
#
# Program Name	: helpdesk.sh
# Description	: Submit helpdesk socket reader
# Author	: Anthony DePinto
# Date		: 2-14-97
# Modifications :
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

usage: helpdesk.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
      FIRSTCH=`echo ${VAR} | cut -c1`
      if [ ${FIRSTCH} != "#" ]
      then
	IFS=${EQUAL}
	NVAR=`echo ${VAR} | awk '{print $1}'`
        eval ${VAR} 2> /dev/null
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "Parse Error on Line: "${VAR}
        fi
      fi
    done
    IFS=${OLDIFS}

}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -ne 0 ] 
then
  usage
fi


nohup /usr/local/bin/helpdesk 2>&1  > /dev/null &
# nohup /usr/pdm/bin/helpdesk 2>&1  > /tmp/helpdesk.log.$$ &
retval="$?"


exit 0
