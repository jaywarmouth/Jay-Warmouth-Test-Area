#!/bin/sh



#
#
# MAIN
#


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
	runline="/usr/lnk/shell/claim96-exc.sh -a all -d $today -p $auditdir"


else
	auditdir="/usr/lnk/audit"
	runline="/usr/lnk/shell/claim96-exc.sh -a all -d ${today}.prod11 -p $auditdir"
fi

#cd /usr/lnk
echo $runline
eval $runline

#if [ "$machine" = "dev10" ]
#then
#	auditdir="/usr/lnk/audit"
#	/usr/lnk/tstshl/claim96_cio.sh -t -a all -d ${today}.prod11 -p $auditdir
#fi
