#!/bin/sh
#

RETVAL=0

/usr/local/bin/aws s3 cp /usr/lnk/wt/pdm/reconX12/chk/Netrx/ s3://ga-internal-transfers/PDMI/NET-Rx/OUTBOUND/ --recursive
RETVAL=$?

echo "RETVAL=${RETVAL}"
exit ${RETVAL}
