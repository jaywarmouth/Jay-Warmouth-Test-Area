#!/bin/ksh
#
# Program Name  : fax-claim19.sh
# Description   : Print/Fax claim19 Audit report
#                 Command line arguments:
# Author        : Christina M. Senediak
# Date          : 07/15/96
# Modifications : 
#
# Variables Used:
RUNPATH=claims:tmp2:tmp ; export RUNPATH
REPLY="0"
PRINT_FILE=/tmp/LST19$1



echo "\nEnter selection : 1. Print the report"
echo "                  2. Fax the report"
echo "                  3. Exit"
while test $REPLY -ne 3
do
  read REPLY
  case $REPLY in
    "1")  lp ${PRINT_FILE}
          exit 0;
          ;;
    "2") echo "\nWho are you sending this to :"
         read FAXTO
         echo "\nWhat is their fax number    :"
         read FXNUM
         fax "${FAXTO}" ${PRINT_FILE} $FXNUM 132 
         exit 0;
         ;;
    "3") exit 0                 
         ;;
    "*") echo "Invalid choice\n"
         ;;
  esac
done
