#!/bin/sh

#Program to stop the realtime elig processing (test env)


echo -e "*EXIT\003" | /usr/local/bin/sndmsg 82 stdin 1
echo -e "82" | /usr/local/bin/sndmsg 83 stdin 1

