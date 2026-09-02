#!/bin/sh
#
# to run: p2p01.sh 20130325
#
# Program Name  : p2p01.sh
# Description   : Process P2P files and create reports
#                 Command line arguments:
#                  file name date - ccyymmdd
# Author        : Linda Jefferis
# Date          : 09/12/2015
# Modificaitons : 10/21/2015 - Corrections
#
# Variables Used:
OBJ_DIR="/usr/lnk/obj"
YEAR=`date +%Y`
P2PIN_DIR=/usr/lnk/p2p/in/${YEAR}

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: $0 filedate
  filedate	- ccyymmdd in downloaded files

  Example:  $0 20150821

ENDOFUSAGE
  exit 1
}


#
# Main routine
#
#Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
	usage
fi

FILE_DT=$1

# Assign alternate environment variables

P2PIN=${P2PIN_DIR}/P2P01-INPUT-FILES-${FILE_DT}.txt
 export P2PIN

date
echo "Create P2P Reports"
echo "   P2PIN=$P2PIN"
runcobol ${OBJ_DIR}/p2p01
date


exit 0 

