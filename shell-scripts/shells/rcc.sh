#!/bin/bash

#
# Raw Claims Collector
#

SWITCH_ZIP_DIR="/usr/lnk/devl/switchfiles"
SWITCH_ZIP_TMP_DIR="/usr/lnk/devl/switchfiles/tmp/tmp_rcc"

#INPUT_DIR="/tmp/tmp_rcc/incoming"
INPUT_DIR="/media/clientfiles/rcc/incoming"

#PROCESSING_ROOT_DIR="/tmp/tmp_rcc/processing"
PROCESSING_ROOT_DIR="/media/clientfiles/rcc/processing"

#OUTPUT_DIR="/tmp/tmp_rcc/output"
OUTPUT_DIR="/media/clientfiles/rcc/output"

zippass="pdmi940w"


## DO NOT EDIT VARIALBES BELOW HERE

CR="
"
OIFS="$IFS"

LOCKFILE="/tmp/.rcc.lockfile"


directory_setup()
{
DIR="$1"

if [ "$DIR" == "" ]
then
	echo "No directory provided"
	exit 1
fi

if [ ! -d "$DIR" ]
then
	mkdir -p "$DIR"
	if [ "$?" -ne "0" ]
	then
		echo "Error making directory $DIR"
		exit 1
	fi
fi


}


generate_output_file ()
{
basefilename="$1"
PROCESSING_DIR="$2"
udir="$3"

zipfile="${PROCESSING_DIR}/${basefilename}.zip"


cd "$PROCESSING_DIR"
zip "$zipfile" *


outzipfile="${OUTPUT_DIR}/${basefilename}.zip"

if [ -f "$outzipfile" ]
then

	outzipfile="${OUTPUT_DIR}/${basefilename}.${udir}.zip"
	
fi
mv "$zipfile" "$outzipfile"

echo "Output zipfile: $zipfile"

}


generate_zip_file_list()
{
input_type="$1"
input_file="$2"

	IFS="$CR"

	case "$input_type" in
		"bnc")
			for bnc in `cat $input_file | cut -c 1-2 | sort -u`
			do

			bdate=`/usr/lnk/shell/batch2date.sh "${bnc}00" | cut -c 1-6`

			echo $bdate

	done
		;;
		"date")
			for d in `cat $input_file |  sort -u`
			do

			bdate=`date -d"$d" +%Y%m`

			echo $bdate

	done
			

		;;

	esac

	IFS="$OIFS"
}

extract_claims_data()
{
inputtype="$1"
inputfile="$2"

for batch in `generate_zip_file_list "$inputtype" "$inputfile" | sort -u`
do

	echo "Unzipping switchfiles-$batch.zip"

	unzip -q -u -d "$SWITCH_ZIP_TMP_DIR" -P $zippass ${SWITCH_ZIP_DIR}/switchfiles-$batch.zip
done

}

batch2raw() 
{
filename="$1"

basefilename=`basename "$filename" .txt`

outfile="${PROCESSING_DIR}/${basefilename}.rawclaims.txt"

echo "`basename $outfile` - Claims in raw format, one per line" >>$readme_file


/usr/lnk/shell/batchsubmit2raw.sh  "$filename"  >"${outfile}"

#mv "$outfile" "$OUTPUT_DIR"

}

raw2batch() 
{
filename="$1"

basefilename=`basename "$filename" .txt`

outfile="${PROCESSING_DIR}/${basefilename}.batchsubmit.txt"

echo "`basename $outfile` - Claims in the NCPDP Batch standard" >>$readme_file


/usr/lnk/shell/rawclaim2batch.sh  "$filename"  >"${outfile}"

#mv "$outfile" "$OUTPUT_DIR"


}
get_claims_bnc() 
{
filename="$1"
output_type="$2"

basefilename=`basename "$filename" .txt`

outfile="${PROCESSING_DIR}/${basefilename}.${output_type}.txt"
errorfile="${PROCESSING_DIR}/${basefilename}.${output_type}.errors.txt"


/usr/lnk/shell/claim_grepper.sh "-${output_type}" "$filename"  "${SWITCH_ZIP_TMP_DIR}" >"${outfile}" 2> "$errorfile"

#mv "$outfile" "$OUTPUT_DIR"


}

get_claims_date() 
{
filename="$1"

echo "Getting claims data."

OIFS="$IFS"


basefilename=`basename "$filename" .txt`

outfile_raw_16="${PROCESSING_DIR}/${basefilename}.all.switch16.txt"
outfile_raw_40="${PROCESSING_DIR}/${basefilename}.all.switch40.txt"
outfile_raw_all="${PROCESSING_DIR}/${basefilename}.all.txt"
outfile_raw_date_prefix="${PROCESSING_DIR}/${basefilename}"

echo "`basename $outfile_raw_16` - All claims for provided date range input processed on switch16" >>$readme_file
echo "`basename $outfile_raw_40` - All claims for provided date range input processed on switch40" >>$readme_file
echo "`basename $outfile_raw_all` - All claims for provided date range input processed on switch16 and switch40" >>$readme_file

IFS="$CR"
for claimdate in `cat $filename`
do


	format_date=`date -d"$claimdate" +%Y%m%d`
	date_file16="${outfile_raw_date_prefix}.switch16.$format_date"
	date_file40="${outfile_raw_date_prefix}.switch40.$format_date"
	date_all="${outfile_raw_date_prefix}.all.$format_date"

	echo "Claims data from $format_date"

echo "`basename $date_file16` - All claims processed on switch16 for date $format_date" >>$readme_file
echo "`basename $date_file40` - All claims processed on switch40 for date $format_date" >>$readme_file

	/usr/lnk/shell/switchfile2raw.sh "${SWITCH_ZIP_TMP_DIR}/switch16-${format_date}" >"${date_file16}"
	/usr/lnk/shell/switchfile2raw.sh "${SWITCH_ZIP_TMP_DIR}/switch40-${format_date}" >"${date_file40}"


	cat "$date_file16" >>"${outfile_raw_16}"
	cat "$date_file40" >>"${outfile_raw_40}"
	cat "$date_file16" "$date_file40" >"${date_all}"

echo "`basename $date_all` - All claims processed on switch16 and switch40 for date $format_date" >>$readme_file


done

	cat "$outfile_raw_16" "$outfile_raw_40" >"$outfile_raw_all"



IFS="$OIFS"


}


