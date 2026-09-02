#!/bin/bash

# delete users provided in a single line per user .txt file

# File containing usernames (one per line)
USER_FILE="$1"

# Basic checks
if [[ -z "$USER_FILE" ]]; then
  echo "Usage: $0 <user_file>"
  exit 1
fi

if [[ ! -f "$USER_FILE" ]]; then
  echo "Error: File '$USER_FILE' not found."
  exit 1
fi

# Loop through each line in the file
while IFS= read -r username; do
  # Skip empty lines or comments
  [[ -z "$username" || "$username" =~ ^# ]] && continue

  if id "$username" &>/dev/null; then
    echo "Deleting user: $username"
    userdel -r "$username"
  else
    echo "User '$username' does not exist. Skipping."
  fi
done < "$USER_FILE"

echo "Done."
