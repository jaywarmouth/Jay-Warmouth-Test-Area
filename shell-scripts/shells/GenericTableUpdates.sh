#!/bin/sh
# 
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
DATETM=`date +%Y%m%d-%H%M%S`
WT_DIR="/usr/lnk/benefits/GenericTableUpdates/Test"

# Check for correct server
if [ ${HOSTNAME} != "prodtest10" ]
then
	echo -e "\nThis process can only be run on Prodtest10."
	echo "Press <enter> to exit."
	read REPLY
	exit 
fi

echo -e "\nThe input text file must be located in the"
echo "benefit-wt\GenericTableUpdates\Test folder"
echo "It can't include any spaces or special characters."
echo "Please type the input file name, then press <enter>:"
read IN_FILE

if test -s ${WT_DIR}/${IN_FILE}
then
	/usr/lnk/shell/gentb04.sh -i ${WT_DIR}/${IN_FILE} -o ${WT_DIR}/GENTB04-${DATETM}.csv > ${HOME}/gentb04 2>&1
else
	echo -e "\nThe file entered does not exist."
	echo "Press <enter> to exit."
	read REPLY
	exit 
fi

ecript -Rgj --non-printable-format=spaceo - ${HOME}/gentb04 | ps2pdf - ${WT_DIR}/gentb04-${DATETM}.pdf

echo -e "\nThe test update has been run."
echo "See report results in GenericTableUpdates/Test folder."
echo "Press <enter> to finalize process."
read REPLY

exit 0
