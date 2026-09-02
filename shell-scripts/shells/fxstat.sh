#!/bin/ksh
#
# Program Name	: fxstat.sh
# Description	: vsifax status check for individual users
# Author	: Anthony DePinto
# Date		: 10-28-96
# Modifications :
#
# Variables Used:
EXPIRED=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: fxstat.sh [-u User] [-x]

ENDOFUSAGE
  exit 1
}

#
# Get status 
get_status()
{
   if [ ${EXPIRED} -eq 1 ]
   then
     echo "----------------------"
     echo "-- Expired attempts --"
     echo "----------------------"
     fxstat -xu ${LOGNAME}
   else
     echo "---------------------"
     echo "-- Active attempts --"
     echo "---------------------"
     fxstat -u ${LOGNAME}
   fi 
   exit 0
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -eq 0 ] 
then
  get_status
fi
while [ $# -gt 0 ]
do 
  case "$1"
  in 
    -u) shift
	if [ $# -le 0 ]
	then
	  usage
        fi
	LOGNAME=$1
	;;
    -x) EXPIRED=1
	;;
    *) 
	usage
	;;
  esac
  shift
done

get_status

exit 0
