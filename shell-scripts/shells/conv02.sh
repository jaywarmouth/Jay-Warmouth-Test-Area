#!/bin/ksh
#
# Program Name	: conv02.sh 
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
CARDH00MAS=/usr/pdm/wrk/CARDH00MAS.hstn_conv
CAWRK00MAS=/usr/pdm/wrk/CAWRK00MAS.hstn_conv
export CATAB00MAS CAWRK00MAS CARDH00MAS

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conv02.sh

ENDOFUSAGE
  exit 1
}

# Submit conv02 program
submit_conv02()
{
      runcobol conv02
}

#
# Main routine
#

proc_audit conv02.sh SHELL 1 "Conversion Process"

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   RUNPATH=$RUNPATH"
echo "   CATAB00MAS=$CATAB00MAS"
echo "   CARDH00MAS=$CARDH00MAS"
echo "   CAWRK00MAS=$CAWRK00MAS"
submit_conv02  
date

proc_audit conv02.sh SHELL 0 "Conversion Process"
exit 0
