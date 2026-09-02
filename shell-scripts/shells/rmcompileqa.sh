#!/bin/sh
#
# Script for compiling Production-ready source code from SCM  
# Version 1.1
#
# Variables :
RMPATH=/usr/lnk/COBOL_GIT/CBL_BATCH:/usr/lnk/COBOL_GIT/CPY:/usr/lnk/COBOL_GIT/DES:/var/www/html/xbis/common:/usr/rmcobol
export RMPATH
COB_DIR=/usr/lnk/git/QArmcob
SRC=".cbl"

usage()
{
	echo "USAGE:"
	echo "rmcompile.sh sourcename"
}

#
# Checks to ensure we are logged in as operator.
#
#
check_user()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "11" ]
        then
                echo "You need to be operator to run this program!"
                exit 100
        fi
}


#
# Main routine
#

check_user

if [ "$1" = "" ]
then
        usage
        exit 1
fi

sourcename=$1
echo "Source: $sourcename"
echo "RM Compile Path: $RMPATH"
echo " "

rmcobol $sourcename$SRC O=$COB_DIR L=$COB_DIR

exit 0
