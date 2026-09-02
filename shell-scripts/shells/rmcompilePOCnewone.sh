#!/bin/sh
#
# Script for compiling New POC source code from SCM  
# Version 1.1
#
# Variables :
RMPATH=/media/cobol/ED/Frozen_Code_5_26_2015_New_Version_CM6072/CPY/NEWCPY:/media/cobol/ED/Frozen_Code_5_26_2015_New_Version_CM6072/CPY:/media/cobol/ED/Frozen_Code_5_26_2015_New_Version_CM6072/CBL:/media/cobol/ED/Frozen_Code_5_26_2015_New_Version_CM6072/DES:/var/www/html/xbis/common:/usr/rmcobol
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

rmcobol $sourcename$SRC O=$COB_DIR L=$COB_DIR

exit 0
