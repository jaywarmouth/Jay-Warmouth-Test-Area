#!/bin/sh



#
#
# MAIN
#
# Version 1.1 - 11/25/2008 Changed hostname process and added logic for S1Rook
# Version 1.2 - 11/23/2009 Added logic for prod11
# Version 2.0 -            Logic changes for COLO conversion
# Version 2.1 - 07/24/2011 Removed claim96_cio run for pronto10
# Version 2.2 - 08/20/2011 Changed "today" date format
# Version 2.3 - 09/12/2016 added 'claim96.sh -a efss' process


machine=`/usr/lnk/shell/get_hostname.sh`

if [ "$machine" = "prod11" ]
then
	echo "Can only be run on prod20, prod10, prod11, husk & robin"
        exit 1
fi

today=`date +%Y%m%d`

if [ "$machine" = "prod10" ] 
then
	auditdir="/usr/prod11/audit"
	/usr/lnk/shell/claim96.sh -a all -d $today -p $auditdir
	/usr/lnk/shell/claim96.sh -a efss -d $today -p $auditdir
else
	auditdir="/usr/lnk/audit"
	/usr/lnk/shell/claim96.sh -a all -d ${today}.prod11 -p $auditdir
fi


