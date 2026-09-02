#!/bin/ksh
#
# Program Name  : cplistoffiles.sh
# Description   : Copies list of files from indicated remote system and directory to indicated directory on local system.
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
	echo "cplistoffiles.sh remotesys remotedir localdir filelistname"
	echo " e.g."
	echo "     cplistoffiles.sh robin /usr/lnk/test /usr/lnk/flexgen/obj /usr/lnk/tmp/filelist.txt"
	echo ""
	echo "NOTE: filelist must only use CR(/n), not CRLF(/r/n) at end of each filename. Use /usr/local/char_repl to fix list if needed."
	echo ""

  exit 1
}

#
# Main routine
#
if [ $# -lt 4 ]
then
	usage
fi
REMOTESYS=$1
REMOTEDIR=$2
LOCALDIR=$3
FILELIST=$4
echo "LOCALHOST=${HOSTNAME}"
echo "REMOTESYS=$REMOTESYS"
echo "REMOTEDIR=$REMOTEDIR"
echo "LOCALDIR=$LOCALDIR"
echo "FILELIST=$FILELIST"

date
for file in `cat $FILELIST`
do
   echo "scp $REMOTESYS:$REMOTEDIR/$file $LOCALDIR"
   scp $REMOTESYS:$REMOTEDIR/$file $LOCALDIR
   if test $? -eq 0
   then
      echo "$file copy complete"
   else
      echo "ERROR - $file not copied"
   fi
done
date
