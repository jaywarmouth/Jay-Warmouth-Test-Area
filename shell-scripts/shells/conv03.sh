#!/bin/ksh
#
# Program Name	: conv03.sh 
# Description   : Conversion Process
#                 Command line arguments:
#                 -c Claims conversion only
#                 -e Enter cardholder to convert
# Author	: Kim Konyshak
# Date		: 08/09/96
# Modifications : 
#
# Variables Used:
RUNPATH=/usr/pdm/claims:/usr/pdm/tmp:/usr/pdm/tmp2
export RUNPATH 
CATWK00MAS=/usr/pdm/wrk/CATAB00MAS.hstn    
CAWRK00MAS=/usr/pdm/wrk/CAWRK00MAS.hstn_conv_del_1
AUDIT00CONV=/usr/pdm/data_08/AUDIT00CONV.hstn_conv
export CATWK00MAS CAWRK00MAS AUDIT00CONV
CLAIM_ONLY=0
ENTER_CARDHOLDER=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conv03.sh [-c] [-e]

ENDOFUSAGE
  exit 1
}

# Submit conv03 program
submit_conv03()
{
   if [ ${CLAIM_ONLY} = 1 ]
     then
        runcobol conv03 -s 1${ENTER_CARDHOLDER}
     else
        runcobol conv03 -s 0${ENTER_CARDHOLDER}
   fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) CLAIM_ONLY=1
        ;;
    -e) ENTER_CARDHOLDER=1
        ::
  esac
  shift
done

proc_audit conv03.sh SHELL 1 "Conversion Process"

echo Conversion Process
date
echo "EXPORT PATHS:"
echo "   RUNPATH=$RUNPATH"
echo "   CATWK00MAS=$CATWK00MAS"
echo "   CAWRK00MAS=$CAWRK00MAS"
echo "   AUDIT00CONV=$AUDIT00CONV"
submit_conv03  
date

proc_audit conv03.sh SHELL 0 "Conversion Process"
exit 0
