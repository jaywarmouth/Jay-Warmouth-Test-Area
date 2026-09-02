#!/bin/ksh
#
# Program Name	: line_audit.sh
# Description	: Nightly compression and counting of raw daily claims files
# Author	: Anthony DePinto
# Date		: 2-4-97
# Modifications : 2-25-97 AD Added -m flag and deleted rm after compression
#		: 2-12-01 LSJ Removed Version 00 and Version 01 references
#		: 2-12-01 LSJ Removed Termed Systems logic
#		: 02/28/2005 - Commented out the getinfo portions and just left the zipping of the daily files  (LSJ)
#		: 10/04/2005 - Changed CL178 to CLMRT  (LSJ)
#		: 08/08/2006 - Changed from zip to gzip and added process for pf directory  (LSJ)
#
# Variables Used:
DAILY=/usr/lnk/daily/
DATE=`date +%m%d%y`
DATE2=`date +%Y%m%d`
VER51="61002051"
V5_ORIGINAL="B1"
V5_REVERSAL="B2"
DOWNTIME="2"
V5_REBILL="B3"
DUR="8"
REFILL="9"
ZIP_PROG="/bin/gzip"

#
# standard grep routine
grepit()
{  NUM=`grep "${GREPTHIS}" ${FILE} | wc -l`

}

#
# grep series routine
grepseries()
{  
  GREPTHIS=${VERSION}${TYPE}1
  grepit
  echo "				One = "${NUM}
  GREPTHIS=${VERSION}${TYPE}2
  grepit
  echo "				Two = "${NUM}
  GREPTHIS=${VERSION}${TYPE}3
  grepit
  echo "			      Three = "${NUM}
  GREPTHIS=${VERSION}${TYPE}4
  grepit
  echo "			       Four = "${NUM}
}

#
# getinfo routine
getinfo()
{ echo 
  echo "Getting information for "$CHECK
  echo
  FILE=${DAILY}${CHECK}
  GREPTHIS=${VER32}
  grepit
  echo "	Version 32 Claims = "${NUM}
#  VERSION=${VER32}
#  TYPE=${ORIGINAL}
#  grepseries
#  TYPE=${DOWNTIME}
#  echo "		   Downtime claims"
#  grepseries
#  TYPE=${REBILL}
#  echo "		   Rebillings"
#  grepseries
#  TYPE=${DUR}
#  echo "		   DUR Transactions"
#  grepseries
#  TYPE=${REFILL}
#  echo "		   Refills"
#  grepseries
  GREPTHIS=${VER32}${REVERSAL}
  grepit
  echo "		   Reversals"
  echo "				    = "${NUM} 
  echo
  GREPTHIS=${VER3A}
  grepit
  echo "	Version 3A Claims = "${NUM}
#  VERSION=${VER3A}
#  TYPE=${ORIGINAL}
#  grepseries
#  TYPE=${DOWNTIME}
#  echo "		   Downtime claims"
#  grepseries
#  TYPE=${REBILL}
#  echo "		   Rebillings"
#  grepseries
#  TYPE=${DUR}
#  echo "		   DUR Transactions"
#  grepseries
#  TYPE=${REFILL}
#  echo "		   Refills"
#  grepseries
  GREPTHIS=${VER3A}${REVERSAL}
  grepit
  echo "		   Reversals"
  echo "				    = "${NUM} 
  echo
  GREPTHIS=${VER3B}
  grepit
  echo "	Version 3B Claims = "${NUM}
#  VERSION=${VER3B}
#  TYPE=${ORIGINAL}
#  grepseries
#  TYPE=${DOWNTIME}
#  echo "		   Downtime claims"
#  grepseries
#  TYPE=${REBILL}
#  echo "		   Rebillings"
#  grepseries
#  TYPE=${DUR}
#  echo "		   DUR Transactions"
#  grepseries
#  TYPE=${REFILL}
#  echo "		   Refills"
#  grepseries
  GREPTHIS=${VER3B}${REVERSAL}
  grepit
  echo "		   Reversals"
  echo "				    = "${NUM} 
  echo
  GREPTHIS=${VER3C}
  grepit
  echo "	Version 3C Claims = "${NUM}
#  VERSION=${VER3C}
#  TYPE=${ORIGINAL}
#  grepseries
#  TYPE=${DOWNTIME}
#  echo "		   Downtime claims"
#  grepseries
#  TYPE=${REBILL}
#  echo "		   Rebillings"
#  grepseries
#  TYPE=${DUR}
#  echo "		   DUR Transactions"
#  grepseries
#  TYPE=${REFILL}
#  echo "		   Refills"
#  grepseries
  GREPTHIS=${VER3C}${REVERSAL}
  grepit
  echo "		   Reversals"
  echo "				    = "${NUM} 
  echo
  GREPTHIS=${VER51}
  grepit
  echo "	Version 5.1 Claims = "${NUM}
#  VERSION=${VER51}
#  TYPE=${V5_ORIGINAL}
#  grepseries
#  TYPE=${V5_REBILL}
#  echo "		   Rebillings"
#  grepseries
  GREPTHIS=${VER51}${V5_REVERSAL}
  grepit
  echo "		   Reversals"
  echo "				    = "${NUM} 
  echo
}

#
# Main routine
#

sleep 120

#CHECK="dir/dir-"${DATE}
#getinfo

#CHECK="env/env-"${DATE}
#getinfo

#CHECK="ndc/ndc-"${DATE}
#getinfo

date
cd /usr/lnk/daily

cd dir
echo "--> zipping daily/dir file"
${ZIP_PROG} dir-${DATE}

cd ../ndc
echo "--> zipping daily/ndc file"
${ZIP_PROG} ndc-${DATE}

cd ../env
echo "--> zipping daily/env file"
${ZIP_PROG} env-${DATE}

cd ../tc
echo "--> zipping daily/tc file"
${ZIP_PROG} CLMRT-${DATE2}

cd ../pf
echo "--> zipping daily/pf file"
${ZIP_PROG} CLMRT-${DATE2}

date

exit 0
