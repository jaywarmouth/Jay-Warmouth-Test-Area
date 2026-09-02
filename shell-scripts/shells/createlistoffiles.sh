#!/bin/ksh
#
# Program Name  : createlistoffiles.sh
# Description   : Creates list of files by comparing file names from input filelist to files in indicated directory. 
# Author        : Linda S. Jefferis
# Date          : 09/16/2013
#
# Variables Used:
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{ 
	echo ""
	echo "USAGE:"
	echo "createlistoffiles.sh localdir filelistname outfilelist"
	echo " e.g."
	echo "     createlistoffiles.sh /usr/lnk/flexgen_tst/obj /usr/lnk/tmp/filelist.txt /usr/lnk/tmp/outfilelist.txt"
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
LOCALDIR=$1
FILELIST=$2
OUTFILELIST=$3
echo "LOCALHOST=${HOSTNAME}"
echo "LOCALDIR=$LOCALDIR"
echo "FILELIST=$FILELIST"
echo "OUTFILELIST=$OUTFILELIST"

date
for file in `cat $FILELIST`
do
   #echo "scp $REMOTESYS:$REMOTEDIR/$file $LOCALDIR"
   if test -e ${LOCALDIR}/$file
   then
	echo "The file name, $file, has been added to list"
	echo "$file" >> ${OUTFILELIST}
   else
	echo "The file name, $file, is not in $LOCALDIR"
   fi
done
date
