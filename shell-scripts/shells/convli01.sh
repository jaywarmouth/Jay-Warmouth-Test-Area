#!/bin/ksh
#
# Program Name	: convli01.sh 
# Description   : Conversion Process For New Limit Audit Update
#                 Command line arguments:
# Author	: Christina Senediak
# Date		: 09/27/96
# Modifications : 
#
# Variables Used:
RUNPATH=/usr/pdm/claims:/usr/pdm/tmp:/usr/pdm/tmp2
export RUNPATH 
AUDIT00MAS=/usr/pdm/tmp/AUDIT-960927.3550
LIMIT00MAS=/usr/pdm/tmp/LIMIT00NEW.0927
LIOLD00MAS=/usr/pdm/claims/LIMIT00MAS
export LIMIT00MAS AUDIT00MAS LIOLD00MAS

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convli01.sh

ENDOFUSAGE
  exit 1
}

# Submit convli01 program
submit_convli01()
{
      runcobol convli01
}

#
# Main routine
#

proc_audit convli01.sh SHELL 1 "Conversion Process For New Limit Audit Update"

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   RUNPATH=$RUNPATH"
echo "   LIMIT00MAS=$LIMIT00MAS"
echo "   AUDIT00MAS=$AUDIT00MAS"
echo "   LIOLD00MAS=$LIOLD00MAS"
submit_convli01  
date

proc_audit convli01.sh SHELL 0 "Conversion Process For New Limit Audit Update"
exit 0
