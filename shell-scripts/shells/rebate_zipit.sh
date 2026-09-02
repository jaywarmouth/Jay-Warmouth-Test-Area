#!/bin/sh


# VERSION INFO
# ZIPIT.SH version 1.2



# VARIABLES

ZIP="/usr/bin/zip"
RPASS="/usr/local/bin/rpass"
GETID="/usr/bin/id -unr"
GETPWD="/bin/pwd"
PASSLOG="/usr/lnk/log/zipfiles.log"
QLOCKFILE="/tmp/zipit.quick.lockfile"
MAILER="/bin/mail"
ABORTNODEL="1"

# PASSLOG FORMAT
# OWNER:SERIALNUMBER:PWD:ZIPFILENAME:PASSWORD:EMAIL:ZOPTS:ZFILES

fname_only()
{
FN="$1"

	OUTFN=`echo $FN | awk -F/ '{ print $NF }'`
	echo $OUTFN

}

logzip()
{
SN="$1"
ZFILE="$2"
PASSWD="$3"
EMAIL="$4"
ZOPTS="$5"
ZFILES="$6"
OWNER=`$GETID`
PWD=`$GETPWD`

	if [ ! -w $PASSLOG ]
	then
		echo "Unable to write log to $PASSLOG"
		exit 1
	fi
	echo "${OWNER}:${SN}:${PWD}:${ZFILE}:${PASSWD}:${EMAIL}:${ZOPTS}:${ZFILES}" >>$PASSLOG
	

}

usage()
{
	echo " "
	echo "USAGE: $0 [+e passwd] [+p] [+P printer] [+m uname] [+r filename] [+o \"zipopts\"] zipname zipfiles"
	echo "+e forces password to be used on zipfile"
	echo "+p prints zipfile info & password to default printer"
	echo "+P prints zipfile info & password to specified printer"
	echo "+m emails uname zipfile info & password"
	echo "   For multiple recipients enclose the list of names in \" \" "
	echo "+r redirects zipfile info & password to specified filename"
	echo "+o options to send to ZIP.  Must be enclosed in double quotes."
	echo "zipname is the name of the zipfile to create"
	echo "zipfiles are the files to be zipped"
	echo " "
	echo "Program used to zip files: $ZIP"
	echo " "
}

gen_sn()
{
	if [ -f $QLOCKFILE ]
	then
		echo "Another process is currently generating a serial number."
		echo "Aborting..."
		exit 1 
	fi
	ABORTNODEL="0"
	touch $QLOCKFILE
	date +%Y%m%d%H%M%S
	sleep 1
	rm -f $QLOCKFILE
	ABORTNODEL="1"
}

trap_proc()
{
	if [ "$ABORTNODEL" -eq "0" ]
	then
		rm -f $QLOCKFILE 
	fi

}

mailuser()
{
	display_info | $MAILER -s "PDM zipfile information" $EMAIL 

}

printinfo()
{
PRN="$1"

	if [ "$PRN" = "DEFAULTPRINT" ]
	then

		display_info | lp

	else
	
		display_info | lp -d $PRN
	fi

}

redirectinfo()
{
FNAME="$1"
	display_info >> $FNAME
}	

display_info()
{
cat <<-DISPLAYINFO

Filename     : `fname_only $ZFILE`
Serial Number: $SN
Password     : $PASSWD 

DISPLAYINFO

}


###
# MAIN
###
trap trap_proc 0
SN=""
PASSWD=""
ZFILE=""
ZOPTS=""
ZFILES=""
PRINTER=""
EMAIL=""
DEFAULT_PRINT="0"
FILENAME=""

	

	if [ ! -w $PASSLOG ]
	then
		echo "Unable to write log to $PASSLOG"
		exit 1
	fi

	if [ "$#" -lt "2" ]
	then
		usage
		exit 1
	fi
	while [ "$1" != "" ]
	do
		case "$1" in

		"+e")
			PASSWD="$2"
			shift
			;;
		"+P")
			PRINTER="$2"
			shift
			;;
		"+p")
			DEFAULT_PRINT="1"
			;;
		"+o")
			ZOPTS="$2"
			shift
			;;
		"+m")
			EMAIL="$2"	
			shift
			;;
		"+r")
			FILENAME="$2"	
			shift
			;;
		*)
			ZFILE="$1"
			shift
			ZFILES="$*"
			break
			;;
		
		esac	

	shift
	done 




SN=`gen_sn`


if [ "$PASSWD" = "" ]
then
	PASSWD=`$RPASS`

fi

if [ "$ZFILE" = "" ]
then
	usage
	exit 1
fi

if [ "$ZFILES" = "" ]
then
	usage
	exit 1
fi

$ZIP $ZOPTS -P $PASSWD $ZFILE $ZFILES
retval="$?"


if [ "$retval" -ne "0" ]
then
	echo "Error zipping!"  
	exit 1
else
	echo "PDM Serial Number: $SN" | $ZIP -z $ZFILE >/dev/null
	logzip "$SN" "$ZFILE" "$PASSWD" "$EMAIL" "$ZOPTS" "$ZFILES"
fi

if [ "$EMAIL" != "" ]
then
	mailuser
fi

if [ "$PRINTER" != "" ]
then
	printinfo $PRINTER
fi

if [ "$DEFAULT_PRINT" -eq "1" ]
then
	printinfo "DEFAULTPRINT"
fi

if [ "$FILENAME" != "" ]
then
	redirectinfo $FILENAME
fi

exit 0

