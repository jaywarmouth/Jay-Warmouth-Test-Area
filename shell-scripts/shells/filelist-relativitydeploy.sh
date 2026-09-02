#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-relativitydeploy.sh filename"
	echo "  filename - list of files to be copied"
	echo "Copies list of files from /usr/lnk/obj to $temploc, then scp $temploc/*.cob to relprod10:/usr/lnk/obj and rxods10:/usr/lnk/obj"
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

filelist=$1
obj_dir=/usr/lnk/obj
temp_loc=/usr/lnk/obj/temprel

echo "Copy to temp location"
for file in `cat $filelist`
do
	echo "$file.cob"
	cp -p $obj_dir/$file.cob $temp_loc
done

echo ""
echo "Copy to relprod10 and permission update"
scp -p $temp_loc/*.cob relprod10:$obj_dir

echo ""
echo "Copy to rxods10"
scp -p $temp_loc/*.cob rxods10:$obj_dir

echo ""
echo "Copy to relprod10-eval"
scp -p $temp_loc/*.cob relprod10-eval:$obj_dir

echo ""
echo "Copy to relprod10-sandbox"
scp -p $temp_loc/*.cob relprod10-sandbox:$obj_dir

rm -f $temp_loc/*.cob

exit 0
