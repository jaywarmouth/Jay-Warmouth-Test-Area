#!/bin/sh


USERNAME=""
RANDOM_PASSWORD=""
LOCK_USER="0"
MESSAGE="Success"

USERLIST="/usr/local/pub/vision_pwreset.users"

check_valid_user()
{
usercount=`grep -c -w "$1" ${USERLIST}`

if [ "$usercount" -ge "1" ]
then
	echo "1"
else
	echo "0"
fi

}

usage()
{
echo "USAGE: vision_pwreset [-l] login_id"
echo "-l - lock password"
exit 1

}

lock_user()
{
	passwd -l "$USERNAME"
	if [ "$?" -ne "0" ]
	then
		MESSAGE="Error locking password"
		RANDOM_PASSWORD=""
	else
		RANDOM_PASSWORD="*LOCKED*"
	fi
}

set_password()
{
	RANDOM_PASSWORD=`openssl rand -base64 32 | cut -c 1-12`
	echo $RANDOM_PASSWORD | passwd --stdin "$USERNAME"
	if [ "$?" -ne "0" ]
	then
		MESSAGE="Error changing password"
		RANDOM_PASSWORD=""
	fi
}


while [ "$1" != "" ]
do

        case "$1" in
                '-l')
                        LOCK_USER="1"
                        ;;
                *)
			if [ "$USERNAME" = "" ]
			then
				USERNAME="$1"
			else
                        	usage
				exit 1
			fi

        esac

        shift
done

if [ "$USERNAME" = "" ]
then
	echo -n "Enter login to reset: "
	read USERNAME
fi

valid_flag=`check_valid_user "$USERNAME"`

if [ "$valid_flag" -eq "0" ]
then
	MESSAGE="User '${USERNAME}' is not allowed to be changed"
	RANDOM_PASSWORD=""
else
	
	if [ "$LOCK_USER" -eq "1" ]
	then
		lock_user
	else
		set_password
	fi

fi

echo "Message: $MESSAGE"
echo "Username: ${USERNAME}"
echo "Password: ${RANDOM_PASSWORD}"

echo "Press ENTER to continue"
read junk

