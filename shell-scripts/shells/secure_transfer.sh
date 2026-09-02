#!/bin/sh
#
#
# Shell for transferring files via SSH or PGP/FTP
# VERSION 2.3

CONFIG_FILE="/usr/local/pub/secure_transfer.cfg"
PGP_CMD="/usr/bin/gpg --openpgp "
CIPHER_ALGO="3DES"
FTP_CMD="/usr/kerberos/bin/ftp"
SFTP_CMD="/usr/bin/sftp"
PGP_TMPDIR="/tmp"
TRANSFER_KEY="PDM File Transfers"
CORPORATE_KEY="Pharmacy Data Management, Inc"
TMPFILE="/tmp/secure_transfer.$$"
trap 'rm -f $TMPFILE $PGPFILELIST' 0

#set -x


do_sftp() {
sourcefiles="$1"
fcname="$2"
fip="$3"
flogin="$4"
fpassword="$5"
showpw="$6"
fdestdir="$7"
		
		echo "cd $fdestdir" >$TMPFILE

		echo "ls -l" >>$TMPFILE

		for sourcefile in `echo $sourcefiles`
		do

			if [ ! -r "$sourcefile" ]
			then
				echo "Unable to open $sourcefile for read."
				echo "Aborting."
				exit 1
			fi

			echo "put $sourcefile" >>$TMPFILE
		done

		echo "ls -l" >>$TMPFILE
		echo "quit" >>$TMPFILE

		if [ "$INTERACTIVE" -eq "0" ]
		then
			BATCH_PARAM="-b $TMPFILE"
			echo "Sending file(s) to $fcname ($ID)"
		else
			BATCH_PARAM=""
		fi

		
		if [ "$showpw" -eq "1" ]
		then
			echo " "
			echo "**************************"
			echo "Password is $fpassword"
			echo "**************************"
			echo " "
		fi

		$SFTP_CMD $BATCH_PARAM ${flogin}@${fip}
		RETVAL="$?"

		if [ "$RETVAL" -ne "0" ]
			then
			echo "Error during transfer to $ID"
			exit 1
		fi


}

do_sftppgp() {
sourcefiles="$1"
fcname="$2"
fip="$3"
flogin="$4"
fpassword="$5"
showpw="$6"
fdestdir="$7"
pgpkey="$8"

#set -x
		echo "cd $fdestdir" >>$TMPFILE

		echo "ls -l" >>$TMPFILE

		PGPFILELIST=""

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
			
                        echo "put ${PGP_TMPDIR}/$PGPFILE" >>$TMPFILE
			PGPFILELIST="${PGPFILELIST} ${PGP_TMPDIR}/${PGPFILE}"
                done
		

		echo "ls -l" >>$TMPFILE
		echo "quit" >>$TMPFILE

		if [ "$INTERACTIVE" -eq "0" ]
		then
			BATCH_PARAM="-b $TMPFILE"
			echo "Sending file(s) to $fcname ($ID)"
		else
			BATCH_PARAM=""
		fi

		
		if [ "$showpw" -eq "1" ]
		then
			echo " "
			echo "**************************"
			echo "Password is $fpassword"
			echo "**************************"
			echo " "
		fi

		$SFTP_CMD $BATCH_PARAM ${flogin}@${fip}
		RETVAL="$?"

		if [ "$RETVAL" -ne "0" ]
			then
			echo "Error during transfer to $ID"
			exit 1
		fi


}

do_pgp() {

sourcefiles="$1"
fcname="$2"
fip="$3"
flogin="$4"
fpassword="$5"
showpw="$6"
fdestdir="$7"
pgpkey="$8"

		echo "user $flogin $fpassword" >$TMPFILE
		echo "passive" >>$TMPFILE
		echo "bin" >>$TMPFILE
		echo "cd $fdestdir" >>$TMPFILE

		echo "ls -l" >>$TMPFILE

		PGPFILELIST=""

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
			PGPFILELIST="${PGPFILELIST} ${PGP_TMPDIR}/${PGPFILE}"
                done


		echo "ls -l" >>$TMPFILE
		echo "quit" >>$TMPFILE

		if [ "$showpw" -eq "1"  -a  "$INTERACTIVE" -eq "1" ]
		then
			echo " "
			echo "**************************"
			echo "Login is $flogin"
			echo "Password is $fpassword"
			echo "**************************"
			echo " "
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

}

do_web()
{
sourcefiles="$1"
destdir="$2"

	
	if [ "$INTERACTIVE" -eq "1" ]
	then
		echo "$ID: WEB type entries cannot be run in 'interactive' mode"
		exit 1
	fi
	ls -l $destdir
	echo "Copying files for $fcname ($ID)"
	cp $sourcefiles $destdir
	RETVAL="$?"

	if [ "$RETVAL" -ne "0" ]
		then
		echo "Error during transfer to $ID"
		exit 1
	fi
	ls -l $destdir

}

