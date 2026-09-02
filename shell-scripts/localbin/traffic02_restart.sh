#!/bin/sh

SHELL_DIR="/usr/local/bin"

usage()
{
	echo "USAGE:  /usr/local/bin/traffic02_restart.sh line"
	echo "where line is all, 10, 16, 40, 60, 70, 90, or dir"
}

if [ "$1" = "" ]
then
	usage
	exit 1
fi

LINETYPE="$1"

case $LINETYPE in
        "10")   ${SHELL_DIR}/traffic02.sh -l 10 -r
                ;;
	"16")	${SHELL_DIR}/traffic02.sh -l 16 -r
		;;
	"40")	${SHELL_DIR}/traffic02.sh -l 40 -r
		;;
	"60")	${SHELL_DIR}/traffic02.sh -l 60 -r
		;;
	"70")	${SHELL_DIR}/traffic02.sh -l 70 -r
		;;
	"90")	${SHELL_DIR}/traffic02.sh -l 90 -r
		;;
	"dir")	${SHELL_DIR}/traffic02.sh -l dir -r
		;;
	"all")	${SHELL_DIR}/traffic02.sh -l dir -r
                ${SHELL_DIR}/traffic02.sh -l 10 -r
		${SHELL_DIR}/traffic02.sh -l 16 -r
		${SHELL_DIR}/traffic02.sh -l 40 -r
		${SHELL_DIR}/traffic02.sh -l 60 -r
		${SHELL_DIR}/traffic02.sh -l 70 -r
		${SHELL_DIR}/traffic02.sh -l 90 -r
		;;
	*)	usage
		;;
esac

exit 0
