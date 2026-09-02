#!/bin/sh
 
#
# Program Name	: reset_modem.sh
# Description	: Send an AT to the given device (modem) to reset it.
# Author	: Steven Randlett
# Date		: 10-08-97
# Modifications : 
#


if [ "$1" = "" ]
then
	echo usage: reset_modem.sh svctag svctag ...
	exit 1
fi 

for svctag in `echo $*` 
do


device=`pmadm -L -p ttymon3 -s "$svctag" | awk -F: '{ print $9 }'`
echo "Resetting device: $device"
pmadm -d -p ttymon3 -s "$svctag"
if [ "$?" -ne "0" ]
then
	echo "ERROR!"
	echo "Are you root?"
	exit 1
fi 

sleep 2
echo "AT" >${device}
sleep 2
pmadm -e -p ttymon3 -s "$svctag"
if [ "$?" -ne "0" ]
then
	echo "ERROR!"
	exit 1
fi 
     
done
