#!/bin/sh
#

FLG=$1
FILE_LIST=$2
DATE=`date +%Y%m%d`
TST_LIST="testprod11"
PROD_LIST="prod10 prodtest10"
CR="
"
ARCH_FILE=/usr/lnk/scm/flexgen/deployments/${DATE}${FLG}.zip
FLEX_DEV="/opt/flexgen/flexgen703_stagedev"
FLEX_DIR="/opt/flexgen/flexgen703"
ROBINFLEXTEST="/opt/flexgen/flexgen703_test"
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
	case ${FLG} in
	  "test")
		cp ${FLEX_DEV}/$file /usr/lnk/git/fleximports
		if test $? -ne 0
                then
			echo "-*> cp failed for $file to /usr/lnk/git/fleximports"
		fi
		;;
	  "prod")
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
	esac
	OLDIFS=$IFS
        IFS=" "
        for sys in `echo ${SYS_LIST}`
        do
	  case ${FLG} in
	    "test")
		scp -q ${FLEX_DEV}/$file $sys:${REMOTE_FLEX_DIR}/imp
                if test $? -ne 0
                then
                	echo "-*> scp failed for $file"
                fi
		;;
	    "prod")
		scp -q /usr/lnk/git/fleximports/$file $sys:${REMOTE_FLEX_DIR}/imp
                if test $? -ne 0
                then
                	echo "-*> scp failed for $file"
                fi
		;;
	  esac
        done
        IFS=$OLDIFS
done
date

exit 0
