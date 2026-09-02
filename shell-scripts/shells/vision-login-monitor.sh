#!/bin/bash

#Script that count how many vision (vis-xxx) accounts are logged in and sends an email alert if
#the number of logged on vis accounts exceeds 200

#created by Joe Simko (06/01/2018)

set -x
VAR1=$(who | grep vis |wc -l)
if (("$VAR1" > 200));
then
        mail -s "Vision Account Logins Alert" jsimko@pdmi.com mwittenauer@pdmi.com <<< "
Vision Account Logins have exceeded 200 on PROD10"
else
        ping -c 1 localhost
fi
