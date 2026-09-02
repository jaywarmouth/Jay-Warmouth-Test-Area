#!/bin/sh
#
FLG=$1
FILE_LIST=$2
DATE=`date +%Y%m%d`
TST_LIST="uattrans20"
PROD_LIST="prod10 testprod12"
CR="
"
ARCH_FILE=/usr/lnk/scm/flexgen/deployments/${DATE}${FLG}.zip
FLEX_DEV="/opt/flexgen/flexgen703_vision"
FLEX_DIR="/opt/flexgen/flexgen703_vision"
ROBINFLEXTEST="/opt/flexgen/flexgen703_test"
ROBINFLEXDEVTEST="/opt/flexgen/flexgen703_visiondev"
REMOTE_FLEX_DIR="/usr/lnk/flexgen_vision"


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
	zip -j ${ARCH_FILE} ${FLEX_DEV}/$file
	if [ ${FLG} = "prod" ]
	then
		cp ${FLEX_DEV}/$file ${FLEX_DEV}/imp
		cp ${FLEX_DEV}/$file ${ROBINFLEXDEVTEST}/imp
	fi
	OLDIFS=$IFS
        IFS=" "
        for sys in `echo ${SYS_LIST}`
        do
                scp -q ${FLEX_DEV}/$file $sys:${REMOTE_FLEX_DIR}/imp
		if test $? -ne 0
		then
		   echo "-*> scp failed for $file"
		fi
        done
        IFS=$OLDIFS
done
zip -mj ${ARCH_FILE} ${FILE_LIST}
date

exit 0
