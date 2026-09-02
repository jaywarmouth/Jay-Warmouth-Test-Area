#!/bin/bash

QUEUE_LIMIT=2500
QUEUE_RESUME=350
QUEUE_DIR="/tmp/rtcqueue"
BACKUP_DIR="/tmp/rtcqueue_backup"
FILENAME_PREFIX="rtc-"

mkdir -p "$QUEUE_DIR"
mkdir -p "$BACKUP_DIR"

# Function to get current queue count from ipcs
get_queue_count() {
    ipcs -aq | grep "0x00000044" | awk '{ print $6 }'
}

# Function to generate a unique filename
generate_unique_filename() {
    mktemp "${QUEUE_DIR}/rtc-XXXXXXXX"
}

# Function to process the oldest file
process_oldest_file() {
    local file
    file=$(find "$QUEUE_DIR" -type f -name "${FILENAME_PREFIX}*" | sort | head -n 1)
    if [[ -n "$file" ]]; then
        head -c 15 "$file" | tr -d '\n' | awk '{printf "%s\0", $0}' | sndmsg 68 stdin 2 16

	echo "`date`: Process file $file"
        mv -f "$file" "$BACKUP_DIR"
	return 1
    fi

	return 0
}

# Continuous loop

echo "`date`: $0 started"
while true; do

sleep="1"

    queue_count=$(get_queue_count)



	if [ "$queue_count" -ge "$QUEUE_LIMIT" ]
	then
	    echo "`date`:Hit limit $queue_count"
	    sleep="0"
	    out_file=$(generate_unique_filename)
            rcvmsg 68 2 > "$out_file"
	fi

if [ "$queue_count" -le "$QUEUE_RESUME" ] ; then

    process_oldest_file
    retval="$?"

	if [ "$retval" -eq "1" ]
	then
        sleep=0
    	fi
fi




if [ "$sleep" -eq "1" ]
then
	sleep 2
fi

done

