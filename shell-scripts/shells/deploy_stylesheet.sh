#!/bin/sh
#
# Version 1.2 - 1/25/2018 Removal of devtest20
# Verison 1.0 - 9/19/2017
# Version 1.1 - 01/16/2018 (addtion of sudo to scp and ssh coomands)


TST_LIST="testprod11 prodtest10 uattrans20 cobolqa20"
PROD_LIST="prod10 prod11 prod20 husk"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
XML_DIR="/usr/lnk/xml"
DEPLOY_DIR="/usr/lnk/scm/stylesheets"


# Check run user
check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
                echo "You need to be root to run this program!"
                exit 100
        fi
}

# Check for correct host
check_host()
{
	if [ $HOSTNAME != "robin" ]
	then
        	echo "-*> This script must be run on ROBIN..."
        	exit 99
	fi
}

## Main Section

check_host
check_for_root

# Check command line validity
if [ $# -lt 2 ]
then
	echo "USAGE: $0 deploytype stylesheet_name"
	echo "    --deploytype is test|prod"
	exit 99
fi

FLG=$1
file=$2

date
case $FLG in
  "test")
	SYS_LIST=$TST_LIST
	;;
  "prod")
	SYS_LIST=$PROD_LIST
	;;
esac
echo "FNAME=$file"
for sys in `echo ${SYS_LIST}`
do
	echo "$file to $sys"
	sudo ssh -q $sys "test -e ${XML_DIR}/$file"
	FILESTAT=$?
	sudo scp -q ${DEPLOY_DIR}/$file $sys:${XML_DIR}
	if test $? -ne 0
	then
	   echo "-*> scp of $file failed"
	else
	   if [ ${FILESTAT} -ne 0 ]
	   then
      	      sudo ssh -q $sys "chmod 755 ${XML_DIR}/$file"
	   fi
	fi
done
date

exit 0
