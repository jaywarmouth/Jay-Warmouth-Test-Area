#!/bin/sh


#
# MAIN
#

FILE_LIST=$1
datestamp=`/bin/date "+%Y%m%d"`
RETVAL=0
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
DIR_LOC=/usr/lnk/git/scripts
ARCH_DIR=/usr/lnk/git/scripts/Archive
FILE_LIST=/usr/lnk/wt/oper-wt/SprintConfigs/${FILE_LIST}
SCR_LOC=/usr/lnk/shell
CR="
"

if [ ! -r ${FILE_LIST} ]
then
	echo "**> ${FILE_LIST} does not exist. Process aborted."
	exit 99
fi

echo "-> Running on: ${HOSTNAME}"

date

IFS=${CR}

for LINE in `cat ${FILE_LIST}`
do
	sourcefile="${SCR_LOC}/${LINE}.sh"
#Check to see if source exists and if so do backup
	if [ ! -r "$sourcefile" ]
	then
		echo "*> No $sourcefile to do backup"
	else
		/bin/bak $sourcefile	
	fi
done

# Copy script files
echo "-> Copying script to ${HOSTNAME}:${SCR_LOC}"
RETVAL=0
for LINE in `cat $FILE_LIST`
do
	echo "FNAME=$LINE.sh"
	cp ${DIR_LOC}/${LINE}.sh ${SCR_LOC}
	RETVAL=$?
	if [ $RETVAL -eq 0 ]
	then
		chmod 775 ${SCR_LOC}/${LINE}.sh; chgrp devadm ${SCR_LOC}/${LINE}.sh
		mv ${DIR_LOC}/${LINE}.sh ${ARCH_DIR}
	else 
		echo "**> Issue with script copy"
		exit $RETVAL
	fi 
done

date
echo "EXIT Code = $RETVAL"

exit $RETVAL
