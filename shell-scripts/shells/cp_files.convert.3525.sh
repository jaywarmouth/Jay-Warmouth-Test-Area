#!/bin/ksh
#
# Program Name  : cp_files.convert.3525.sh
# Description   : Copies flexgen COB files from /usr/convert/flexgen to /usr/pdm/flexgen.
#		  Uses filenames sent in through cat of specified file on command line.
# Author        : Linda S. Jefferis
# Date          : 10/06/98
# Modifications :
#
# Variables Used:
# Copies flexgen COB files from /usr/convert/flexgen to /usr/pdm/flexgen.
# Uses filenames sent in through cat of specified file on command line.
#
REMOTE="pdm01"
DEST="/usr/pdm/"
FROM="/usr/convert/"
HOSTNAME=`/usr/ucb/hostname`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_files.convert.3525.sh `cat <filesname>`

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
echo "HOSTNAME=${HOSTNAME}"
echo ""

date
for file do
   umask 002
   cp ${FROM}$file ${DEST}$file".tmp"
   if test $? -eq 0
   then
      mv ${DEST}$file".tmp" ${DEST}$file
      echo "$file copy complete"
   else
      rm ${DEST}$file".tmp"
      echo "ERROR - $file not copied"
   fi
done
date
