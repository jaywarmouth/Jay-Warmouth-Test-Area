#!/bin/sh
#
# Program Name	: range_clrmsg.sh
# Description	: runs "clrmsg" on all queue numbers within range indicated on the command line.
# Author	: Linda Jefferis
# Date		: 08/21/2013
#
# Variables Used:

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: range_clrmsg.sh start_queue# end_queue#

ENDOFUSAGE
  exit 1
}


#
# Main routine
#
if [ $# -lt 2 ]
then
        usage
        exit 1
fi

START=$1
END=$2

i=$START
max=$END
while [ $i -le $max ]
do
	echo "--> Clearing Queue # $i"
	/usr/local/bin/clrmsg $i
	let i=i+1
done

exit 0
