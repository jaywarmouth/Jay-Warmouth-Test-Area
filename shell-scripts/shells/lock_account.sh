#!/bin/sh
#
SRV=`hostname -s`
IND_FLG=0
FILE_FLG=0
FILE_DATE=$(date +%Y%m%d)
LOG_FILE=/usr/lnk/wt/oper-wt/misc/${SRV}-${FILE_DATE}-LOCK-LOG.txt
LOCK_DATE=$(date)

usage()
{  cat << ENDOFUSAGE
usage: lock_user.sh [-f ${FILE-MODE} or -i {SINGLE-USER}]

ENDOFUSAGE
exit 1
}

file_lock()
{
echo "processing ${IN_FILE}"
echo "TERMING ACCOUNTS ON $SRV with Lock Date ${LOCK_DATE}"
cat ${IN_FILE} | while read LINE
do
 user=$LINE

	echo " Locking users on ${DATE}"
        echo "User $LINE status Check pre-lock:"
        passwd --status ${user}
        echo "Locking account $LINE"
        passwd -l  ${user}
        echo "User $LINE status Check post-lock:"
        passwd --status ${user}
done
exit 1
}


individual_lock()
{
        echo " Locking $user on $SRV with Lock Date ${LOCK_DATE}"
	echo "User $user status Check pre-lock:"
        passwd --status ${user}
        echo "Locking account $LINE"
        passwd -l  ${user}
        echo "User $user status Check post-lock:"
        passwd --status ${user}
exit 1
}

#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLG=1
        IN_FILE=$1
 	echo ${IN_FILE}
	file_lock > ${LOG_FILE} 2>&1
	exit 1
       ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        IND_FLG=1
        user=$1
 	echo ${user}
	individual_lock > ${LOG_FILE} 2>&1
      exit 1
;;
  esac
 done
