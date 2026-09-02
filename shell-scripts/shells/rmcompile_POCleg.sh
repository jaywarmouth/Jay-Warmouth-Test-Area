#!/bin/sh
#
# Script for compiling Legacy POC source code from SCM  
# Version 1.1
#
# Variables :
RMPATH=/media/cobol/ShadowDevelopment/Frozen_Code_Production_10-11-2016/CBL:/media/cobol/ShadowDevelopment/Frozen_Code_Production_10-11-2016/CPY:/media/cobol/ShadowDevelopment/Frozen_Code_Production_10-11-2016/DES:/var/www/html/xbis/common:/usr/rmcobol
export RMPATH
COB_DIR=/usr/lnk/scm/POClegacy
SRC=".cbl"

usage()
{
	echo "USAGE:"
	echo "rmcompile_POCleg.sh sourcename"
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
