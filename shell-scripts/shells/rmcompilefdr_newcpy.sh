#!/bin/sh
#
# Script for compiling Production-ready source code from SCM  
# Version 1.1
#
# Variables :
RMPATH=/media/cobol/ShadowProduction/CPY/NEWCPY:/media/cobol/ShadowProduction/CBL:/media/cobol/ShadowProduction/CPY:/media/cobol/ShadowProduction/DES:/var/www/html/xbis/common:/usr/rmcobol
export RMPATH
COB_DIR=/usr/lnk/scm/FDR
SRC=".cbl"

usage()
{
	echo "USAGE:"
	echo "rmcompile.sh sourcename"
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
