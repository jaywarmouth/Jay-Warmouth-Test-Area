#!/bin/sh

test_clm="000000                0 490400 995"

rsp_date=`date "+%m%d%y"`

rsp_file="/usr/lnk/rsp/resp-0000-$rsp_date"

if [ ! -r "$rsp_file" ]
then
	echo "env:0 ndc:0 dir:0 tot:0"
	exit 0

fi


total=`cat $rsp_file | wc -l`
total_nontest=`cat $rsp_file | head -n $total | grep -v "$test_clm" | wc -l`
env=`cat $rsp_file | head -n $total | grep "^[23][1234567890] " | grep -v "$test_clm" |  wc -l`
ndc=`cat $rsp_file | head -n $total | grep "^[456][1234567890] " |grep -v "$test_clm" | wc -l`
dir=`cat $rsp_file | head -n $total | grep "^[1][1234567890 ] " | grep -v "$test_clm" | wc -l`

echo "env:$env ndc:$ndc dir:$dir tot:$total_nontest" 
