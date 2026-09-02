#!/bin/sh

test_clm="000000                0 490400 995"

rsp_date=`date "+%m%d%y"`

rsp_file="/usr/lnk/rsp/resp-0000-$rsp_date"

if [ ! -r "$rsp_file" ]
then
	echo "rej:0 rev:0 paid:0 tot:0" 
	exit 0

fi


total=`cat $rsp_file | wc -l`
total_nontest=`cat $rsp_file | head -n $total | grep -v "$test_clm" | wc -l`
rej=`cat $rsp_file | head -n $total | grep -v "$test_clm" |  cut -c 50-52 | grep "[1234567890]" |   wc -l`
rev=`cat $rsp_file | head -n $total | grep -v "$test_clm" |  cut -c 50-60 | grep "REV ACCE" |   wc -l`
paid=`expr $total_nontest - $rej`
paid=`expr $paid - $rev`

echo "rej:$rej rev:$rev paid:$paid tot:$total_nontest" 
