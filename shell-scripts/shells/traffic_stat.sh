#!/bin/ksh
#
# Program Name	: traffic_stat.sh
# Description	: Check to see if traffic drivers are up
# Author	: Anthony DePinto
# Date		: 4-30-97
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
COMPU04_LINE=9[13456]

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: traffic_stat.sh 

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

check_compu04()
{
   echo "--> Checking for compu04..."
   echo

   OLDIFS=${IFS}
   IFS=${CR}

   for PSL in `ps -ef | grep compu04`
   do
     RESULT=`echo $PSL | grep -w ${COMPU04_LINE}`
     if [ $? -eq 0 ]
     then
       echo ${RESULT}
     fi
   done

   IFS=${OLDIFS}

   echo
}

check_directdrv()
{
   echo "--> Checking for direct drivers..."
   echo

   ps -ef | grep dir.out

   echo
}

check_envdrv()
{
   echo "--> Checking for envoy drivers..."
   echo

   ps -ef | grep env-x25d.out

   echo
}

check_ndcdrv()
{
   echo "--> Checking for ndc drivers..."
   echo

   ps -ef | grep ndc.out

   echo

}

get_compu04_pids()
{
CR="
"
OIFS=$IFS
IFS=$CR

for line in `ps -ef | grep "compu04.scr -q" | grep -v "grep compu04"`
do
IFS=$OIFS
	pid=`echo $line|awk '{ print $2 }'`
	echo -n "$pid "
IFS=$CR
done

IFS=$CR
for line in `ps -ef | grep "compu04 -C" | grep -v "grep compu04"`
do
IFS=$OIFS
	pid=`echo $line|awk '{ print $2 }'`
	echo -n "$pid "
IFS=$CR
done


IFS=$OIFS


}

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    "-c")	# get pid's of compu04
		get_compu04_pids 
		exit 0
		;;
    *)
       usage
       ;;
  esac
done

check_compu04

check_directdrv

check_envdrv

check_ndcdrv

exit 0
