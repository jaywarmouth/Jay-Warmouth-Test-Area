#!/bin/sh

TMPFILE="/tmp/list_user.$$"

OIFS="$IFS"
CR="
"



#cat /etc/passwd | cut -d : -f 1,3 | awk -F: '{system("passwd -S " $1) }' | awk '{ print $1 "," $2 }' > "$TMPFILE"


#awk -F, '{ print $1 "," $2 system("grep ^" $1 " /etc/passwd") }' "$TMPFILE"

IFS="$CR"


echo "Login:UserID:GroupID:Name:Password Status"
for line in `cat /etc/passwd`
do
IFS="$OIFS"
	login="`echo $line | cut -d : -f 1`"
	userid="`echo $line | cut -d : -f 3`"
	groupid="`echo $line | cut -d : -f 4`"
	name="`echo $line | cut -d : -f 5`"
	

	pwstatus=`passwd -S $login | awk '{ print $2 }'`
	echo "$login:$userid:$groupid:$name:$pwstatus"




IFS="$CR"
done

rm -f "$TMPFILE"
