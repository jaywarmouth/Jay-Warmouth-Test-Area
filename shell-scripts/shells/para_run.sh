#!/bin/sh

# Global vars
OIFS="$IFS"
CR="
"
PID_FILE="/tmp/.para_run_process.$$"

MAX_SIMUTANEOUS="99"

usage() {

echo "para_run.sh config_file"

exit 1
}

get_date()
{
date +"%D %T"
}
# Remove files.
clear_slots() {
	NEW_SLOT_COUNTER="0"
	while [ "$NEW_SLOT_COUNTER" -lt "$MAX_SIMUTANEOUS" ]
	do
		TMP_PID_FILE="${PID_FILE}.${NEW_SLOT_COUNTER}"
		if [ -f "$TMP_PID_FILE" ]
		then
			rm -f ${TMP_PID_FILE}
		fi
		NEW_SLOT_COUNTER="`expr ${NEW_SLOT_COUNTER} + 1`"

	done
}

get_available_slot() {
	NEW_SLOT_COUNTER="0"
	while [ "$NEW_SLOT_COUNTER" -le "$MAX_SLOTS" ]
	do
		TMP_PID_FILE="${PID_FILE}.${NEW_SLOT_COUNTER}"
		if [ ! -f "$TMP_PID_FILE" ]
		then
			echo ${NEW_SLOT_COUNTER}
			return
		fi
		NEW_SLOT_COUNTER="`expr ${NEW_SLOT_COUNTER} + 1`"

	done
}


load_jobs()
{
FILE="$1"
IFS="$CR"
COUNTER="0"
GROUP=1
SLOT_COUNT=1

for line in `cat ${FILE} | grep -v "^#" | grep -v "^$"`
do
	CMD="`echo $line | awk -F= '{ print $1 }'`"
	DATA="`echo $line | awk -F= '{ print $2 }'`"

	case ${CMD} in
		"GROUP")
			GROUP="$DATA"
			;;
		"SLOTS")
			if [ "$DATA" -le "0" ] 
			then
				echo "Invalid slot count: $DATA"
				echo "Near: ${line}"
				exit 1
			else
				SLOT_COUNT="$DATA"
			fi
			;;
		"RUN")
			RUNCMD[${COUNTER}]="$DATA"
			GROUP[${COUNTER}]="$GROUP"
			SLOTS[${COUNTER}]="$SLOT_COUNT"
			COUNTER=`expr $COUNTER + 1`
			;;
		*)
			echo "Unknown command"
			echo "Near: ${line}"
			exit 1
			;;
		esac
	
	IFS="$CR"
done

echo "`get_date`: ${COUNTER} jobs loaded."

}


#
# MAIN
#

#set -x

SOURCE_FILE="$1"

if [ ! -f "${SOURCE_FILE}" ]
then
	echo "Config file not found."
	usage
	exit 1
fi

# Main looping boolean
MAIN_RUN=1

# Sleep time between checks
CHECK_DELAY=1

# Minimum Sleep Time
MINIMUM_CHECK_DELAY=1

# Maximum Sleep Time
MAXIMUM_CHECK_DELAY=10

# Remove any slot files that may be from old runs.
clear_slots

#echo "Loading config file"
load_jobs "$SOURCE_FILE"

# Set trap when we exit shell
trap 'echo -e "\nKilled\nCleaning up...";clear_slots' 0

# Slots
TOTAL_SLOTS="${SLOTS[0]}"
if [ "$TOTAL_SLOTS" -gt "$MAX_SIMUTANEOUS" ]
then
	TOTAL_SLOTS="$MAX_SIMUTANEOUS"
fi
if [ "$TOTAL_SLOTS" -le "0" ]
then
	TOTAL_SLOTS="1"
fi


MAX_SLOTS="${TOTAL_SLOTS}"
AVAILABLE_SLOTS="${TOTAL_SLOTS}"


# Track if something started/finished recently
RECENT_ACTIVITY=1


echo "`get_date`: Total Slots: $TOTAL_SLOTS"
echo "`get_date`: Available Slots: $AVAILABLE_SLOTS"


