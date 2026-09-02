#!/bin/sh

#  crdrt01 (COBOL) stop
# 

C_QUEUE="78"
MSG="*EXIT\003"
echo -e "$MSG" | /usr/local/bin/sndmsg $C_QUEUE stdin 1

exit 0
