#!/bin/sh
#
#Program Name	: arch_cawrk.sh
#Description	: Shell for archiving days eligibility CAWRK term files
#		: Version 1.0
#Modifications	: Version 1.5 - added zip of meddeligrpt file
# 		: 8/13/2013 add lgic to remove unprocessed eligibility files from elig_in (DME)
#		: 07/11/2014 - extend date for removing unprocessed Files from elig_in (DME)
#
#
#
#Variables Used:
FILE_DIR=/usr/lnk/tmp
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
DATE=$1
RM_DATE=`date -d "7 days ago" +%m%d`
ELIG_DIR=/usr/lnk/elig_in

#
#Usage Routine
usage()
{
        echo "USAGE:"
        echo "arch_cawrk.sh <ccyymmdd>"
	exit 1
}

#Remove unused eligibility files
rm_elig()
{

for file in $(ls -1 ??e${RM_DATE}* ??g${RM_DATE}* ??l${RM_DATE}* ??o${RM_DATE}* ??p${RM_DATE}*)
do
        rm -f ${file}
done
}


#Main routine

if [ $# -lt 1 ]
then
	usage
	exit 1
fi

if [ $HOSTNAME = "prod10" ]
then
	cd ${FILE_DIR}
	if test $? -ne 0
	then
		echo "-*> The directory, $FILE_DIR, does not exist..."
		exit 1
	fi
	find . -name "????????-CAWRK.zip" -mtime +30 -exec rm -f {} \;
	zip -m ${DATE}-CAWRK.zip CAWRK*
	zip -m ${DATE}-CAWRK.zip ??e????-term
	zip -m ${DATE}-CAWRK.zip meddeligrpt-????.csv
	
	cd ${ELIG_DIR}
	if test $? -ne 0
        then
                echo "-*> The directory, $ELIG_DIR, does not exist..."
                exit 1
        fi
	rm_elig
else
	echo "-*> This script must be run on PROD10..."
fi

exit 0
