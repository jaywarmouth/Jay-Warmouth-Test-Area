#!/bin/ksh
#
# Program Name	: claim99grp.sh
# Description   : Pulls claims by CARDH09KEY and checks the 
#                 group to be equal to "BIN".
# Author	: Christina Senediak
# Date		: 04/25/96
# Modifications :
#
# Variables Used:
RUNPATH=claims:tmp:tmp2
CLWRK00MAS=backup/CLWRK00MAS.21bin
export RUNPATH CLWRK00MAS

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim99grp.sh

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
proc_audit claim99grp.sh SHELL 1 "Pulls claims by CARDH09KEY"

echo Pull claims to work by CARDH09KEY
date
runcobol claim99grp -s 0 
date

proc_audit claim99grp.sh SHELL 0 "Pulls claims by CARDH09KEY"
exit 0
