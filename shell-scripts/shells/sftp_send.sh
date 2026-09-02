#!/bin/sh


#set -x

list_ids() 
{

	/bin/echo -e "ID\tName"
	IFS="$CR"
	for line in `cat $CONFIG_FILE | grep -v "^#"`
	do
		IFS="$OIFS"
		fcname=`echo $line | awk -F: '{ print $2 }'`		
		fid=`echo $line | awk -F: '{ print $1 }'`		

		/bin/echo -e "${fid}\t${fcname}" >>$TMPFILE

	done
	cat $TMPFILE | /bin/sort

}

usage()
{
	echo "$0 -l|id filename"
	echo  "-l  	- list available IDs"
	echo  "id  	- ID to send to"
	echo  "filename - file to send."

}

#
# MAIN
#
# Version 1.1

CONFIG_FILE="/usr/local/pub/sftp_send.cfg"
SCP_CMD="/usr/bin/scp"


if [ ! -r "$CONFIG_FILE" ]
then
	echo "Config file $CONFIG_FILE could not be read!"
	exit 1
fi

CR="
"
OIFS="$IFS"

TMPFILE="/tmp/sftp_send.$$"

trap 'rm -f $TMPFILE' 0


# touch $TMPFILE
# chmod 600 $TMPFILE

if [ "$1" = "-l" ]
then

	list_ids
	exit 0
fi 

if [ "$2" = "" ]
then
	usage
	exit 1
fi

ID="$1"
shift
sourcefile="$*"

if [ "$USER" != "operator" ]
then
	echo "**************"
	echo "WARNING: This program was intended to be used with the operator user."
	echo "Your mileage may vary."
	echo "**************"
fi


IFS="$CR"
FOUND="0"
for line in `cat $CONFIG_FILE | grep -v "^#"`
do
	IFS="$OIFS"
	fid=`echo $line | awk -F: '{ print $1 }'`		

	if [ "$ID" = "$fid" ]
	then
		FOUND="1"
		fcname=`echo $line | awk -F: '{ print $2 }'`		
		fip=`echo $line | awk -F: '{ print $3 }'`		
		flogin=`echo $line | awk -F: '{ print $4 }'`		
		fpassword=`echo $line | awk -F: '{ print $5 }'`		
		fdestdir=`echo $line | awk -F: '{ print $6 }'`		
		
		echo "Sending $sourcefile to $fcname ($ID)"
		$SCP_CMD $sourcefile ${flogin}@${fip}:${fdestdir}
		RETVAL="$?"

		if [ "$RETVAL" -ne "0" ]
			then
			echo "Error during transfer to $ID"
			exit 1
		fi

	fi

	IFS="$CR"
done

	if [ "$FOUND" -ne "1" ]
	then
		echo "ID $ID not found in database."
		exit 1
	fi



# rm -f $TMPFILE

exit 0

