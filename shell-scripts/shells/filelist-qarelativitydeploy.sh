#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-qarelativitydeploy.sh filename"
	echo "  filename - list of files to be copied"
	echo "Copies list of files from /usr/lnk/wt/devops-deployment/QArmcob to $temploc, then scp $temploc/*.cob to reltest10:/usr/lnk/obj"
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

filelist=$1
obj_dir=/usr/lnk/wt/devops-deployment/QArmcob
temp_loc=/usr/lnk/obj/temprel
dest_dir=/usr/lnk/obj

echo "Copy to temp location"
for file in `cat $filelist`
do
	echo "$file.cob"
	cp -p $obj_dir/$file.cob $temp_loc
	chmod 664 $temp_loc/$file.cob
done

echo ""
echo "Copy to reltest10 and permission update"
scp -p $temp_loc/*.cob reltest10:$dest_dir

rm -f $temp_loc/*.cob

exit 0
