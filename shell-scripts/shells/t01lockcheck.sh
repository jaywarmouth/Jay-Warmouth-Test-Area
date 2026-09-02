#!/bin/sh

COMPU04DAILY="/usr/lnk/daily/compu04"
TMPLOCATION="/tmp/t01lockcheck"
UPDATE_MINUTES="15"
OUTFILE="${TMPLOCATION}/t01lockcheck.txt"
FUSER_OUTPUT="${TMPLOCATION}/t01lockcheck_fuser.$$.txt"
PS_OUTPUT="${TMPLOCATION}/t01lockcheck_ps.$$.txt"
LOCKFILE="/tmp/.t01lockcheck.lock"
MAIL_LIST="operations@pdmi.com,srandlet@pdmi.com,cthornton@pdmi.com,networking@pdmi.com"
RSP_PATH="/usr/lnk/rsp"

if [ ! -d "$TMPLOCATION" ]
then
	mkdir -p $TMPLOCATION
fi

if [ -f "$LOCKFILE" ]
then
	echo "Process already running"
	exit 1
fi

touch $LOCKFILE
trap 'rm -f $OUTFILE $LOCKFILE $tmp_file $FUSER_OUTPUT $PS_OUTPUT' 0


FOUND="0"

#set -x
for long_fn in `find $COMPU04DAILY -cmin -${UPDATE_MINUTES}  -name "traffic01_*"`
do
	echo "Checking $long_fn"
	fn=`echo $long_fn|awk -F/ '{ print $NF '}`
	tmp_file="${TMPLOCATION}/${fn}.last.tmp.$$"
	last_tmp_file="${TMPLOCATION}/${fn}.last.tmp"
	last_file="${TMPLOCATION}/${fn}.last"

	cp $long_fn $last_tmp_file

	if [ -f "${last_file}" ]
	then
		diff $last_file $last_tmp_file > ${tmp_file}
	else
		cp $last_tmp_file ${tmp_file}
	fi
	count=`grep -c "LOCK CNT: 005001" ${tmp_file}` 
	if [ "$count" -gt "0" ]
	then
		FOUND="1"
		echo "LOCK limit exceeded on ${long_fn}">>$OUTFILE
	fi
	
	
	mv ${last_tmp_file} ${last_file}

done

if [ "$FOUND" -eq "1" ]
then
	dinfo=`date +"%m%d%y"`
	
	RESPONSE_FILE="${RSP_PATH}/resp-0000-${dinfo}"
	RESPONSE_FILES="${RSP_PATH}/resp-????-${dinfo}"
	/sbin/fuser -u $RESPONSE_FILE $RESPONSE_FILES >$FUSER_OUTPUT
	ps -ef >$PS_OUTPUT
	echo "LOCK LIMIT HIT!"
	echo "Lock limit reached in traffic01.  Check logs" | mutt -a "${OUTFILE}" -a $FUSER_OUTPUT -a $PS_OUTPUT -s "LOCK limit reached in T01." ${MAIL_LIST}
fi

rm -f $OUTFILE $LOCKFILE $tmp_file $FUSER_OUTPUT $PS_OUTPUT

exit 0
