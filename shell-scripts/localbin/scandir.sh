#!/bin/sh

#
# scandir.sh - scans directories in SCANFILE and emails accordingly
# file must be unmodified for at least a minute before it will be checked
# This should prevent multiple emails on large uploads
#

#set -x

# VERSION 2.0

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

send_mail()
{
to="$1"
sub="$2"
filename="$3"


	cat $filename | /bin/mutt -s "$sub" $to

	logmsg "Mail \"$sub\" sent to $to"


}


is_newfile()
{
#set -x
RID="$1"

# replace [ with \[ and ] with \]
key=`echo "$2" | sed -e "s/\[/\\\\\[/g" | sed -e "s/\]/\\\\\]/g"`
isnew="1"

	touch $RID
	retdata=`grep $key $RID`

	if [ "$retdata" != "" ]
	then
		isnew="0"
	fi

#set +x
	return $isnew
}

#
# MAIN
#

SCANPATH="/usr/local/etc/scandir"
CONFIGPATH="${SCANPATH}/conf"
LOGFILE="${SCANPATH}/log/scandir.log"
TMPFILE="/tmp/scandir.$$"
TMPFIND="/tmp/scandir_find.$$"
EMAILFILE="/tmp/scandir_email.$$"
SCANDATAPATH="${SCANPATH}/data"
OIFS="$IFS"
CR="
"

mkdir -p ${SCANPATH} >/dev/null 2>&1
mkdir -p ${SCANDATAPATH} >/dev/null 2>&1
mkdir -p ${CONFIGPATH} >/dev/null 2>&1
mkdir -p ${SCANPATH}/log >/dev/null 2>&1

if [ "$1" = "" ]
then
	echo "USAGE: scandir.sh config_file"
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
	echo "# used by scandir.sh" >$SCANFILE
	echo "# Format:" >>$SCANFILE
	echo "# ID_Number:directory:recurse:email subject:email,email,email..." >>$SCANFILE
	echo "# Example: " >>$SCANFILE
	echo "# 1:/usr/local/pub:1:pub update:operator@pdmi.com " >>$SCANFILE
	echo "# This would notify operator@pdmi.com of any changes to files in /usr/local/pub" >>$SCANFILE
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
	SUBJECT=`echo $line | awk -F: '{ print $4 }'`
	EMAILTO=`echo $line | awk -F: '{ print $5 }'`

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


		is_newfile ${SCANDATAPATH}/${REFID} $keyvalue
		chkreturn="$?"

		echo $keyvalue >>$TMPFILE

		if [ "$chkreturn" -eq "1" ]
		then
			if [ "$NEWFILES" -eq "0" ]
			then
				NEWFILES="1"
				echo "New files have been found.">$EMAILFILE
			fi
			ls -l "$filename" >> $EMAILFILE

			logmsg "New file $filename."

		fi
		IFS="$CR"
	done
	IFS="$OIFS"
	rm -f $TMPFIND

	if [ -f "$TMPFILE" ]
	then
		mv $TMPFILE ${SCANDATAPATH}/${REFID}
	fi
	if [ "$NEWFILES" -eq "1" ]
	then
		send_mail "$EMAILTO" "$SUBJECT" "$EMAILFILE"

	fi
#	cat $EMAILFILE
	rm -f $EMAILFILE

	IFS="$CR"

done


