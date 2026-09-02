#!/bin/sh

usage() {
cat <<-USAGEINFO
USAGE: sendmailfile.sh filename
The file specified must have the following layout:

TO:user1@someaddress.com [user2@someaddress.com ...]
FROM:name <fromaddress@pdmi.com>
SUBJECT:My Subject 
CC:user1@someaddress.com  [user2@someaddress.com ...]
BCC:user1@someaddress.com [user2@someaddress.com ...]
ATTACHMENTS:/path/file1 [/path/file2 ...]
.
This is my message


The FROM, SUBJECT, CC, BCC, and ATTACHMENTS directives are optional and
can be omitted.   A single period on a line seperates the directives from
the message.  The TO, CC, BCC and ATTACHMENTS directives can take multiple
parameters seperated by a space.  For example TO:steve@pdmi.com linda@pdmi.com
would email both steve and linda.

If FROM is omitted it will use the traditional "No Reply <no-reply@pdmi.com>" 
as the from address.
USAGEINFO




}

gen_subject()
{
data="$1"

	echo -n "${data}"
}

gen_cc()
{
data="$1"

for l in `echo $data`
do
	echo -n "-c $l "
done
}
gen_bcc()
{
data="$1"

for l in `echo $data`
do
	echo -n "-b $l "
done
#echo $data | awk '{ for (i=1; i<= NF; i++) print "-b " $i }'
}
gen_attachments()
{
data="$1"
for l in `echo $data`
do
	echo -n "-a $l "
done

#echo $data | awk '{ for (i=1; i<= NF; i++) print "-a " $i }'
}

#
# MAIN
#

#set -x

#Default from
FROM="No Reply <no-reply@pdmi.com>"
SUBJECT="<no subject specified>"
ATTACHMENTS=""
MESSAGE=""
OIFS="$IFS"
CR="
"
TMPMAILFILE="/tmp/sendmailfile.tmp.$$"
UPPERCMD="/usr/bin/tr [:lower:] [:upper:]"

trap 'rm -f $TMPMAILFILE' 0

MAILFILE="$1"

if [ "$MAILFILE" = "" ]
then
	echo "No mail file specified"
	echo " "
	usage
	exit 1
fi

if [ ! -r "$MAILFILE" ]
then
	echo "Mail file $MAILFILE could not be read."
	exit 1
fi

# Get header info
IFS="$CR"
for line in `cat $MAILFILE`
do
	IFS="$OIFS"

	if [ "$line" = "." ]
	then
		break
	fi

	cmd=`echo $line | awk -F: '{ print $1 }'|${UPPERCMD}`
	params=`echo $line | awk -F: '{ print $2 }'`

#	echo $cmd - $params

	case $cmd in
		"TO")
			TO="$params"
			;;
		"FROM")
			if [ "$params" != "" ]
			then
				FROM="$params"
			fi
			;;
		"SUBJECT")
			if [ "$params" != "" ]
			then
				SUBJECT="$params"
			fi
			;;
		"CC")
			CC="$params"
			;;
		"BCC")
			BCC="$params"
			;;
		"ATTACHMENTS")
			ATTACHMENTS="$params"
			;;
		*)
			echo "Invalid command"
			exit 1
			;;
	esac


	
IFS="$CR"
done

	IFS="$OIFS"

	echo "To:          $TO"
	echo "From:        $FROM"
	echo "Subject:     $SUBJECT"
	echo "CC:          $CC"
	echo "BCC:         $BCC"
	echo "Attachments: $ATTACHMENTS"


TO_PARAM="$TO"

# Pulled from enviornemnt
EMAIL=$FROM
export EMAIL

SUBJECT_PARAM=`gen_subject "$SUBJECT"`
CC_PARAM=`gen_cc "$CC"`
BCC_PARAM=`gen_bcc "$BCC"`
ATTACHMENTS_PARAM=`gen_attachments "$ATTACHMENTS"`


# Get message
IFS="$CR"
MESSAGE="0"
count="1"
for line in `cat $MAILFILE`
do
	IFS="$OIFS"

	count=`expr $count + 1`
	if [ "$line" = "." ]
	then
		break
	fi

	IFS="$CR"
done

cat $MAILFILE|sed -n ${count},\$p >$TMPMAILFILE
echo " "
echo "Message:"
echo "--------"
cat $TMPMAILFILE
echo "--------"
echo " "

cat $TMPMAILFILE | /usr/bin/mutt -s "$SUBJECT_PARAM" $CC_PARAM $BCC_PARAM $ATTACHMENTS_PARAM $TO_PARAM
retval="$?"

exit $retval
