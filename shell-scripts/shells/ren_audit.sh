#!/bin/sh


#       Name: ren_audit_prod20.sh
#       By  : Linda Jefferis
#       Date: 12/14/2011
#       Purpose: Rename audit files after a traffic switchover on prod20.
#		 It will use the current date unless specifed at the 
#		 command line in the form ccyymmdd	
#
#
#
#
#


check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
                echo "You need to be root to run this program!"
                exit 100
        fi
}

usage()
{
echo "USAGE:  $0 [ccyymmdd]"
echo "If no date is given, the current date is assumed."
echo "This program must be run on $LOCAL_MACHINE"
}

# file_process()
{
for number in `echo $AUDIT_NUMS`
do
	filename="${AUDIT_DIR}/${PREFIX}${number}-${AUDIT_DATE}"
        if [ ! -f "$filename" ]
        then
                echo $filename does not exist.
        else
                counter="1"
                while [ 1 ]
                do
                        new_fn="${filename}.${counter}"
                        if [ ! -f "$new_fn" ]
                        then
                                mv $filename $new_fn
                                break
                        fi
                        counter=`expr $counter + 1`
                done
        fi
done
}

#LOCAL_MACHINE="prod11"
LOCAL_MACHINE="$BACKUP1_SERVER"
AUDIT_DIR="/usr/lnk/audit"
AUDIT_PREFIX="AUDIT-"
MSG_PREFIX="MSG-"
CLMSS_PREFIX="CLMSS-"
EFSS_PREFIX="EFSS-"
SCSS_PREFIX="SCSS-"
FVSS_PREFIX="FVSS-"
AUDIT_NUMS="200 201 300 301 400 402 404 406 408" 
AUDIT_DATE=`date +%Y%m%d`
MACHINE=`hostname -s`

check_for_root

if [ "$1" != "" ]
then
	AUDIT_DATE="$1"
fi

if [ "$MACHINE" != "$LOCAL_MACHINE" ]
then
	echo "This program was designed to run on $LOCAL_MACHINE."
	echo "You are currently on $MACHINE"
	echo " "
	usage
	exit 1
fi

PREFIX="${AUDIT_PREFIX}"
file_process
PREFIX="${MSG_PREFIX}"
file_process
PREFIX="${CLMSS_PREFIX}"
file_process
PREFIX="${EFSS_PREFIX}"
file_process
PREFIX="${SCSS_PREFIX}"
file_process
PREFIX="${FVSS_PREFIX}"
file_process
