#!/bin/sh


cleanup()
{
	rm -f $LOCKFILE
}


mail_error()
{
msg="$1"
	echo "$msg" | /bin/mail -s "mumms elig" $MAILUSER


}

#
# MAIN
#


SCPLOG="/tmp/.proc_scp_elig.scp"
SCP_CMD="/usr/bin/scp"
SSH_CMD="/usr/bin/sftp"
REMOTE_RM_CMD="rm"
HOST="192.168.101.20"
HOST_USER="mumm-scp"
HOST_DIR="/pub"
INBOUND_FLAG="D*.done"
INBOUND_FLAG_DIR="/home/scpcpy/flags"
INBOUND_DATA_DIR="/home/scpcpy/data"
PROCESS_DIR="/usr/lnk/elig_in/sys0073"
LOCKFILE="/tmp/.proc_scp_elig.mumms.lock"
SNDMSG_CMD="/usr/local/bin/sndmsg"
RCVMSG_CMD="/usr/local/bin/rcvmsg"
QUEUE_NUMBER="85"
CMP_QUEUE="86"

MAILUSER="operator@pdmi.com"

if [ -f "$LOCKFILE" ] 
then
	echo "ERROR: Process already running!" 
	mail_error "proc_scp_elig tried to run while existing process running. Check immediatly!" 
	exit 1
fi

touch $LOCKFILE

#rm -f $SCPLOG
date >> $SCPLOG

trap cleanup 0

date

$SCP_CMD ${HOST_USER}@${HOST}:${HOST_DIR}/${INBOUND_FLAG} ${INBOUND_FLAG_DIR} >>$SCPLOG 2>&1
RETVAL="$?"

if [ "$RETVAL" -ne "0" ]
then
	echo "No files to process"
	echo " "
	exit 1
fi

echo "File flag(s) found."

for fname in `ls $INBOUND_FLAG_DIR`
do
	datafile=`echo $fname | awk -F. '{ print $1 }'`
	echo Downloading $datafile
	$SCP_CMD ${HOST_USER}@${HOST}:${HOST_DIR}/${datafile} ${INBOUND_DATA_DIR} >>$SCPLOG 2>&1
	RETVAL="$?"
	if [ "$RETVAL" -ne "0" ]
	then
		echo "Error downloading ${datafile}!"
		continue
	fi

done

rm -f ${INBOUND_FLAG_DIR}/*

# set -x

for fname in `ls ${INBOUND_DATA_DIR}`
do
	echo "Copying file to ${PROCESS_DIR} and sending filename to queue"
	cp ${INBOUND_DATA_DIR}/${fname} ${PROCESS_DIR}
	chmod 666 ${PROCESS_DIR}/${fname}
	$SNDMSG_CMD $QUEUE_NUMBER "${fname}|" 1
	echo "${QUEUE_NUMBER}" | $SNDMSG_CMD $CMP_QUEUE stdin 1 
	date
	echo "Waiting for response"
	full_response=`$RCVMSG_CMD $QUEUE_NUMBER 2`
	r_file=`echo $full_response | awk -F\| '{ print $1 }'`	
	date
	echo "Response: $r_file"

	echo "Running: $SCP_CMD ${PROCESS_DIR}/${r_file} ${HOST_USER}@$HOST:/pub" >>$SCPLOG 2>&1
	$SCP_CMD ${PROCESS_DIR}/${r_file} ${HOST_USER}@$HOST:/pub >>$SCPLOG 2>&1
	RETVAL="$?"
	if [ "$RETVAL" -ne "0" ]
	then
		echo "Error sending response ${PROCESS_DIR}/${r_file}!"
		mail_error "Error sending response ${PROCESS_DIR}/${r_file}!"
	else
		echo "Running: $SCP_CMD ${LOCKFILE} ${HOST_USER}@${HOST}:/pub/${r_file}.done" >>$SCPLOG 2>&1
		$SCP_CMD ${LOCKFILE} ${HOST_USER}@${HOST}:/pub/${r_file}.done >>$SCPLOG 2>&1
		RETVAL="$?"
		if [ "$RETVAL" -ne "0" ]
		then
			echo "Error sending response flag ${PROCESS_DIR}/${r_file}.done!"
			mail_error "Error sending response flag ${PROCESS_DIR}/${r_file}.done!"
		else

# remove response file
#			echo "Removing response file ${PROCESS_DIR}/${r_file}"
#			rm -f ${PROCESS_DIR}/${r_file}

# all processed well, remove data file and flag from ftp server
			echo "Removing files from $HOST"
			echo "rm ${HOST_DIR}/${fname}" | $SSH_CMD ${HOST_USER}@${HOST} >>$SCPLOG 2>&1
			echo "rm ${HOST_DIR}/${fname}.done" | $SSH_CMD ${HOST_USER}@${HOST} >>$SCPLOG 2>&1


		fi
	fi
done

# clean up data dir
echo "Cleaning up ${INBOUND_DATA_DIR}"
rm -f ${INBOUND_DATA_DIR}/*

date
echo '*** END PROCESS ***'
echo " "

exit 0

