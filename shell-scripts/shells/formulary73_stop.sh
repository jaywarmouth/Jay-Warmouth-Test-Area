#!/bin/sh

#Program to stop the realtime formulary processing 

# Find the PID of formulary73 and kill it

EPID=`ps -ef|grep "formulary73_auto.sh" | grep -v "grep" | awk '{ print $2 }'`

if [ -n "$EPID" ]
then
        if [ "$EPID" -gt "1" ]
        then
                kill "$EPID"
        fi
fi


# Let's wait a few seconds before we tell it to stop
sleep 5

# Send exit to formulary73

echo -e "*EXIT\003" | /usr/local/bin/sndmsg 126 stdin 1
echo -e "126" | /usr/local/bin/sndmsg 125 stdin 1

