#!/bin/sh


prod_dir="/tmp/rtc"
err_dir="/tmp/rtc/error"

for name in `ls $err_dir`
do
	if [ -f "${err_dir}/${name}" ]
	then
		cat  "${err_dir}/${name}" | tr -d \\0 > "${prod_dir}/${name}"
		rm -f "${err_dir}/${name}"
	fi
done
