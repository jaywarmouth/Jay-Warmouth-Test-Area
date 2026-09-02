#!/bin/sh
#
# Program Name	: download_p2p.sh
# Description	:
# Author	: Linda Jefferis
# Date		: 
# Modifications : 10/21/2015 - corrections (LSJ) 
#
# Variables Used:
WT_DIR=/usr/lnk/wt/ault-40/ToPDMI
P2P_DIR=/usr/lnk/p2p
P2PIN_DIR=/usr/lnk/p2p/in
YEAR=`date +%Y`

#
# Usage routine
usage() {

echo "$0 filemonth"
echo "  filemonth	- Month name of .zip file (e.g. August)"
echo ""
echo "Example:  $0 August"
echo ""

exit 1
}


#
# Main routine
#
if [ $# -lt 1 ]
then
	usage
fi

Month_name=$1
Filedate=`date +%Y%m%d`

if ! test -d ${P2PIN_DIR}/${YEAR}
then
        mkdir -m 770 ${P2PIN_DIR}/${YEAR}
fi

P2PIN=P2P01-INPUT-FILES-${Filedate}.txt

mv ${WT_DIR}/${Month_name}.zip ${P2P_DIR}
unzip -jd ${P2PIN_DIR} ${P2P_DIR}/${Month_name}.zip

cd ${P2PIN_DIR}
ls -1 RPT.DDPS_P2P* > ${P2PIN_DIR}/${YEAR}/${P2PIN}
echo "END-OF-FILE" >> ${P2PIN_DIR}/${YEAR}/${P2PIN}
cp RPT.DDPS_P2P* ${P2PIN_DIR}/${YEAR}

exit 0
