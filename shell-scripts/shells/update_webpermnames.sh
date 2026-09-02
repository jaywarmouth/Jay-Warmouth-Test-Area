#!/bin/sh

#
# updates names in the Web Permissions database to keep Rox from crying.
#

#
# Main
#

TMPFILE="/tmp/.update_webperms.tmp"

/usr/bin/lynx -dump "http://192.168.101.19:8081/webperms/nameupdate.aspx" >$TMPFILE 2>&1

/bin/chmod 400 $TMPFILE
