#!/bin/sh



#
#
# MAIN
#
# Modifications: 06/11/2014 - commented out "prod10" logic
#		 12/01/2014 - uncommented "prod10" and /usr/prod20/audit logic
#		 09/12/2016 added 'claim96.sh -a efss' process


machine=`/usr/lnk/shell/get_hostname.sh`

if [ "$machine" = "prod20" ]
then
	echo "Can only be run on prodtest10, prod10, prod11, husk & robin"
        exit 1
fi

today=`date +%Y%m%d`

if [ "$machine" = "prod10" ]
then
	auditdir="/usr/prod20/audit"
        /usr/lnk/shell/claim96.sh -a all -d $today -p $auditdir
        /usr/lnk/shell/claim96.sh -a efss -d $today -p $auditdir
else
	auditdir="/usr/lnk/audit"
	/usr/lnk/shell/claim96.sh -a all -d $today.prod20 -p $auditdir
fi


