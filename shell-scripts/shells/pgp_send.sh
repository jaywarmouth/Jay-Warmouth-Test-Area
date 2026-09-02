#!/bin/sh

CONFIG_FILE="/usr/local/pub/pgp_send.cfg"
PGP_CMD="/usr/bin/gpg"
CIPHER_ALGO="3DES"
FTP_CMD="/usr/kerberos/bin/ftp"
PGP_TMPDIR="/tmp"
TRANSFER_KEY="PDM File Transfers"
CORPORATE_KEY="Pharmacy Data Management, Inc"

#set -x

list_ids() 
{

	/bin/echo -e "ID\tName"
	IFS="$CR"
	for line in `cat $CONFIG_FILE | grep -v "^#"`
	do
		IFS="$OIFS"
		fcname=`echo $line | awk -F: '{ print $2 }'`		
		fid=`echo $line | awk -F: '{ print $1 }'`		

		/bin/echo -e "${fid}\t${fcname}" >>$TMPFILE

	done
	cat $TMPFILE | /bin/sort

}

usage()
{
	echo "USAGE:"
	echo "pgp_send.sh id filename"
	echo "pgp_send.sh -i id"
	echo "pgp_send.sh -l"
	echo "-i 	- interactive mode"
	echo  "-l  	- list available IDs"
	echo  "id  	- ID to send to"
	echo  "filename - file to send."
	echo " "
	echo "Config file located at $CONFIG_FILE"

}

#
# MAIN
#
# Version 2.0

INTERACTIVE="0"



if [ ! -r "$CONFIG_FILE" ]
then
	echo "Config file $CONFIG_FILE could not be read!"
	exit 1
fi

CR="
"
OIFS="$IFS"

TMPFILE="/tmp/pgp_send.$$"

trap 'rm -f $TMPFILE' 0


# touch $TMPFILE
# chmod 600 $TMPFILE

if [ "$1" = "-l" ]
then

	list_ids
	exit 0
fi 

if [ "$1" = "-i" ]
then

	INTERACTIVE="1"
	shift
elif [ "$2" = "" ]
then
	usage
	exit 1
fi

ID="$1"
shift
sourcefiles="$*"


if [ "$USER" != "operator" ]
then
	echo "**************"
	echo "WARNING: This program was intended to be used with the operator user."
	echo "Your mileage may vary."
fi
	echo "**************"


IFS="$CR"
FOUND="0"
for line in `cat $CONFIG_FILE | grep -v "^#"`
do
	IFS="$OIFS"
	fid=`echo $line | awk -F: '{ print $1 }'`		

	if [ "$ID" = "$fid" ]
	then
		FOUND="1"
		fcname=`echo $line | awk -F: '{ print $2 }'`		
		fip=`echo $line | awk -F: '{ print $3 }'`		
		flogin=`echo $line | awk -F: '{ print $4 }'`		
		fpassword=`echo $line | awk -F: '{ print $5 }'`		
		showpw=`echo $line | awk -F: '{ print $6 }'`		
		fdestdir=`echo $line | awk -F: '{ print $7 }'`		
		pgpkey=`echo $line | awk -F: '{ print $8 }'`		
		
#	Creating script
		
		echo "user $flogin $fpassword" >$TMPFILE
		echo "bin" >>$TMPFILE
		echo "cd $fdestdir" >>$TMPFILE

		echo "ls -l" >>$TMPFILE

                for sourcefile in `echo $sourcefiles`
                do

                        if [ ! -r "$sourcefile" ]
                        then
                                echo "Unable to open $sourcefile for read."
                                echo "Aborting."
                                exit 1
                        fi
                        # sf_path=`echo $sourcefile | awk '{match($1, "^.*/"); print substr($1, 1, RLENGTH-1)}'`
                        sf_file=`echo $sourcefile | awk  -F/ '{ print $NF }'`
			
			PGPFILE="${sf_file}.pgp"

			cat $sourcefile | $PGP_CMD --yes --cipher-algo $CIPHER_ALGO -e -r "$CORPORATE_KEY" -r "$TRANSFER_KEY" -r "$pgpkey" --output ${PGP_TMPDIR}/${PGPFILE}
			
                        echo "lcd $PGP_TMPDIR" >>$TMPFILE
                        echo "put $PGPFILE" >>$TMPFILE
                done


		echo "ls -l" >>$TMPFILE
		echo "quit" >>$TMPFILE

		if [ "$showpw" -eq "1"  -a  "$INTERACTIVE" -eq "1" ]
		then
			echo "Login is $flogin"
			echo "Password is $fpassword"
		fi

		if [ "$INTERACTIVE" -eq "0" ]
		then
			echo "Sending file(s) to $fcname ($ID)"
			cat $TMPFILE | $FTP_CMD -u $fip
		else
			# Only send first line
			$FTP_CMD $fip
		fi

		

		RETVAL="$?"

		if [ "$RETVAL" -ne "0" ]
			then
			echo "Error during transfer to $ID"
			exit 1
		fi

	fi

	IFS="$CR"
done

	if [ "$FOUND" -ne "1" ]
	then
		echo "ID $ID not found in database."
		exit 1
	fi



# rm -f $TMPFILE

exit 0

