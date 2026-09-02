#!/bin/sh

# Shell to stop processes which can modify cobol files
# Used for quieting process to take a snapshot


#echo "`date`: running $0" >>/tmp/zerto.log
#exit 0


echo "Stopping RTE"
/usr/local/bin/elgrt02_stop.sh


echo "Stopping RxHUB"
/usr/local/bin/etraf01_stop.sh 


echo "Stopping claims processing"
/usr/local/bin/kill_t02.sh ptool
/usr/local/bin/kill_t02.sh fir
/usr/local/bin/kill_t02.sh dir
/usr/local/bin/kill_t02.sh 16
/usr/local/bin/kill_t02.sh 40




