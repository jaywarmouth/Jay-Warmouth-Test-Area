#!/bin/sh
#
# Version 2.1 - 6/27/2019 Put Testprod12 under PROD_LIST
# Version 3.0 - 10/21/2019 - Changes for new Robin Flexgen environments/logic

FLG=$1
FILE_LIST=$2
DATE=`date +%Y%m%d`
TST_LIST="cobolqa20"
#PROD_LIST="prod10 prod11 prod20 husk"
CR="
"
ARCH_FILE=/usr/lnk/scm/flexgen/deployments/${DATE}${FLG}.zip
FLEX_DEV="/opt/flexgen/flexgen703_stagedev"
FLEX_DIR="/opt/flexgen/flexgen703"
ROBINFLEXTEST="/opt/flexgen/flexgen703_test"
ROBINFLEXDEVTEST="/opt/flexgen/flexgen703_devtest"
REMOTE_FLEX_DIR="/usr/lnk/flexgen"


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
	zip -j ${ARCH_FILE} ${FLEX_DEV}/$file
	if [ ${FLG} = "prod" ]
	then
		cp ${FLEX_DEV}/$file ${FLEX_DIR}/imp
        	if test $? -ne 0
        	then
                	echo "-*> cp failed for $file to robin:${FLEX_DIR}/imp"
        	fi
        	cp ${FLEX_DEV}/$file ${ROBINFLEXTEST}/imp
        	if test $? -ne 0
        	then
                	echo "-*> cp failed for $file to robin:${ROBINFLEXTEST}/imp"
        	fi
        	cp ${FLEX_DEV}/$file ${ROBINFLEXDEVTEST}/imp
        	if test $? -ne 0
        	then
                	echo "-*> cp failed for $file to robin:${ROBINFLEXDEVTEST}/imp"
        	fi
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
zip -j ${ARCH_FILE} ${FILE_LIST}
date

exit 0
