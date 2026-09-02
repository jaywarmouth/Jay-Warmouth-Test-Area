#!/bin/bash



#set -x

usage()
{
	echo "$0 (-p switch_path | -b filename)  -f switch_prefix -o output_path"
	exit 1
}


load_option="0"
switch_path_option="0"
switch_prefix_option="0"
output_path_option="0"

while [ "$#" -gt "0" ]
do
	case $1 in
	"-b")
		load_file="$2"
		shift
		shift
		load_option="1"
		;;


	"-p")
		switch_path="$2"
		shift
		shift
		switch_path_option="1"
		;;
	"-f")
		switch_prefix="$2"
		shift
		shift
		switch_prefix_option="1"
		;;
	"-o")
		OUTPUT_PATH="$2"
		shift
		shift
		output_path_option="1"
		;;

	 *)
			usage
			exit 1
			;;

	esac


done


if [ "$output_path_option" -eq "0" ]
then
	echo "No output path"
	usage 
	exit 1
fi


if [ "$load_option" -eq "1" ]
then
	if [ ! -f "$load_file" ]
	then
		echo "File does not exist: $load_file"
		exit 1
	fi
fi

if [ "$switch_prefix_option" -eq "0" ]
then
	echo "Must include switch prefix"
	usage
	exit 1
fi

echo "Load file    : $load_file"
echo "Switch path  : $switch_path"
echo "Switch prefix: $switch_prefix"
echo "Output path  : $OUTPUT_PATH"


OIFS="$IFS"
CR="
"

TMP_FILE="/tmp/.send_switchmetadata.$$"
WAIT_TIME="5"
COUNTDOWN="10"


json_escape () 
{

# fastest
printf '"%s"' "$1" 


# faster
#	data=`printf '%s' "$1" | sed -e 's/\"/\\\"/g'`
#	echo -n "\"${data}\""

# slowest
#  printf '%s' "$1" | php -r 'echo json_encode(file_get_contents("php://stdin"));'
}

process_meta()
{
meta="$1"
                        eval `echo $meta | awk '{ print $1 " " $2 " " $5 " " $6 " TimeStamp=\42"$3 " " $4 "\42" }'`
                        echo -en "\"switch\": `json_escape "$switch_prefix"`,"
                        echo -en "\"line\": `json_escape "$Line"`,"
                        echo -en "\"queuenumber\": `json_escape "$Q"`,"
                        echo -en "\"runtimeMilliseconds\": $Runtime,"
                        echo -en "\"transactionId\": `json_escape "$TID"`,"
                        echo -en "\"timeStamp\": `json_escape "$TimeStamp"`,"
}



process_claim()
{
claim="$1"


	bin=`echo "$claim" | cut -c 7-13`
	version=`echo "$claim" | cut -c 14-15`
	transactioncode=`echo "$claim" | cut -c 16-17`
	pcn=`echo "$claim" | cut -c 18-27`
	serviceproviderid=`echo "$claim" | cut -c 31-45`
	dateofservice=`echo "$claim" | cut -c 46-53`
	softwarecert=`echo "$claim" | cut -c 54-63`


	batchandclaim=`echo "$claim" | grep -o -P '(?<=\034F3).*(?=\034)' | cut -f1 -d'' | cut -f1 -d'' | cut -f1 -d'' | cut -f1 -d'' | cut -f1 -d''`
	rejectcode=`echo "$claim" | grep -o -P '(?<=\034FB).*(?=\034)' | cut -f1 -d'' | cut -f1 -d'' | cut -f1 -d'' | cut -f1 -d'' | cut -f1 -d''`
	groupnumber=`echo "$claim" | grep -o -P '(?<=\034C1).*(?=\034)' | cut -f1 -d'' | cut -f1 -d'' | cut -f1 -d '' | cut -f1 -d'' | cut -f1 -d''`
	



	echo -n "\"bin\": `json_escape "${bin}"`,"
	echo -n "\"version\": `json_escape "${version}"`,"
	echo -n "\"transactionCode\": `json_escape "${transactioncode}"`,"
	echo -n "\"pcn\": `json_escape "${pcn}"`,"
	echo -n "\"serviceProviderId\": `json_escape "${serviceproviderid}"`,"
	echo -n "\"dateOfService\": `json_escape "${dateofservice}"`,"
	echo -n "\"softwareCertification\": `json_escape "${softwarecert}"`,"
	echo -n "\"batchAndClaim\": `json_escape "${batchandclaim}"`,"
	echo -n "\"rejectCode\": `json_escape "${rejectcode}"`,"






	echo -n "\"groupNumber\": `json_escape "${groupnumber}"`"

}



process()
{
process_file="$1"

meta=`head -1 $process_file`
claim=`tail -1 $process_file`


meta_json=`process_meta "$meta"`
claim_json=`process_claim "$claim"`

echo -n "{"
	
echo -n "$meta_json"
echo -n "$claim_json"

	
echo -n "}"

}

generate_filename()
{
timestamp=`date +%s.%N`
NEW_UUID=$(uuidgen | fold -w 32)
randomid=${NEW_UUID:0:5}

fn="claimmeta.${timestamp}.${randomid}"
echo -n $fn
}

# MAIN


date=`date +%Y%m%d`
#date="20191114"


line_counter="1"


while [ "$COUNTDOWN" -gt "0" ]
do


	if [ "$load_option" -eq "1" ]
	then
		file="$load_file"
	else
		file="${switch_path}/${switch_prefix}-$date"
	fi

	tail -n +${line_counter} $file | head -n 2 > "$TMP_FILE"


	rows=`wc -l "$TMP_FILE" | cut -f1 -d' '`

	if [ "$rows" -eq "2" ]
	then
	
		tmpline=`head -1 $TMP_FILE`
		if [ "${tmpline:0:4}" != "Line" ]
		then
			echo "Issue parsing at line $line_counter"
			line_counter=`expr $line_counter + 1`
			continue
		fi

		outfile="${OUTPUT_PATH}/`generate_filename`"

		process $TMP_FILE >$outfile
		line_counter=`expr $line_counter + 3`
	else
		# If loading a batch file, just exit once done
		if [ "$load_option" -eq "1" ]
		then
			COUNTDOWN="0"	
			continue
		fi


		sleep $WAIT_TIME
		current_date=`date +%Y%m%d`

		if [ "$current_date" != "$date" ]
		then
			COUNTDOWN=`expr $COUNTDOWN - 1`
		fi

	fi

done

rm -f "$TMP_FILE"
