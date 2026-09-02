#!/bin/bash

# Ensure script is executed by root
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script can only be executed by the 'root' user."
    exit 1
fi

# Check if three parameters are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <requestor_username> <username_to_change> <new_password>"
    exit 1
fi

requestor_username="$1"
username_to_change="$2"
new_password="$3"

date >>/tmp/reset_password.log
echo $requestor_username >>/tmp/reset_password.log
echo $username_to_change >>/tmp/reset_password.log
echo $new_password >>/tmp/reset_password.log


# Disallow changing the root password
if [ "$username_to_change" == "root" ]; then
    echo "Error: Changing the password for 'root' is not allowed."
    exit 1
fi

# Check if user's password is locked
if passwd -S "$username_to_change" | grep -q "L"; then
    echo "Error: User's password is locked. Cannot reset."
    exit 1
fi

# Check conditions: either usernames must match or follow the specified pattern

if ! id "$username_to_change" &>/dev/null; then
    echo "The user $username_to_change does not exist."
	exit 1
fi

if [ "$requestor_username" == "$username_to_change" ] || \
   [[ "$username_to_change" =~ ^[a-zA-Z]+-[0-9]+$ ]]; then
    echo "$new_password" | passwd --stdin "$username_to_change"
    if [ $? -eq 0 ]; then
        echo "Success: Password updated successfully."
	if [ -f "/usr/local/bin/unexpire.sh" ]
	then
		/usr/local/bin/unexpire.sh "$username_to_change"
	fi
    else
        echo "Error: Failed to update password."
        exit 1
    fi
else
    echo "Error: Invalid request. You do not have permissions to change the password for ${username_to_change}."
    exit 1
fi

