#!/bin/sh

# Purpose: Clean xbis trace files from /tmp/xbis/trace. Will remove trace files that are 5
# or more minutes old
#
# MAIN
#
/usr/bin/find /tmp/xbis/trace -mmin +5 -type f -name "trc*" -exec rm -f {} \;

exit 0
