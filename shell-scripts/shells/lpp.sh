#!/bin/ksh
#
# Program Name	: lpp.sh
# Description	: Check for file existence before printing
# Author	: Anthony DePinto
# Date		: 10-7-97
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: lpp.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

if [ "$#" -eq 1 ]
then
  if test -f $1 
  then
    echo "`lp -o nobanner $1`"
    exit 0
  else
    echo
    echo "-*> File name : $1, does not exist."
    echo 
  fi
else
  echo   
  echo "-*> No file name specified"
  echo
fi

exit 1
