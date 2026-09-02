#!/bin/sh
#
# Script for compiling Development source code from SCM  ED Branch

# Variables :
sourcename=$1
Project=$2
RMPATH=/media/cobol/users/$WUSER/workspace/$Project/source:/media/cobol/users/$WUSER/workspace/$Project/cpy:/media/cobol/users/$WUSER/workspace/$Project/des:/media/cobol/ED/CPY:/media/cobol/ED/DES:/var/www/html/xbis/common:/usr/rmcobol
export RMPATH
COB_DIR=/usr/lnk/tst/$USER/ED

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
