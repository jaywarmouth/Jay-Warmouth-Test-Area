#!/bin/sh

# Close elgrt02

C_QUEUE="80"
L_QUEUE="79"
MSG="*END-DAY\003"
echo -e "$MSG" | /usr/local/bin/sndmsg $L_QUEUE stdin 1
echo "$L_QUEUE   " | /usr/local/bin/sndmsg $C_QUEUE stdin 1


# Close etraf01
# Commented 4/6/2020
#C_QUEUE="800"
#L_QUEUE="801"
#MSG="*END-DAY\003"
#echo -e "$MSG" | /usr/local/bin/sndmsg $L_QUEUE stdin 1
#echo "$L_QUEUE   " | /usr/local/bin/sndmsg $C_QUEUE stdin 1

exit 0
