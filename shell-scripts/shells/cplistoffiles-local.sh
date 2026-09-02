#!/bin/ksh
#
# Program Name  : cplistoffiles-local.sh
# Description   : Copies list of files from indicated directory to indicated directory.
# Author        : Linda S. Jefferis
# Date          : 06/09/2013
#
# Variables Used:
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{ 
	echo ""
	echo "USAGE:"
	echo "cplistoffiles-local.sh fromdir todir filelistname"
	echo " e.g."
	echo "     cplistoffiles.sh /usr/lnk/test /usr/lnk/flexgen/obj /usr/lnk/tmp/filelist.txt"
	echo ""
	echo "NOTE: filelist must only use CR(/n), not CRLF(/r/n) at end of each filename. Use /usr/local/char_repl to fix list if needed."
	echo ""

  exit 1
}

#
# Main routine
#
if [ $# -lt 3 ]
then
	usage
fi
REMOTEDIR=$1
LOCALDIR=$2
FILELIST=$3
echo "LOCALHOST=${HOSTNAME}"
echo "FROMDIR=$REMOTEDIR"
echo "TODIR=$LOCALDIR"
echo "FILELIST=$FILELIST"

date
for file in `cat $FILELIST`
do
   echo "cp $REMOTEDIR/$file $LOCALDIR"
   cp $REMOTEDIR/$file $LOCALDIR
   if test $? -eq 0
   then
      echo "$file copy complete"
   else
      echo "ERROR - $file not copied"
   fi
done
date