cleanup()
{
	echo -e "\n\nCleaning up directory.  Please wait."
        find $OUTPUT_DIR/*  -mtime +7 -exec rm -rf "{}" \; 
        find $PROCESSING_ROOT_DIR/*  -mtime +3 -exec rm -rf "{}" \; 
        find $SWITCH_ZIP_TMP_DIR/* -mtime +3 -exec rm -rf "{}" \; 

	rm -f $LOCKFILE
	echo "Done."

}


#
# MAIN
#

if [ -f "$LOCKFILE" ]
then
	echo "Process already running, pid `cat $LOCKFILE`"
	echo "Aborting"
	exit 1
fi

echo $$ >$LOCKFILE

#set -o noglob

trap 'cleanup' 0




directory_setup "$INPUT_DIR"
directory_setup "$OUTPUT_DIR"
directory_setup "$SWITCH_ZIP_TMP_DIR"

echo -e "This directory is a temporary directory which will be automatically removed.\nDO NOT STORE STUFF HERE!" >$SWITCH_ZIP_TMP_DIR/README


IFS="$CR"

for filename in `ls $INPUT_DIR`
do
	IFS="$OIFS"

	input_filename="${INPUT_DIR}/$filename"

	if [ ! -s "$input_filename" ]
	then
		continue
	fi

	udir=`uuidgen`
	PROCESSING_DIR="$PROCESSING_ROOT_DIR/$udir"
	export PROCESSING_DIR
	directory_setup "$PROCESSING_DIR"

	extension="${filename##*.}"

	if [ "$extension" != "txt" ]
	then
		echo "Invalid filename $filename provided.  Must be a .txt file"
		echo "Invalid filename $filename provided.  Must be a .txt file" >"${PROCESSING_DIR}/${filename}.error.txt"
		generate_output_file "$filename" "$PROCESSING_DIR" "$udir"
		rm -f "$input_filename"
		continue
		
	fi

	echo "Processing file $filename"


	basefilename=`basename "${filename}" .txt`



	processing_file="${PROCESSING_DIR}/${basefilename}.txt"
	readme_file="${PROCESSING_DIR}/README.txt"

	echo -e "Below is information regarding the files that were created.\n" >>$readme_file


	filetype=`head -1 "${input_filename}" | dos2unix`

	echo "Identified file type: $filetype"

	tail -n+2 "$input_filename" > "$processing_file"
	mv "$input_filename" "${processing_file}.raw.txt"
	dos2unix "${processing_file}"

	echo "`basename ${input_filename}.raw.txt` - Original input file" >>$readme_file
	echo "`basename ${processing_file}` - Original input file with header line removed." >>$readme_file



	case "$filetype" in
		"bnc")
			echo "File is list of batch and claim numbers"
	# Get claims data extracted
	# This can be made more efficient by not doing it separately for
	# each file provided.
	echo "Extracting raw claims data."
	extract_claims_data "$filetype" "${processing_file}"

	echo "Generating output files using $udir directory."

	get_claims_bnc "$processing_file" "B1"  &
	get_claims_bnc "$processing_file" "B2"  &
	get_claims_bnc "$processing_file" "B3"  &

	wait

	echo "Output file generation complete."

			;;
		"date")
			echo "File is a date list"
			echo "Extracting raw claims data."
			extract_claims_data "$filetype" "${processing_file}"
			get_claims_date "$processing_file"
		
			;;
		"raw2batch")
			echo "File is a raw to batch list"
			raw2batch "$processing_file"
		
			;;
		"batch2raw")
			echo "File is a batch to raw list"
			batch2raw "$processing_file"
		
			;;
		*)
			echo "Invalid file type."
			echo -e "Invalid file type provided.\nFirst line of file must be one of the following:\nbnc - indicates a list of batch and claim numbers to retrieve\ndate - Get all claims for list of dates.\nraw2batch - Convert a list of NCPDP claims to the NCPDP Batch format.\nbatch2raw - Convert a list of NCPDP Batch format claims to raw claim format" >"${PROCESSING_DIR}/${filename}.error.txt"
			;;

	esac
	

# Package up the output data

	unix2dos "${readme_file}"

	echo "Packaging up data files"
	generate_output_file "$basefilename" "$PROCESSING_DIR" "$udir"

	rm -f "$processing_file"

IFS="$CR"


done

