#!/bin/sh


#set -x

SITE="gftp.ndchealth.com"
LOGIN="troop_pdm"
PASSWD="Make7Observe"
REMOTEDIR="inbound"

FILEDIR="/tmp/ndctroop"

TMPFILE="/tmp/sftp-ndc.$$"

touch $TMPFILE
chmod 600 $TMPFILE


echo "cd $REMOTEDIR" >>$TMPFILE
echo "mput ${FILEDIR}/*">>$TMPFILE
echo "bye" >>$TMPFILE

sftp -b $TMPFILE ${LOGIN}@${SITE} 
RETVAL="$?"

if [ "$RETVAL" -ne "0" ]
then
	echo "Error during transfer."
	exit 1
fi

rm -f $TMPFILE
rm -f ${FILEDIR}/*

exit 0

