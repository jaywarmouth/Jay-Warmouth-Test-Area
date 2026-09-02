REMOTE_SYS=$1

cp_files()
{
	for FILE in `cat ${FILE_LIST}`
	do
   		scp -q ${FILE} ${REMOTE_SYS}:${FILE}
   		if test $? -ne 0
   		then
      		   echo "ERROR - ${FILE} not copied"
   		else
      		   echo "${FILE} - COPY COMPLETE"
   		fi
	done
}


date
find /usr/lnk/shell \! -type d \! -name "env_var" \! -name "compu05*" \! -name "traffic01*" \! -name "traffic02*" -follow -print > /usr/lnk/backup/shell_files
FILE_LIST="/usr/lnk/backup/shell_files"
cp_files
ssh -q ${REMOTE_SYS} "chmod 775 /usr/lnk/shell/*.sh;chgrp devadm /usr/lnk/shell/*.sh"


date
find /usr/lnk/obj -follow \! -type d -name "*.cob" -print > /usr/lnk/backup/obj_files
FILE_LIST="/usr/lnk/backup/obj_files"
cp_files
ssh -q ${REMOTE_SYS} "chmod 664 /usr/lnk/obj/*.cob;chgrp devadm /usr/lnk/obj/*.cob"

date
