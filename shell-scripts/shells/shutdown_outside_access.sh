#!/bin/sh


echo "Stopping outside users from logging in."
touch /usr/pdm/login_status/stoplogin

echo "Stopping cardh73"
/usr/lnk/shell/cardh73_stop.sh

echo "Stopping elgrt01"
/usr/lnk/shell/elgrt01_stop.sh

echo "Stopping elgrt02"
/usr/lnk/shell/elgrt02_stop.sh

echo "Stopping elgrt_tst"
/usr/lnk/shell/elgrt_tst_stop.sh

echo "Logging off non-operator users."
/usr/local/bin/auto_off.sh >/tmp/.auto_off.manual.log

echo "Done."
