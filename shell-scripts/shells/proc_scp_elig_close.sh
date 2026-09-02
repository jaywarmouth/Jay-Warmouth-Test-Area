#!/bin/sh

C_QUEUE="86"
L_QUEUE="85"
MSG="*END-DAY|"


echo "$MSG" | /usr/local/bin/sndmsg $L_QUEUE stdin 1
echo "$L_QUEUE   " | /usr/local/bin/sndmsg $C_QUEUE stdin 1
exit 0
