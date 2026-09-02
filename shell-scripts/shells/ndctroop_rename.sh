#!/bin/sh


BIN="610020"
GMTDATE=`date -u "+%Y%m%d%H%M%S"`
FILETYPE="S"

origfile="$1"
outdir="$2"

usage() {
	echo "USAGE: $0 filename outputdir"
	echo "Renames filename into 'troop' format and stores it in outputdir"


}



if [ "$outdir" = "" ]
then
	usage
	exit 1
fi

#echo $GMTDATE

mv $origfile "${outdir}/${BIN}${GMTDATE}${FILETYPE}"
retval="$?"

exit $retval


