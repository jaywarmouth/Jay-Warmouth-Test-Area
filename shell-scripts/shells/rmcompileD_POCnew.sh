#!/bin/sh
#
# Script for compiling New POC source code from SCM  
# Version 1.1
#
# Variables :
RMPATH=/media/cobol/ED/Frozen_Code_ED_10-11-2016/CPY:/media/cobol/ED/Frozen_Code_ED_10-11-2016/CBL:/media/cobol/ED/Frozen_Code_ED_10-11-2016/DES:/var/www/html/xbis/common:/usr/rmcobol
export RMPATH
COB_DIR=/usr/lnk/scm/POCnew
SRC=".cbl"

usage()
{
	echo "USAGE:"
	echo "rmcompile_POCnew.sh sourcename"
}


#
# Main routine
#


if [ "$1" = "" ]
then
        usage
        exit 1
fi

sourcename=$1
echo "sourcename=$sourcename"

rmcobol $sourcename$SRC O=$COB_DIR L=$COB_DIR Y

exit 0
