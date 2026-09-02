#!/bin/sh
#
#	PDM Shell script to not allow multiple sessions to clients.
#
#	Author : Anthony DePinto
#	Initiated 10/12/94 As WAN to HealthSource was started.
#	Updates:
#		2/15/96 Deletes old fg4 temp files in home directory
#		2/26/96 Kills processes for previous login if they exist
#
LOGFILE=/usr/lnk/daily/remote.log.`date +%m%d%y`; export LOGFILE
TTY=`who am i | awk '{ print $2}'`
if [ `who | grep ${SPO_NAME} | wc -l` -gt ${CU_LIMIT} ] 
then
  echo "------------------"
  echo "- Multiple login -"
  echo "------------------"
  echo
  echo "Only ${CU_LIMIT} user(s) are allowed on from your"
  echo "sponsor at a time.  Please logoff and "
  echo "try again later."
  echo
  echo "Thank you for your cooperation,"
  echo "			Anthony DePinto"
  echo "			Network Manager"
  echo "			Pharmacy Data Management, Inc."
  echo 
  exit 1
fi
IFS=${OLDIFS}
echo "<$LOGNAME> - $TTY    Time in: `date '+%D %T'`" >> $LOGFILE
cd ${HOME}
rm -f FG4*
cd /usr/pdm/fg4
exec fg4login
