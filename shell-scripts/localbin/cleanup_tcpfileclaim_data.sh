#!/bin/sh

echo ============================== >/usr/lnk/wrk/tcp-file-clean.txt
date >>/usr/lnk/wrk/tcp-file-clean.txt
echo ++++++++++++++++++++++++++++++ >>/usr/lnk/wrk/tcp-file-clean.txt
echo ======Before Cleanup===== >>/usr/lnk/wrk/tcp-file-clean.txt
df -h /tmp/tcpfileclaim_data >>/usr/lnk/wrk/tcp-file-clean.txt
echo ++++++++++++++++++++++++++++++ >>/usr/lnk/wrk/tcp-file-clean.txt
df -hi /tmp/tcpfileclaim_data >>/usr/lnk/wrk/tcp-file-clean.txt

find /tmp/tcpfileclaim_data -mmin +5 -exec rm -f {} \;

echo ++++++++++++++++++++++++++++++ >>/usr/lnk/wrk/tcp-file-clean.txt
echo ======After Cleanup===== >>/usr/lnk/wrk/tcp-file-clean.txt
df -h /tmp/tcpfileclaim_data >>/usr/lnk/wrk/tcp-file-clean.txt
echo ++++++++++++++++++++++++++++++ >>/usr/lnk/wrk/tcp-file-clean.txt
df -hi /tmp/tcpfileclaim_data >>/usr/lnk/wrk/tcp-file-clean.txt

