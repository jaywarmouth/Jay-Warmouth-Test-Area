#!/bin/sh

usage()
{
	echo  "$0 filename target_server"
	echo "filename - name of file with list of enviornmental variables to file compare"
	echo "target_server - name or IP address of server to copy files too."
	exit 1
}




# MAIN

# Location of env_var file on remote system
TARGET_ENV_VAR_LOCATION="/usr/lnk/shell/env_var"


# Location of local env_var file
SOURCE_ENV_VAR="/usr/lnk/shell/env_var"

# Temporary local copy
TARGET_ENV_VAR="/tmp/env_var.target.$$"


filelist="$1"
target_host="$2"

if [ ! -f "$filelist" ] 
then
	echo "Cannot find file $1"
	usage
	exit 1
fi

if [ "$target_host" == "" ]
then
	usage
	exit 1
fi

scp -q ${target_host}:${TARGET_ENV_VAR_LOCATION}  ${TARGET_ENV_VAR} >/dev/null 2>&1
retval="$?"

if [ "$retval" -ne "0" ]
then
	echo "Unable to copy env_var file ${target_host}:${TARGET_ENV_VAR_LOCATION}"
	exit 1
fi
	date
	echo "Local server : `uname -n`"
	echo "Remote server: $target_host"

	echo -e "Status\tVariable\tSource File\t$Target File\tRuntime"

total_start_time=`date +%s`
for variable in `cat $filelist | grep -v "^#"`
do
	status="UNKNOWN"
	skip_check="0"
	do_compare="1"
	local_check="[N/A]"
	target_check="[N/A]"
	runtime="0"
	total_runtime="0"

	if [ "$variable" == "" ]
	then
		continue
	fi

	source_file=`grep "^${variable}=" $SOURCE_ENV_VAR | awk -F= '{ print $2 }' | awk '{ print $1 }'`
	target_file=`grep "^${variable}=" $TARGET_ENV_VAR | awk -F= '{ print $2 }' | awk '{ print $1 }'`

	if [ "$source_file" == "" ]
	then
		source_file="[VARIABLE NOT FOUND]"
		status="MISSING VARIABLE"
		skip_check="1"
	fi
	if [ "$target_file" == "" ]
	then
		target_file="[VARIABLE NOT FOUND]"
		status="MISSING VARIABLE"
		skip_check="1"
	fi


	if [ "$skip_check" -eq "0" ]
	then
		start_time=`date +%s`
		scp -q $source_file ${target_host}:${target_file} 
		retval="$?"
		if [ "$retval" -ne "0" ]
		then
			status="FAIL"
		else
			status="SUCCESS"
		fi 
		end_time=`date +%s`

		runtime=`echo "scale=2;($end_time-$start_time)/60" | bc`

	
	fi


	echo -e "$status\t$variable\t$source_file\t${target_host}:${target_file}\t$runtime"

done
total_end_time=`date +%s`
runtime=`echo "scale=0;($total_end_time-$total_start_time)/60" | bc`
echo "Total Runtime (minutes): $runtime"


rm -f "$TARGET_ENV_VAR" "$TMP_SOURCE_CHECKSUM" "$TMP_TARGET_CHECKSUM"


exit 0






