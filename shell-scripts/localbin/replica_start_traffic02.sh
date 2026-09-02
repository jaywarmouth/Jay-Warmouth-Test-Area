#!/bin/sh

SHELL_DIR="/usr/local/bin"


#if [ "$UID" -ne "111" ] 
#then
#	echo "Must be user c04 to start traffic02!"
#	exit 1
#fi

${SHELL_DIR}/traffic02.sh -l dir
${SHELL_DIR}/traffic02.sh -l 16
${SHELL_DIR}/traffic02.sh -l 40
${SHELL_DIR}/traffic02.sh -l 10
${SHELL_DIR}/traffic02.sh -l 60
${SHELL_DIR}/traffic02.sh -l 70
${SHELL_DIR}/traffic02.sh -l 90


