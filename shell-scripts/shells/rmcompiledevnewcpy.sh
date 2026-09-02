#!/bin/sh
#
# Script for compiling Development source code from SCM with NEWCPY logic  
# Version 2.0 - 4/24/2017
# Version 1.0 - 8/4/2015

#
# Variables :
sourcename=$1
Project=$2
RMPATH=/media/cobol/users/$WUSER/workspace/$Project/source:/media/cobol/users/$WUSER/workspace/$Project/cpy/NEWCPY:/media/cobol/users/$WUSER/workspace/$Project/des:/media/cobol/ShadowDevelopment/CPY/NEWCPY:/media/cobol/ShadowDevelopment/DES:/var/www/html/xbis/common:/usr/rmcobol
export RMPATH
COB_DIR=/usr/lnk/tst/$USER

usage()
{
	echo "USAGE:"
	echo "rmcompiledev sourcename Projectname"
}


#
# Main routine
#

if [ $# -lt 2 ]
then
        usage
        exit 1
fi

echo "user=$WUSER"
echo $RMPATH
echo "sourcename=$sourcename"

rmcobol $sourcename O=$COB_DIR L=$COB_DIR Y

exit 0
