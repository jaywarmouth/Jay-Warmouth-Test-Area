#!/bin/sh
#
#
# Program Name	: Medco_Formulary_file.sh
# Description	: Procedure to decrypt and upload Medco Formulary file To internal Transfers.
#		  Command Line Arguments:
#		  -d <ccyymmdd> - alternate date for input file; by default uses current date.
# Author	: Dawn M. Engler
# Date		: 07/29/2014
# Modifications : 01/13/2015 - replace "tshwartz" directory with "tyoung". Add "pvoytil" directory and email notifcation file is available. (TT:8864-11)(DME)
#		: 04/28/2015 - correct issue with MAIL_TO variable (DME)
#		: 06/06/2015 - correct issue with Mailing notifcation to the MAIL_TO variable twice. (DME)
#
#
#Variables Used:
PGP_CMD="/usr/bin/gpg"
PASSPHRASE="pgp123"
WT_DIR=/usr/lnk/wt/medco-ftp
DIR=/usr/lnk/shares/ftp-tmp
ZIP_PROG=/usr/bin/zip
DATE=`date +%Y%m%d`
PGP_FILE=""
OUT_DIR_1=/usr/lnk/wt/tyoung
OUT_DIR_2=/usr/lnk/wt/pvoytil
MAIL_PROG="/usr/bin/mutt"
MAIL_SUBJ="Medco Formulary File"
MAIL_TO="tyoung@pdmi.com,pvoytilla@pdmi.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: Medco_Formulary_file.sh 

ENDOFUSAGE
  exit 1
}

#
#Get File
get_file()
{
OUT_FILE=`echo ${PGP_FILE} | cut -c1-39` 
cp ${PGP_FILE} ${DIR}/${PGP_FILE}
}


#
#Decrypt File
decrypt_file()
{
cd ${DIR}	
cat ${PGP_FILE} | ${PGP_CMD} --no-tty --openpgp -d --passphrase ${PASSPHRASE} --output ${DIR}/${OUT_FILE}
${ZIP_PROG} -j ${DIR}/${DATE}-encrypted-files.zip ${DIR}/${PGP_FILE}
}

#
#Copy File to Transfers
copy_file()
{
cp ${OUT_FILE} ${OUT_DIR_1}
cp ${OUT_FILE} ${OUT_DIR_2}
}

#
#Email Notification
email_note()
{
echo "The ${OUT_FILE} is now available in your web transfer." | ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_CC} ${MAIL_TO}
}

#
#Cleanup 
cleanup()
{
rm -f ${WT_DIR}/${PGP_FILE}
rm -f ${DIR}/${PGP_FILE}
rm -f ${DIR}/${OUT_FILE}
}

#
#Main Routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done

cd ${WT_DIR}

for PGP_FILE in $(ls -1 PDMI_Formulary_File_????????.??????.txt.pgp);
do

	get_file
	decrypt_file
	copy_file
	email_note
	cleanup

done

exit 0
