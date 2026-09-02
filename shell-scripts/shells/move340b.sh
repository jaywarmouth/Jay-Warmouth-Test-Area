#!/bin/sh

#
# move340b.sh - scans directories in SCANFILE and emails accordingly
# file must be unmodified for at least a minute before it will be checked
# This should prevent multiple emails on large uploads
#

#set -x

# VERSION 1.1

logmsg()
{
msg="$1"
timestamp=`date "+%D %T"`


	if [ ! -f "$LOGFILE" ]
	then
		echo "DATE     TIME     [RUNID] CONFIG.REFID:  MESSAGE">$LOGFILE
	fi

	echo -e "$timestamp [$$] $REFID: $msg">>$LOGFILE


}

copyfile()
{
source="$1"

# copy for MacroHelix
logmsg "Copy $source to $MHDIR"
cp $source $MHDIR

# copy for data services
logmsg "Copy $source to $DSDIR"
cp $source $DSDIR

}


archivefile()
{
source="$1"

mydate=`date "+%Y%m%d%H%M%S"`
archivefile="${source}.${mydate}.gz"
logmsg "Archiving $source to $archivefile"
gzip -c ${source} >$archivefile
rm -f ${source}
mv "${archivefile}" ${ARCHIVEDIR}

}

is_newfile()
{
RID="$1"
key="$2"
isnew="1"

	touch $RID
	retdata=`grep $key $RID`

	if [ "$retdata" != "" ]
	then
		isnew="0"
	fi

	return $isnew
}

#
# MAIN
#

MHDIR="/tmp"
DSDIR="/media/clientfiles/340bData/Incoming"
ARCHIVEDIR="/usr/local/pub/move340b/archive"
SCANPATH="/usr/local/pub/move340b"
CONFIGPATH="${SCANPATH}/conf"
LOGFILE="${SCANPATH}/log/move340b.log"
TMPFILE="/tmp/move340b.$$"
TMPFIND="/tmp/move340b_find.$$"
SCANDATAPATH="${SCANPATH}/data"
OIFS="$IFS"
CR="
"

mkdir -p ${SCANPATH} >/dev/null 2>&1
mkdir -p ${SCANDATAPATH} >/dev/null 2>&1
mkdir -p ${CONFIGPATH} >/dev/null 2>&1
mkdir -p ${SCANPATH}/log >/dev/null 2>&1
mkdir -p ${ARCHIVEDIR}/log >/dev/null 2>&1

if [ "$1" = "" ]
then
	echo "USAGE: move340b.sh config_file"
	echo "config_file must be located in $CONFIGPATH"
	logmsg "Config file must be specified."
	exit 1
fi

CONFIGID="$1"


SCANFILE="${CONFIGPATH}/${CONFIGID}"


chmod 755 ${SCANPATH}
chmod 755 ${SCANDATAPATH}

if [ ! -f "$SCANFILE" ]
then
	echo "# used by move340b.sh" >$SCANFILE
	echo "# Format:" >>$SCANFILE
	echo "# ID_Number:directory:recurse" >>$SCANFILE
	echo "# Example: " >>$SCANFILE
	echo "# 1:/usr/local/pub:1" >>$SCANFILE
	echo "# If recurse is 1 then sub-directories will be checked" >>$SCANFILE
	echo "# ID_Number can be any alpha/numeric identifier (no special characters or spaces)" >>$SCANFILE
	echo "# ID_Number MUST be unique" >>$SCANFILE
	echo "#">>$SCANFILE
	echo "">>$SCANFILE
	

fi

if [ ! -f "$SCANFILE" ]
then
	echo "Error, cannot read $SCANFILE"
	logmsg "Error, cannot read $SCANFILE"
	exit 1
fi

IFS="$CR"
for line in `cat $SCANFILE | grep -v "^#"`
do
	IFS="$OIFS"

	REFID=`echo $line | awk -F: '{ print $1 }'`
	REFID="$CONFIGID.$REFID"
	DIRPATH=`echo $line | awk -F: '{ print $2 }'`
	RECURSE=`echo $line | awk -F: '{ print $3 }'`

	rm -f $TMPFILE

	if [ "$RECURSE" = "1" ]
	then
		FINDOPTS="-mmin +1 -type f -print"
	else
		FINDOPTS="-maxdepth 1 -mmin +1 -type f -print"
	fi

	NEWFILES="0"


	find $DIRPATH $FINDOPTS >$TMPFIND
	IFS="$CR"
	for filename in `cat $TMPFIND`
	do
		IFS="$OIFS"
		finfo=`ls -l  --time-style="+%s" "$filename"`
		fsize=`echo $finfo | awk '{ print $5 }'`
		ftime=`echo $finfo | awk '{ print $6 }'`
		keyvalue="${filename}_${fsize}_${ftime}"


#		is_newfile ${SCANDATAPATH}/${REFID} $keyvalue
#		chkreturn="$?"

#		echo $keyvalue >>$TMPFILE

#		if [ "$chkreturn" -eq "1" ]
#		then
			copyfile "$filename"
			archivefile "$filename"

#		fi
		IFS="$CR"
	done
	IFS="$OIFS"
	rm -f $TMPFIND

	if [ -f "$TMPFILE" ]
	then
		mv $TMPFILE ${SCANDATAPATH}/${REFID}
	fi
#	cat $EMAILFILE

	IFS="$CR"

done


