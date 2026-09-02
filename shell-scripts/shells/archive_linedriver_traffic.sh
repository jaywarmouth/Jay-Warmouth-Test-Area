#!/bin/sh

password="rwtb99"
login="root"
db="linedriver_traffic"

adate=`date -d "4 weeks ago" +%Y-%m-%d`

archive_cmd="CALL pr_archive_data('${adate} 00:00:00')" 

/usr/bin/mysql --user=${login} --password=${password} -e "$archive_cmd" --batch ${db} >> .archive_linedriver_traffic.log.$$ 2>&1
#echo /usr/bin/mysql --user=${login} --password=${password} -e "$archive_cmd" ${db} 
