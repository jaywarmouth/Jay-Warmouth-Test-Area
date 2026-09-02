#!/bin/sh


#
# MAIN
#

FILE_LIST=$1
datestamp=`/bin/date "+%Y%m%d"`
RETVAL=0
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
DIR_LOC=/usr/lnk/git/projf6rmcob
FILE_LIST=/usr/lnk/wt/oper-wt/SprintConfigs/${FILE_LIST}
OBJ_LOC=/usr/lnk/obj
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
	sourcefile="${OBJ_LOC}/${LINE}.cob"
#Check to see if source exists and if so do backup
	if [ ! -r "$sourcefile" ]
	then
		echo "*> No $sourcefile to do backup"
	else
		/bin/bak $sourcefile	
	fi
done

# Copy cob files
echo "-> Copying cob to ${HOSTNAME}:${OBJ_LOC}"
RETVAL=0
for LINE in `cat $FILE_LIST`
do
	echo "FNAME=$LINE.cob"
	cp ${DIR_LOC}/${LINE}.cob ${OBJ_LOC}
	RETVAL=$?
	if [ $RETVAL -eq 0 ]
	then
		chmod 664 ${OBJ_LOC}/${LINE}.cob; chgrp devadm ${OBJ_LOC}/${LINE}.cob
	else 
		echo "**> Issue with cob copy"
		exit $RETVAL
	fi 
done

date
echo "EXIT Code = $RETVAL"

exit $RETVAL