do_goany()
{
sourcefiles="$1"
destdir="$2"

	
	if [ "$INTERACTIVE" -eq "1" ]
	then
		echo "$ID: GOANY type entries cannot be run in 'interactive' mode"
		exit 1
	fi
#	ls -l $destdir
	/usr/local/bin/aws s3 ls $destdir
	echo "Copying files for $fcname ($ID)"
	/usr/local/bin/aws s3 cp $sourcefiles $destdir --only-show-errors
	RETVAL="$?"

	if [ "$RETVAL" -ne "0" ]
		then
		echo "Error during transfer to $ID"
		exit 1
	fi
#	ls -l $destdir
	/usr/local/bin/aws s3 ls $destdir
}

do_webpgp()
{
sourcefiles="$1"
destdir="$2"
pgpkey="$3"


                PGPFILELIST=""

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

                        PGPFILELIST="${PGPFILELIST} ${PGP_TMPDIR}/${PGPFILE}"
                done


        if [ "$INTERACTIVE" -eq "1" ]
        then
                echo "$ID: WEBPGP type entries cannot be run in 'interactive' mode"
                exit 1
        fi
        ls -l $destdir

        echo "Copying files for $fcname ($ID)"
        cp ${PGPFILELIST} $destdir
        RETVAL="$?"

        if [ "$RETVAL" -ne "0" ]
                then
                echo "Error during transfer to $ID"
                exit 1
        fi

        ls -l $destdir

}

list_ids() 
{

	/bin/echo -e "ID\tName"
	IFS="$CR"
	for line in `cat $CONFIG_FILE | grep -v "^#"`
	do
		IFS="$OIFS"
		ftranstype=`echo $line | awk -F\| '{ print $2 }'`		
		fcname=`echo $line | awk -F\| '{ print $3 }'`		
		fid=`echo $line | awk -F\| '{ print $1 }'`		

		/bin/echo -e "${fid} (${ftranstype})\t${fcname}" >>$TMPFILE

	done
	cat $TMPFILE | /bin/sort

}

usage()
{
	echo "USAGE:"
	echo "secure_transfer.sh id filename [filename] [filename...]"
	echo "secure_transfer.sh -i id"
	echo "secure_transfer.sh -l"
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

INTERACTIVE="0"



if [ ! -r "$CONFIG_FILE" ]
then
	echo "Config file $CONFIG_FILE could not be read!"
	exit 1
fi

CR="
"
OIFS="$IFS"



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
	fid=`echo $line | awk -F\| '{ print $1 }'`		

	if [ "$ID" = "$fid" ]
	then
		FOUND="1"
		ftranstype=`echo $line | awk -F\| '{ print $2 }'`		
		fcname=`echo $line | awk -F\| '{ print $3 }'`		
		fip=`echo $line | awk -F\| '{ print $4 }'`		
		flogin=`echo $line | awk -F\| '{ print $5 }'`		
		fpassword=`echo $line | awk -F\| '{ print $6 }'`		
		showpw=`echo $line | awk -F\| '{ print $7 }'`		
		fdestdir=`echo $line | awk -F\| '{ print $8 }'`		
		pgpkey=`echo $line | awk -F\| '{ print $9 }'`		
		
		case $ftranstype in
		pgp|PGP)

			do_pgp "$sourcefiles" "$fcname" "$fip" "$flogin" "$fpassword" "$showpw" "$fdestdir" "$pgpkey"

			;;
		sftp|SFTP)
			do_sftp "$sourcefiles" "$fcname" "$fip" "$flogin" "$fpassword" "$showpw" "$fdestdir" 

			;;
		SFTPPGP|sftppgp)

			do_sftppgp "$sourcefiles" "$fcname" "$fip" "$flogin" "$fpassword" "$showpw" "$fdestdir" "$pgpkey"

			;;
		WEB|web)

			do_web "$sourcefiles" "$fdestdir" 

			;;
		GOANY|goany)

			do_goany "$sourcefiles" "$fdestdir" 

			;;
		WEBPGP|webpgp)

			do_webpgp "$sourcefiles" "$fdestdir" "$pgpkey"

			;;
		*)
			echo "Invalid transfer type \"${ftranstype}\""
			exit 1
			;;

		esac

	fi
	IFS="$CR"
done


	if [ "$FOUND" -ne "1" ]
	then
		echo "ID $ID not found in database."
		exit 1
	fi



# rm -f $TMPFILE

IFS=$OIFS
if [ "$PGPFILELIST" != "" ]
then
	rm -f $PGPFILELIST
fi

exit 0