JOB_COUNTER="0"
JOB_STILL_RUNNING="0"

echo "`get_date`: Starting job processing"
# Main loop
while [ "$MAIN_RUN" -eq "1" ]
do
	RECENT_ACTIVITY="0"

	if [ "${AVAILABLE_SLOTS}" -gt "0" -a "${JOB_COUNTER}" -lt "${#RUNCMD[@]}" ]
	then
		RECENT_ACTIVITY="1"
		NewSlotNumber=`get_available_slot`
		JOB="${RUNCMD[$JOB_COUNTER]}"
		echo "`get_date`: Running job #`expr ${JOB_COUNTER} + 1`: $JOB"
		eval "$JOB &"
		JobPID="$!"
		echo "$JobPID `expr $JOB_COUNTER + 1`" >${PID_FILE}.${NewSlotNumber}
		AVAILABLE_SLOTS="`expr ${AVAILABLE_SLOTS} - 1`"
		if [ "$TOTAL_SLOTS" -ne "${SLOTS[${JOB_COUNTER}]}" ]
		then
			TOTAL_SLOTS="${SLOTS[${JOB_COUNTER}]}"
			if [ "$TOTAL_SLOTS" -gt "$MAX_SIMUTANEOUS" ]
			then
				TOTAL_SLOTS="$MAX_SIMUTANEOUS"
			fi
			if [ "$TOTAL_SLOTS" -le "0" ]
			then
				TOTAL_SLOTS="1"
			fi
			echo "`get_date`: Total Slots: $TOTAL_SLOTS"
		fi
		if [ "$TOTAL_SLOTS" -gt "$MAX_SLOTS" ]
		then
			MAX_SLOTS="$TOTAL_SLOTS"
		fi

		JOB_COUNTER="`expr $JOB_COUNTER + 1`"
	
	fi

# Check to see if a process finished

	JOB_PID_COUNTER="0"
	JOB_STILL_RUNNING="0"
	while [ "$JOB_PID_COUNTER" -le "$MAX_SLOTS" ]
	do
		TMP_PID_FILE="${PID_FILE}.${JOB_PID_COUNTER}"
		if [ -f "$TMP_PID_FILE" ]
		then
			JobPID=`cat ${TMP_PID_FILE} | cut -d ' ' -f 1`
			JobNumber=`cat ${TMP_PID_FILE} | cut -d ' ' -f 2`
			JobCount="`ps --no-header -p $JobPID | wc -l`"
			if [ "$JobCount" -eq "0" ] 
			then
				# Job Finished!
				RECENT_ACTIVITY="1"
				rm -f "${TMP_PID_FILE}"
				echo "`get_date`: Job #${JobNumber} finished"
				AVAILABLE_SLOTS="`expr ${AVAILABLE_SLOTS} + 1`"
			
			else
				JOB_STILL_RUNNING="1"
			fi
		fi
			
		JOB_PID_COUNTER="`expr $JOB_PID_COUNTER + 1`"

	done



# Check to see if we are done
	if [ "${JOB_STILL_RUNNING}" -eq "0" -a "${JOB_COUNTER}" -ge "${#RUNCMD[@]}" ]
	then
		echo "`get_date`: Jobs completed"
		RECENT_ACTIVITY="1"
		MAIN_RUN="0"
	fi

#  Decay Algorithm
	
	if [ "$RECENT_ACTIVITY" -eq "1" ]
	then
		CHECK_DELAY="$MINIMUM_CHECK_DELAY"
	else
		# No activity, increment delay by 1 second
		CHECK_DELAY="`expr ${CHECK_DELAY} + 1`"
	fi

	if [ "${CHECK_DELAY}" -gt "$MAXIMUM_CHECK_DELAY" ]
	then
		CHECK_DELAY="$MAXIMUM_CHECK_DELAY"
	fi	

# Pause before we check again
#	echo "Delaying ${CHECK_DELAY} second(s)"
	sleep ${CHECK_DELAY}
done

trap ' ' 0

