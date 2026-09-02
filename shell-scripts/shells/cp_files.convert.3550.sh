#!/bin/ksh
#
# Program Name  : cp_files.convert..3550.sh
# Description   : Copies Flexgen *COB files from 3525 convert/flexgen to 3550 /usr/pdm/flexgen
# Author        : Linda S. Jefferis
# Date          : 10/06/98
# Modifications :
#
# Variables Used:
REMOTE="pdm01"
DEST="/usr/pdm/"
FROM="/usr/convert/"
HOSTNAME=`/usr/ucb/hostname`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_files.convert.3550.sh `cat <filesname>`

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
   rcp ${REMOTE}:${FROM}$file ${DEST}$file".tmp"
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
