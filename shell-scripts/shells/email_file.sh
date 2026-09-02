#!/bin/ksh
#
# Program Name  : email_file.sh
# Description   : File provided on command line is converted to PDF and emailed.
#                 Command line arguments:
# Author        : Linda S. Jefferis
# Date          : 12/02/2016
# Modifications : 
#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"

#
usage()
{
	echo "USAGE:"
	echo "email_file.sh filename"
	echo "filename - file to be converted to PDF and emailed"
}

process_file()
{
	enscript -rgj -f Courier9 --non-printable-format=space -o - ${INFILE} | ps2pdf - ${INFILE}.pdf
	echo "Requested Report File is attached." | ${MAIL_PROG} -s "Report Email" -a ${INFILE}.pdf ${MAIL_TO}
}

# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
   usage
   exit 1
fi

INFILE=$1
if test -s $INFILE
then
	if [ "$EMAIL_ADDRESS" = "" ]
	then
		echo "\nEnter your email address :"
		read MAIL_TO
		process_file
	else
		MAIL_TO=$EMAIL_ADDRESS
		process_file
	fi
else
	echo "\nThe Report File is blank or does not exist"
fi
		
exit 0
