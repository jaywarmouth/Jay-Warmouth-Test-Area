#!/bin/bash


LOGFILE="/tmp/.get_claim_count.out"

startDate="$1"
endDate="$2"

date > $LOGFILE
echo "startDate: $startDate" >>$LOGFILE
echo "endDate: $endDate" >>$LOGFILE

python3.9 /usr/local/bin/linedrvCnt.py "$startDate" "$endDate" >>$LOGFILE 2>&1
cat /tmp/countRecord.json
