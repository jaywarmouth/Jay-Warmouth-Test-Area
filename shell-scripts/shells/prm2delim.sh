#!/bin/sh


usage()
{
	echo "USAGE: prm2delim filename"

}


#
# MAIN
# 	Converts PRM files to pipe delimited
#	Steve Randlett 2/8/05
#


LBIN="/usr/local/bin"
OIFS="$IFS"
CR="
"

infile="$1"

if [ "$infile" = "" ] 
then
	usage
	exit 1
fi

IFS="$CR"

for line in `cat $infile`
do
	counter="1"
	total_lines=`echo $line|cut -c 1-1`

	while [ "$counter" -le "$total_lines" ]
	do

		echo $line | cut -c 2- | ${LBIN}/char_repl 13 -1 | ${LBIN}/fix2delim -sb 124 -1 /usr/local/pub/prm2delim.f2d


		counter=`expr $counter + 1`
	done



done

