#!/bin/sh
#
# Script for compiling Development source code from SCM  
# Version 1.1 - Changed COB_DIR and added L option on rmcobol command
#
#Modifications	: 11/07/2013 - Set input Numbers for suorcename and Project (DME)
#		: 11/07/2013 - Modify input check so it checks for 2 variables (DME)
#		: 03/17/2014 - Changed ShadowProduction references to ShadowDevelopment
# Variables :
sourcename=$1
Project=$2
RMPATH=/media/cobol/ShadowDevelopment/CPY/NEWCPY:/media/cobol/users/$WUSER/workspace/$Project/source:/media/cobol/users/$WUSER/workspace/$Project/cpy:/media/cobol/users/$WUSER/workspace/$Project/des:/media/cobol/ShadowDevelopment/CPY:/media/cobol/ShadowDevelopment/DES:/var/www/html/xbis/common:/usr/rmcobol
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
