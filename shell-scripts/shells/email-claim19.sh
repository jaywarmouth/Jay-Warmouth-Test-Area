#!/bin/sh
#
# Program Name  : email-claim19.sh
# Description   : Print/Email claim19 Audit report
#                 Command line arguments:
# Author        : Linda S. Jefferis
# Date          : 04/18/2016
# Modifications : 10/19/2018 - Joe Simko - Add logic to disable sending email to external (non-PDMI) email addresses 
#		: 01/25/2019 - TT13915-81
#		: 04/27/2020 - Cherwell 12120 - Change email line to read the MAIL_TO before the Attachemnt. (DME)
#
# Variables Used:
REPLY="0"
PRINT_FILE=/tmp/LST19$1
MAIL_PROG="/usr/bin/mutt"

#

echo "\nEnter selection : 1. Print the report"
echo "                  2. Email the report"
echo "                  3. Exit"
while test $REPLY -ne 3
do
  read REPLY
  case $REPLY in
    "1")  lp ${PRINT_FILE}
          exit 0;
          ;;
    "2") echo "\nEnter your email address :"
         read MAIL_TO
	 enscript -rBgj -f Courier9 --non-printable-format=space -o - ${PRINT_FILE} | ps2pdf - ${PRINT_FILE}.pdf
	 result=`echo "${MAIL_TO}" | grep -c  "@pdmi.com"`

if [ "$result" -eq "1" ]
then   
	result=`echo "${MAIL_TO}" | awk -F"@" '{ print NF-1 }'`
else
	result="-1"
fi

if [ "$result" -eq "1" ]
then   
   echo "Requested Claim19 Report is attached." | ${MAIL_PROG} -s "Claim19 Report" ${MAIL_TO} -a ${PRINT_FILE}.pdf
else
   echo 'Invalid Email Address. Only @pdmi.com Email Addresses are allowed'
   read -p "Press enter to continue"
fi
         exit 0;
         ;;
    "3") exit 0                 
         ;;
    "*") echo "Invalid choice\n"
         ;;
  esac
done
