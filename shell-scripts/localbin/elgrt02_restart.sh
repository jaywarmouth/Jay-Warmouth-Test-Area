#!/bin/sh

#Program to stop the realtime elig processing 


echo -e "*EXIT\003" | /usr/local/bin/sndmsg 79 stdin 1
echo -e "79" | /usr/local/bin/sndmsg 80 stdin 1

# This should be auto-restart by the "super shell" 
