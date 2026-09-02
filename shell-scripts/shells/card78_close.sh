#!/bin/sh

C_QUEUE="84"
L_QUEUE="65"
MSG="*END-DAY\003"


echo "$MSG" | /usr/pdm/bin/sndmsg $L_QUEUE stdin 1
echo "$L_QUEUE   " | /usr/pdm/bin/sndmsg $C_QUEUE stdin 1

exit 0
