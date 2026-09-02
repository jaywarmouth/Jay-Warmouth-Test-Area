#!/bin/sh
#
#
# Shell for listing /usr/local/pub/835_transfer.cfg
# VERSION 1.0

CONFIG_FILE="/usr/local/pub/835_transfer.cfg"
TMPFILE="/tmp/835_transfer_list"
CR="
"
OIFS="$IFS"



list_ids() 
{

	/bin/echo -e "ID\t\tChain List"
	IFS="$CR"
	for line in `cat $CONFIG_FILE | grep -v "^#"`
	do
		fchains=`echo $line | awk -F\: '{ print $8 }'`		
		fcname=`echo $line | awk -F\: '{ print $2 }'`		
		fid=`echo $line | awk -F\: '{ print $1 }'`		

		/bin/echo -e "\n${fid}\t${fchains}\c" >>$TMPFILE

	done
	cat $TMPFILE | /bin/sort

}

usage()
{
	echo "USAGE:"
	echo "835_transfer_list.sh -l"
	echo  "-l  	- list available IDs"
	echo " "
	echo "Config file located at $CONFIG_FILE"

}

#
# MAIN
#

INTERACTIVE="0"



if [ ! -r "$CONFIG_FILE" ]
then
	echo "Config file $CONFIG_FILE could not be read!"
	exit 1
fi

CR="
"
OIFS="$IFS"



# touch $TMPFILE
# chmod 600 $TMPFILE

if [ "$1" = "-l" ]
then

	list_ids
else
	usage
fi 

rm $TMPFILE

exit 0

