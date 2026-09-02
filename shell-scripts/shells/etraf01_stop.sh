#!/bin/sh

# force etraf01 to stop

C_QUEUE="800"
L_QUEUE="801"
MSG="*EXIT\003"
echo -e "$MSG" | /usr/local/bin/sndmsg $L_QUEUE stdin 1
echo "$L_QUEUE   " | /usr/local/bin/sndmsg $C_QUEUE stdin 1

exit 0
