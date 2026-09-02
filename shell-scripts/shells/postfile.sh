#!/bin/sh

## POST file to server
# version 1.0

# How long to wait to make a connection with CURL.
CONNECT_TIMEOUT="5"

# How long CURL operation will wait before aborting
TRANSMIT_TIMEOUT="30"

ARCHIVE_DIR="$3"

usage(){
echo "postfile.sh url file [archive_path]"
echo "Files are only archived if archive_path is specified"
exit 1
}


archive_file()
{
archive_name="$1"

if [ "$ARCHIVE_DIR" == "" ]
then
	rm -f "$archive_name"
	return
fi

if [ ! -d "$ARCHIVE_DIR" ]
then
	echo "Archive directory $ARCHIVE_DIR does not exist."
else
	mv $archive_name $ARCHIVE_DIR
fi
}



url="$1"
file="$2"



if [ "$url" == "" ]
then
	usage
	exit 1
fi

if [ "$file" == "" ]
then
	usage
	exit 1
fi


if [ ! -r "$file" ]
then
	echo "Unable to open '$file'"
	exit 1
fi

echo "Processing file $file"

http_code=`curl -s -w "%{http_code}" -X POST -H "Content-Type: application/json" --connect-timeout ${CONNECT_TIMEOUT} --max-time ${TRANSMIT_TIMEOUT} --data-binary @${file} $url`
retval="$?"

if [ "$retval" -ne "0" -o "$http_code" -ne "200" ]
then
	echo "Error procesing file $file"	
	echo "Return code: $retval"
	echo "HTTP code: $http_code"
else

	archive_file $file

fi



exit 0
