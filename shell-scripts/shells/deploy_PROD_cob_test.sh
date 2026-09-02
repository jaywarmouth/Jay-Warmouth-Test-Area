#!/bin/sh


#
# MAIN
#

FILE_LIST=$1
datestamp=`/bin/date "+%Y%m%d"`
RETVAL=0
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
DIR_LOC=/usr/lnk/git/rmcob
ARCH_DIR=/usr/lnk/git/rmcob/Archive
FILE_LIST=/usr/lnk/wt/oper-wt/SprintConfigs/${FILE_LIST}
OBJ_DIR=/usr/lnk/obj
LST_DIR=/usr/lnk/lst
DEV_SERVER=cobol-dev01
CR="
"
scp /usr/lnk/git/rmcob/Archive/C5sub_tcnbrlesssendlink.lst  ${DEV_SERVER}:${LST_DIR}
ssh ${DEV_SERVER} "chmod 664 ${LST_DIR}/${LINE}.lst"

date
echo "EXIT Code = $RETVAL"

exit $RETVAL
