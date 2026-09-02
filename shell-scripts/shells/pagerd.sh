#!/bin/ksh
#
# Program Name	: pagerd.sh
# Description	: Pager Daemon
# Author	: Anthony DePinto
# Date		: 11-29-96
# Modifications :
#
# Variables Used:

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pagerd.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
PATH=.:/usr/bin:/usr/sbin:/usr/pdm/bin

nohup pagerd > /tmp/.pagerd.out 2>&1 &
sleep 15 
nohup mailpage >/tmp/.mailpage.out 2>&1 &

exit 0
