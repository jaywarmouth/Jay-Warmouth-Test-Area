#!/bin/sh


#
# MAIN
#

FILE_LIST=$1
datestamp=`/bin/date "+%Y%m%d"`
RETVAL=0
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
DIR_LOC=/usr/lnk/git/rmcob
ARCH_DIR=/usr/lnk/git/rmcob/Archive
FILE_LIST=/usr/lnk/wt/oper-wt/SprintConfigs/${FILE_LIST}
OBJ_DIR=/usr/lnk/obj
LST_DIR=/usr/lnk/lst
DEV_SERVER=cobol-dev01
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
	sourcefile="${OBJ_DIR}/${LINE}.cob"
#Check to see if source exists and if so do backup
	if [ ! -r "$sourcefile" ]
	then
		echo "*> No $sourcefile to do backup"
	else
		/bin/bak $sourcefile	
	fi
done

# Copy cob files
echo "-> Copying cob to ${HOSTNAME}:${OBJ_DIR}"
RETVAL=0
for LINE in `cat $FILE_LIST`
do
	echo "FNAME=$LINE.cob"
	cp ${DIR_LOC}/${LINE}.cob ${OBJ_DIR}
	RETVAL=$?
	if [ $RETVAL -eq 0 ]
	then
		chmod 664 ${OBJ_DIR}/${LINE}.cob; chgrp devadm ${OBJ_DIR}/${LINE}.cob
		scp ${OBJ_DIR}/${LINE}.cob ${DEV_SERVER}:${OBJ_DIR}
		ssh ${DEV_SERVER} "chmod 664 ${OBJ_DIR}/${LINE}.cob"
		scp ${DIR_LOC}/${LINE}.lst ${DEV_SERVER}:${LST_DIR}
		ssh ${DEV_SERVER} "chmod 664 ${LST_DIR}/${LINE}.lst"
		mv ${DIR_LOC}/${LINE}.lst ${ARCH_DIR}	
		mv ${DIR_LOC}/${LINE}.cob ${ARCH_DIR}
	else 
		echo "**> Issue with cob copy"
		exit $RETVAL
	fi 
done

date
echo "EXIT Code = $RETVAL"

exit $RETVAL
