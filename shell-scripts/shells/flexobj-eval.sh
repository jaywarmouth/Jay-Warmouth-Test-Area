#!/bin/sh
#
# Version 2.1 - 6/27/2019 Changed logic for Testprod12
# Version 3.0 - 10/21/2019 Changes for new Robin flexgen environments/logic



FLG=$1
FILE_LIST=$2
FLEX_DEV=$3
DATE=`date +%Y%m%d`
TST_LIST="prod10-eval"
#PROD_LIST="prod10 prod11 prod20 husk"
CR="
"
ARCH_FILE=/usr/lnk/scm/flexgen/deployments/${DATE}${FLG}.zip
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
FLEX_DIR="/opt/flexgen/flexgen703_stagedev"
ROBINFLEXTEST="/opt/flexgen/flexgen703_test"
ROBINFLEXDEVTEST="/opt/flexgen/flexgen703_devtest"
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
			;;
		   "prod")
			ssh prodtest10 scp -q ${REMOTE_FLEX_DIR}/obj/$file $sys:${REMOTE_FLEX_DIR}/obj
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
			scp -q prodtest10:${REMOTE_FLEX_DIR}/obj/$file ${FLEX_DIR}/obj
		else
			scp -q prodtest10:${REMOTE_FLEX_DIR}/obj/$file ${FLEX_DIR}/obj
			chmod 664 ${FLEX_DIR}/obj/$file; chgrp pdm ${FLEX_DIR}/obj/$file
		fi
		if test -e ${ROBINFLEXTEST}/obj/$file
		then
			scp -q prodtest10:${REMOTE_FLEX_DIR}/obj/$file ${ROBINFLEXTEST}/obj
		else
			scp -q prodtest10:${REMOTE_FLEX_DIR}/obj/$file ${ROBINFLEXTEST}/obj
			chmod 664 ${ROBINFLEXTEST}/obj/$file; chgrp pdm ${ROBINFLEXTEST}/obj/$file
		fi
#		if test -e ${ROBINFLEXDEVTEST}/obj/$file
#		then
#			scp -q prodtest10:${REMOTE_FLEX_DIR}/obj/$file ${ROBINFLEXDEVTEST}/obj
#		else
#			scp -q prodtest10:${REMOTE_FLEX_DIR}/obj/$file ${ROBINFLEXDEVTEST}/obj
#			chmod 664 ${ROBINFLEXDEVTEST}/obj/$file; chgrp pdm ${ROBINFLEXDEVTEST}/obj/$file
#		fi
	fi
done
zip -j ${ARCH_FILE} ${FILE_LIST}
date
else
        echo "-*> This script must be run on ROBIN..."
	exit 1
fi

exit 0
