#!/bin/ksh
#
# Program Name	: logit.sh
# Description	: Maintain log files from syslog
# Author	: Anthony DePinto
# Date		: 2-14-96
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
MAILTO=administrator@pdmi.com

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: logit.sh 

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

#
#	Move today's system log files to yesterday's
#	and yesterday's to the day before's.  etc.
#	Then mail the contents of yesterday's.

for LOGFILE in /var/spool/logs/local0.log 
do
	OLD=6
	while [ $OLD -gt 1 ]
	do
		NEW=`expr $OLD - 1`
		mv $LOGFILE.$NEW $LOGFILE.$OLD
		OLD=$NEW
	done
	mv $LOGFILE $LOGFILE.$OLD 2> /dev/null
	touch $LOGFILE 2> /dev/null
done

nohup /usr/bin/mailx -s "Nethopper Status" $MAILTO < /var/spool/logs/local0.log.1 &
