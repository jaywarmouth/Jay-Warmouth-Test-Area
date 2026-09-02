#!/bin/ksh
#
# Program Name	: zip_linedrv_files.sh
# Description	: Nightly compression and removing of raw daily claims files
# Author	: Linda Jefferis
# Date		: 04/17/2007
# Modifications : 06/04/2007 - Removed logic for the env and ndc files
#		: 09/04/2007 - Added logic for "sc" (ScriptSense) CLMRT files  (LSJ)
#		: 11/24/2009 - Added remove_proc logic and logic for "mb", "ln", "lp", and "lt"
#		: 03/22/2010 - Added logic for "oh"
#		: 08/20/2011 - Changed to 8-digit 'date' for switch16 and switch40 files
#		: 08/20/2011 - Uncommented remove_proc logic
#		: 09/26/2011 - Added logic (temporarily) to remove old date formatted switch40 and switch16 files
#		: 12/29/2011 - Added logic for "rt"
#		: 9/18/2012 - Added logic for "lt"
#		: 03/26/2013 - Add logic for "if"
#		: 04/24/2013 - Add logic for "ba"
#
# Variables Used:
DAILY=/usr/lnk/daily
ZIP_PROG="/bin/gzip"

#
# Zip Process
zip_proc()
{
	find . -name "${FILE}" -mtime +7 -exec ${ZIP_PROG} {} \;
}

#
# Remove Process
remove_proc()
{
	find . -name "${FILE}.gz" -mtime +${DAYS} -exec rm {} \;
}


#
# Main routine
#

date

#cd ${DAILY}/dir
#echo "--> zipping daily/dir file"
#FILE="dir-??????"
#zip_proc

cd ${DAILY}/switch40
echo "--> zipping daily/switch40 file"
FILE="switch40-????????"
zip_proc
DAYS=180
echo "--> removing switch40 files older than ${DAYS} days"
remove_proc
FILE="switch40-11????"
remove_proc

cd ${DAILY}/switch16
echo "--> zipping daily/switch16 file"
FILE="switch16-????????"
zip_proc
DAYS=180
echo "--> removing switch16 files older than ${DAYS} days"
remove_proc
FILE="switch16-11????"
remove_proc

cd ${DAILY}/mb
echo "--> zipping daily/mb file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/mb files older than ${DAYS} days"
remove_proc

cd ${DAILY}/ar
echo "--> zipping daily/ar file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/ar files older than ${DAYS} days"
remove_proc

cd ${DAILY}/au
echo "--> zipping daily/au file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/au files older than ${DAYS} days"
remove_proc

cd ${DAILY}/tc
echo "--> zipping daily/tc file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/tc files older than ${DAYS} days"
remove_proc

cd ${DAILY}/pf
echo "--> zipping daily/pf file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/pf files older than ${DAYS} days"
remove_proc

cd ${DAILY}/jj
echo "--> zipping daily/jj file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/jj files older than ${DAYS} days"
remove_proc

cd ${DAILY}/sc
echo "--> zipping daily/sc file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/sc files older than ${DAYS} days"
remove_proc

cd ${DAILY}/ln
echo "--> zipping daily/ln file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/ln files older than ${DAYS} days"
remove_proc

cd ${DAILY}/lt
echo "--> zipping daily/lt file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/lt files older than ${DAYS} days"
remove_proc

cd ${DAILY}/lp
echo "--> zipping daily/lp file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/lp files older than ${DAYS} days"
remove_proc

cd ${DAILY}/lc
echo "--> zipping daily/lc file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/lc files older than ${DAYS} days"
remove_proc

cd ${DAILY}/lr
echo "--> zipping daily/lr file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/lr files older than ${DAYS} days"
remove_proc

cd ${DAILY}/ls
echo "--> zipping daily/ls file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/ls files older than ${DAYS} days"
remove_proc

cd ${DAILY}/mh
echo "--> zipping daily/mh file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/mh files older than ${DAYS} days"
remove_proc

cd ${DAILY}/oh
echo "--> zipping daily/oh file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/oh files older than ${DAYS} days"
remove_proc

cd ${DAILY}/rt
echo "--> zipping daily/rt file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/rt files older than ${DAYS} days"
remove_proc

cd ${DAILY}/tl
echo "--> zipping daily/tl file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/tl files older than ${DAYS} days"
remove_proc

cd ${DAILY}/if
echo "--> zipping daily/if file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/if files older than ${DAYS} days"
remove_proc

cd ${DAILY}/ba
echo "--> zipping daily/ba file"
FILE="CLMRT-????????"
zip_proc
DAYS=120
echo "--> removing daily/ba files older than ${DAYS} days"
remove_proc

date

exit 0
