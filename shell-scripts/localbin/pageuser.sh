#!/bin/sh

# TARGET is the list of users/email addresses page.  
# Format of TARGET is name:email_address

#TARGET="steve:3307195111@txt.att.net linda:3305191185@messaging.sprintpcs.com doug:3305197230@messaging.sprintpcs.com kathy:3305012006@tmomail.net jeff:3305062716@txt.att.net,7246744367@vtext.com"
TARGET="steve:3307195111@txt.att.net linda:7246744367@vtext.com doug:3305197230@messaging.sprintpcs.com jeff:3305062716@txt.att.net justin:Hbk534@gmail.com alerts:alerts@pdmi.com ops:operatorpage@pdmi.com"

display_users()
{
	for line in `echo $TARGET`
	do
		name=`echo $line | awk -F: '{ print $1 }'`	
		echo -e "\t$name"
	done
}

usage()
{
	echo -e "USAGE: $PROGNAME \"subject\" \"message\" username [username username ...]"
	echo "Valid usernames: "
	display_users
	echo -e "\tall - pages everyone in above list"
}

page_user()
{
email="$1"
subj="$2"
msg="$3"
cdate=`date "+%D %I:%M%p"`

tmpoutmsg="${msg} Sent: $cdate"

	
	echo $tmpoutmsg | /bin/mail -s "$subj" $email
	echo "$cdate: To: $email Subject: $subj Msg: $tmpoutmsg" >>/tmp/.pages.txt

}

####################
#
#	MAIN
#
####################

# Get name from command line and capitalize it.

PROGNAME="$0"


if [ "$3" = "" ]
then
	usage
	exit 1
fi

subject="$1"
shift
outmsg="$1"
shift
pusers=$*


echo "Subject: $subject"
echo "Message: $outmsg"
for puser in `echo $pusers`
do
	upuser=`echo $puser | /usr/bin/tr "[:lower:]" "[:upper:]"`
	found="0"
	for line in `echo $TARGET`
	do
		name=`echo $line | awk -F: '{ print $1 }'`	
		uname=`echo $name | /usr/bin/tr "[:lower:]" "[:upper:]"`
	
		email=`echo $line | awk -F: '{ print $2 }'`	
		
		if [ "$upuser" = "$uname" -o "$upuser" = "ALL" ]
		then
			found="1"

			page_user "$email" "$subject" "$outmsg"
			echo "Sending page to $name"
		fi

	done

	if [ "$found" -eq "0" ]
	then

		echo "$puser not valid user"

	fi

done

exit $PRETVAL
