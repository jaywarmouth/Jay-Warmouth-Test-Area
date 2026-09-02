#!/bin/sh

# Version 1.5

PROFILE="/tmp/profiles.tgz"
HOMEDIRS="/tmp/homedirs.cpio"
FLEXTAR="/tmp/flexgen.tgz"
FLEXDIR="/usr/flexgen703"
REMOTE_DIR="/usr/lnk/repl/server/prod10"
REMOTE2="prod11"

date

# login files
scp -q /etc/passwd /etc/shadow /etc/group ${REMOTE2}:${REMOTE_DIR}

# Weekend access database
scp -q /usr/local/pub/access_weekend.allow ${REMOTE2}:${REMOTE_DIR}

# Login script
scp -q /usr/local/bin/login_netw.sh ${REMOTE2}:${REMOTE_DIR}

# Home directories and profiles
cd /home
find . -type d | cpio -oc > $HOMEDIRS
tar --same-owner -pczf - `find . -mount -name .profile -o -name .bash_profile` > $PROFILE
#tar czf - `find . -mount -name .profile -o -name .bash_profile` > $PROFILE
#find /home -mount -name .profile -o -name .bash_profile 2>/dev/null | cpio -oc > $PROFILE 2>/dev/null
scp -q $HOMEDIRS ${REMOTE2}:${REMOTE_DIR}
scp -q $PROFILE ${REMOTE2}:${REMOTE_DIR}

# Flexgen
#cd $FLEXDIR
#tar czf $FLEXTAR .
#scp -q $FLEXTAR ${REMOTE2}:${REMOTE_DIR}

# Cron Files
crontab -l > /tmp/cron-prod10root.txt
crontab -l -u operator > /tmp/cron-prodoperator.txt
scp /tmp/cron-prod10root.txt ${REMOTE2}:${REMOTE_DIR}
scp /tmp/cron-prodoperator.txt ${REMOTE2}:${REMOTE_DIR}
rm /tmp/cron-prod10root.txt /tmp/cron-prodoperator.txt


# Cleanup
rm -f $PROFILE
rm -f $HOMEDIRS
rm -f $FLEXTAR

date
