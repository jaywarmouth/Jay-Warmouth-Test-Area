#!/bin/sh

#
# Move sys?? to sys???? and create link
# Linda Jefferis
# 09/08/2006
#
# Version 1.1
# Modifications:

#
# Variables used:
BASE_DIR="/usr/lnk"
NEW_DIR="sys00"
SYS_LST="/usr/lnk/wrk/sys_lst"

#
# USAGE
usage()
{  cat << ENDOFUSAGE

usage: create_sys_links.sh [po | xp | fax | elig_in | elig_out]

ENDOFUSAGE
  exit 1
}

#
# Main Procedure

if [ $# -le 0 ]
then
  usage
fi

while [ $# -gt 0 ]
do
  case "$1" in
    "po" | "xp" | "fax")
	DIR="$1"
	OLD_DIR="sys"
	;;
    "elig_in" | "elig_out")
	DIR="$1"
        OLD_DIR="sys0"
	;;
     *) usage
	;;
  esac
  shift
done

for sysnum in `cat $SYS_LST`
do
	cd $BASE_DIR/$DIR
	mv $OLD_DIR$sysnum $NEW_DIR$sysnum
	ln -s $NEW_DIR$sysnum $OLD_DIR$sysnum
done

exit 0
