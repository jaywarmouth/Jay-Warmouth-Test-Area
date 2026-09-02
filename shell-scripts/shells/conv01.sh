#!/bin/ksh
#
# Program Name	: conv01.sh 
# Description   : Conversion Process
#                 Command line arguments:
# Author	: Kim Konyshak
# Date		: 06/17/96
# Modifications : 
#
# Variables Used:
RUNPATH=/usr/pdm/claims:/usr/pdm/tmp:/usr/pdm/tmp2
export RUNPATH 
CATAB00MAS=/usr/pdm/wrk/CATAB00MAS.hstn
CAWRK00MAS=/usr/pdm/wrk/CAWRK00MAS.hstn-0808-2
export CATAB00MAS CAWRK00MAS

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conv01.sh

ENDOFUSAGE
  exit 1
}

# Submit conv01 program
submit_conv01()
{
      runcobol conv01
}

#
# Main routine
#

proc_audit conv01.sh SHELL 1 "Conversion Process"

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   RUNPATH=$RUNPATH"
echo "   CATAB00MAS=$CATAB00MAS"
echo "   CAWRK00MAS=$CAWRK00MAS"
submit_conv01  
date

proc_audit conv01.sh SHELL 0 "Conversion Process"
exit 0
