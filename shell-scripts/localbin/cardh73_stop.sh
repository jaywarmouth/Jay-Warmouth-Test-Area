#!/bin/sh

#Program to stop the realtime elig processing


echo -e "*EXIT\003" | /usr/local/bin/sndmsg 61 stdin 1
echo -e "61" | /usr/local/bin/sndmsg 86 stdin 1

