#!/bin/sh

#Program to stop the realtime elig processing 

# Find the PID of elgrt02 and kill it

EPID=`ps -ef|grep "elgrt02_auto.sh" | grep -v "grep" | awk '{ print $2 }'`

if [ -n "$EPID" ]
then
        if [ "$EPID" -gt "1" ]
        then
                kill "$EPID"
        fi
fi


# Let's wait a few seconds before we tell it to stop
sleep 5

# Send exit to ELGRT02

echo -e "*EXIT\003" | /usr/local/bin/sndmsg 79 stdin 1
echo -e "79" | /usr/local/bin/sndmsg 80 stdin 1

