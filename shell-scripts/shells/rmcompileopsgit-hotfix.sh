#!/bin/bash
#
# Script for compiling Development source code from SCM  
# Version 1.1 - Changed COB_DIR and added L option on rmcobol command
#
#Modifications	: 11/07/2013 - Set input Numbers for suorcename and Project (DME)
#		: 11/07/2013 - Modify input check so it checks for 2 variables (DME)
#		: 03/17/2014 - Changed ShadowProduction references to ShadowDevelopment
#		: 2021-03-25 - SRR: Updated to handle git repository compiles





usage()
{
	echo "USAGE:"
	echo "$0 -c|-n|-a sourcefile"
	echo "-c = use CPY directory for copybooks"
	echo "-n = use NEWCPY directory for copybooks"
	echo "-a = Auto select copybooks"
}


#
# Main routine
#


if [ $# -lt 2 ]
then
        usage
        exit 1
fi

cpyflag="$1"
sourcename="$2"


sourcedir=`dirname "$sourcename"`
if [ "$sourcedir" != "." ]
then
	echo "$sourcename cannot contain a path."  
	echo "You must be in the directory which contains the source code."	
	exit 1
fi

flagfile="/usr/lnk/COBOL_GIT/CTYPE/COBOL Compile Type.csv"


if [ "$cpyflag" == "-a" ]
then
	nameonly=`basename $sourcename .cbl`
	nameonly=`basename $nameonly .CBL`

	flagvalue="UNKNOWN"

	if [ ! -f "$flagfile" ]
	then
		echo "Unable to locate config file $flagfile"
		exit 1
	fi

	while IFS="," read -r name flag extra; do
	#	echo $name $flag
		if [ "$name" == "$nameonly" ]
		then
			flagvalue="$flag"
			break
		fi
	done < "$flagfile"

	if [ "$flagvalue" == "Y" ]
	then
		cpyflag="-n"
	elif [ "$flagvalue" == "N" ]
	then
		cpyflag="-c"
	else
		echo "Unable to locate copybook flag for $nameonly in $flagfile"
		exit 1	
	fi
fi	





if [ "$cpyflag" == "-n" ]
then

copybook="NEWCPY"
#RMPATH="`pwd`:~/cobol_git/NEWCPY:~/cobol_git/DES:/var/www/html/xbis/common:/usr/rmcobol"
RMPATH="/usr/lnk/COBOL_GIT/CBL_BATCH:/usr/lnk/COBOL_GIT/NEWCPY:/usr/lnk/COBOL_GIT/DES:/var/www/html/xbis/common:/usr/rmcobol"


elif [ "$cpyflag" == "-c" ]
then

copybook="CPY"

#RMPATH="`pwd`:~/cobol_git/CPY:~/cobol_git/DES:/var/www/html/xbis/common:/usr/rmcobol"
RMPATH="/usr/lnk/COBOL_GIT/CBL_BATCH:/usr/lnk/COBOL_GIT/CPY:/usr/lnk/COBOL_GIT/DES:/var/www/html/xbis/common:/usr/rmcobol"

else

	usage
	exit 1

fi

export RMPATH
COB_DIR=/usr/lnk/git/rmcob


echo "User: $USER"
echo "Source: $sourcename"
echo "CopyBook: $copybook"
echo "RM Compile Path: $RMPATH"
echo " "

rmcobol $sourcename O=$COB_DIR L=$COB_DIR
if test -e ${COB_DIR}/$nameonly.COB
then
	mv -f ${COB_DIR}/$nameonly.COB ${COB_DIR}/$nameonly.cob
fi
if test -e ${COB_DIR}/$nameonly.LST
then
	mv -f ${COB_DIR}/$nameonly.LST ${COB_DIR}/$nameonly.lst
fi

exit 0
