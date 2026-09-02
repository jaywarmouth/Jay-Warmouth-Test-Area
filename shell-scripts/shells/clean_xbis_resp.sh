#!/bin/sh
# SRR 8/24/2015
# Shell to clean up xbis trace files.  Will remove trace files that are 5
# or more minutes old

/usr/bin/find /var/local/liant/bis -mmin +5 -type f -name *.xml-Req* -exec rm -f {} \;
/usr/bin/find /var/local/liant/bis -mmin +5 -type f -name *.xml-Rsp* -exec rm -f {} \;
exit 0
