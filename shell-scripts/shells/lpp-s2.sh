#!/bin/ksh
#
# Program Name	: lpp.sh
# Description	: Printer extension for Suite #2 users to default to HPIIISi
# Author	: Anthony DePinto
# Date		: 8-26-96
# Modifications :
#
# Variables Used:
FORM=1

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: $0 [Filename]

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

DCC_OPTS="/usr/lpplus2/bin/dcclp -d HPIIISi -o nob "${SPOOLOPTS}

for i 
do
  case $1 in
  -d) DCC_OPTS=${DCC_OPTS}" -d "$2
      shift
      ;;
  -f) DCC_OPTS=${DCC_OPTS}" -f "$2
      FORM=0
      shift
      ;;
  *)  FILES=$*
      break 
      ;;
  esac
  if test $# -gt 0 
  then
    shift
  fi
done

#if test ${FORM} -eq 1 
#then
#  DCC_OPTS=${DCC_OPTS}" -f land"
#fi

if [ "${FILES}" ]
then
  for i in $FILES
  do
    if test -f $i
    then
      if test -s $i
      then
        DCC_CMD=${DCC_OPTS}" $i"
        $DCC_CMD 
      else
	echo "File \"$i\" has a zero length.  Not spooled"
      fi
    else
      echo "File \"$i\" not found"
    fi
  done
else
  cat - | ${DCC_OPTS} 
fi

exit 0
