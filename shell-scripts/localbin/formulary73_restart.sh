#!/bin/sh

#Program to stop the realtime processing 


echo -e "*EXIT\003" | /usr/local/bin/sndmsg 126 stdin 1
echo -e "126" | /usr/local/bin/sndmsg 125 stdin 1

# This should be auto-restart by the "super shell" 
