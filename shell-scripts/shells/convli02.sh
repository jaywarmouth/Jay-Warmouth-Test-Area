#!/bin/ksh
#
# Program Name	: convli02.ts 
# Description   : Conversion Process For New Limit Format
#                 Command line arguments:
# Author	: Christina Senediak
# Date		: 09/26/96
# Modifications : 
#
# Variables Used:
RUNPATH=/usr/pdm/claims:/usr/pdm/tmp:/usr/pdm/tmp2
export RUNPATH 
LIOLD00MAS=/usr/pdm/claims/LIMIT00MAS     
LIMIT00MAS=/usr/pdm/tmp/LIMIT00NEW.0927
export LIMIT00MAS LIOLD00MAS

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convli02.sh

ENDOFUSAGE
  exit 1
}

# Submit convli02 program
submit_convli02()
{
      runcobol convli02
}

#
# Main routine
#

proc_audit convli02.sh SHELL 1 "Conversion Process For New Limit Format"

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   RUNPATH=$RUNPATH"
echo "   LIMIT00MAS=$LIMIT00MAS"
echo "   LIOLD00MAS=$LIOLD00MAS"
submit_convli02  
date

proc_audit convli02.sh SHELL 0 "Conversion Process For New Limit Format"
exit 0
