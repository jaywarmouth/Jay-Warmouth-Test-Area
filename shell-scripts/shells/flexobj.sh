#!/bin/sh
#
# Version 2.1 - 6/27/2019 Changed logic for Testprod12
# Version 3.0 - 10/21/2019 Changes for new Robin flexgen environments/logic
# Version 4.0 - 01/25/2022 Uncommented the logic for copy/refresh to robin:/opt/flexgen/flexgen703_devtest/obj
#				(had this commented for a while due to unknown previous issues)
# Version 5.0 - 07/25/2022 Deploy production from Testprod11 instead of prodtest10
# Version 6.0 - Use of /usr/lnk/git/flexobj and /usr/lnk/git/fleximports for deployments



FLG=$1
FILE_LIST=$2
DATE=`date +%Y%m%d`
TST_LIST="testprod11"
PROD_LIST="prod10 prodtest10"
CR="
"
ARCH_FILE=/usr/lnk/scm/flexgen/deployments/${DATE}${FLG}.zip
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
FLEX_DEV="/opt/flexgen/flexgen703_stagedev"
FLEX_DIR="/opt/flexgen/flexgen703"
ROBINFLEXTEST="/opt/flexgen/flexgen703_test"
REMOTE_FLEX_DIR="/usr/lnk/flexgen"


if [ $HOSTNAME = "robin" ]
then
date
case $FLG in
  "test")
	SYS_LIST=$TST_LIST
	;;
  "prod")
	SYS_LIST=$PROD_LIST
	;;
esac
IFS=${CR}
for file in `cat ${FILE_LIST}`
do
	echo "FNAME=$file"
	OLDIFS=$IFS
	IFS=" "
	for sys in `echo ${SYS_LIST}`
	do
		echo "$file to $sys"
		ssh -q $sys "test -e ${REMOTE_FLEX_DIR}/obj/$file"
		FILESTAT=$?
		case $FLG in
		   "test")
			scp -q ${FLEX_DEV}/obj/$file $sys:${REMOTE_FLEX_DIR}/obj
			cp ${FLEX_DEV}/obj/$file /usr/lnk/git/flexobj
			;;
		   "prod")
			scp -q /usr/lnk/git/flexobj/$file $sys:${REMOTE_FLEX_DIR}/obj
			;;
		esac
		if test $? -ne 0
		then
		   echo "-*> scp of $file failed"
		else
		   if [ ${FILESTAT} -ne 0 ]
		   then
      		      	ssh -q $sys "chmod 664 ${REMOTE_FLEX_DIR}/obj/$file; chgrp pdm ${REMOTE_FLEX_DIR}/obj/$file"
		   fi
		fi
	done
	IFS=$OLDIFS
	if [ ${FLG} = "prod" ]
	then
		if test -e ${FLEX_DIR}/obj/$file
		then
			cp /usr/lnk/git/flexobj/$file ${FLEX_DIR}/obj
		else
			cp /usr/lnk/git/flexobj/$file ${FLEX_DIR}/obj
			chmod 664 ${FLEX_DIR}/obj/$file; chgrp pdm ${FLEX_DIR}/obj/$file
		fi
		if test -e ${ROBINFLEXTEST}/obj/$file
		then
			cp /usr/lnk/git/flexobj/$file ${ROBINFLEXTEST}/obj
		else
			cp /usr/lnk/git/flexobj/$file ${ROBINFLEXTEST}/obj
			chmod 664 ${ROBINFLEXTEST}/obj/$file; chgrp pdm ${ROBINFLEXTEST}/obj/$file
		fi
	fi
done
date
else
        echo "-*> This script must be run on ROBIN..."
	exit 1
fi

exit 0
