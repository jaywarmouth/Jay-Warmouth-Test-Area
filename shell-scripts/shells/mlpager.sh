#!/bin/ksh
#
# Program Name	: mlpager.sh
# Description	: Mlink Pager launcher
# Author	: Anthony DePinto
# Date		: 11-29-96
# Modifications :
#
# Variables Used:

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mlpager.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

PATH=/usr/local/mlink:.:/usr/bin:/usr/sbin
MLINK=/usr/local/mlink; export MLINK

mlclear -f term/s31
nohup mlink -o s31 pager 100 > /tmp/pager.out &

exit 0
