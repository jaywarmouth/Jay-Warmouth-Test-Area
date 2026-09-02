#!/bin/sh
# 
# Program Name	: decrypt_file.sh
# Description	: Decrypt incoming eligibility files for processing.
# Modifcation   : 6/11/2014 - Add check for running on Robin or husk and add ssh for any system that is not husk or robin. (TT:10901-1) (DME)
#

#Variables Used:
PGP_CMD="/usr/bin/gpg"
PASSPHRASE="pgp123"
PGP_FILE=$1
OUT_FILE=$2
DIR=/usr/lnk/shares/ftp-tmp
host=`/bin/hostname -s`
ZIP_PROG=/usr/bin/zip
DATE=`date +%Y%m%d`
#
#Usage Routine
#
usage()
{
	echo ""
	echo "USAGE:"
	echo "decrypt_file.sh encrypted_filename out_filename"
	echo ""
}

#
#ssh for use on production systems
#
remote()
{
ssh husk "$PGP_CMD" --no-tty --openpgp --passphrase "$PASSPHRASE" --output "$DIR/$OUT_FILE" -d "$DIR/$PGP_FILE"
ssh husk "$ZIP_PROG" -j "$DIR/$DATE-encrypted-files.zip" "$DIR/$PGP_FILE" 
exit
}


if [ $# -lt 2 ]
then
	usage
	exit 1
fi


if [ "$host" == "robin" -o "$host" == "husk" ]
then
	cat $DIR/$PGP_FILE | $PGP_CMD --openpgp -d --passphrase $PASSPHRASE --output $DIR/$OUT_FILE
        $ZIP_PROG -j $DIR/$DATE-encrypted-files.zip $DIR/$PGP_FILE
else
 echo "Running decrypt on remote system!"
 remote
fi

exit 0
