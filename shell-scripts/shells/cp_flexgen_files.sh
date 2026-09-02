#!/bin/ksh
#
# Program Name  : cp_flexgen_files.sh
# Description   : Copies Flexgen *COB files from Crow flexgen/obj to /usr/lnk/flexgen/obj on system script is running on.
# Author        : Linda S. Jefferis
# Date          : 10/05/2004
# Modifications :
#
# Variables Used:
REMOTE="crow"
DEST="/usr/lnk/flexgen/obj/"
FROM="/usr/lnk/flexgen/obj/"
HOSTNAME=`/usr/ucb/hostname`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_flexgen_files.sh `cat <filename>`

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
   umask 000
   rcp ${REMOTE}:${FROM}$file.COB ${DEST}$file.COB".tmp"
   if test $? -eq 0
   then
      mv ${DEST}$file.COB".tmp" ${DEST}$file.COB
      echo "$file copy complete"
   else
      rm ${DEST}$file".tmp"
      echo "ERROR - $file not copied"
   fi
done
date
