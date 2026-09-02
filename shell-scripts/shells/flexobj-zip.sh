#!/bin/sh
#

FILELIST=$1
SPRINT=$2
FLX_DIR=$3
DATE=`date +%Y%m%d`
cd ${FLX_DIR}
for file in `cat ${FILELIST}`
do
	zip -j /usr/lnk/scm/flexgen/deployments/flexobj-${SPRINT}-${DATE}.zip ${FLX_DIR}/obj/$file
done

exit 0
