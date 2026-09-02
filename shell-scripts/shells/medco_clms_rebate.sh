#!/bin/sh
#
#
# Program Name	: medco_clms_rebate.sh.sh
# Description	: Procedure to decrypt and upload Medco Claims Rebate file To internal Transfers.
#		  Command Line Arguments:
#		  -d <ccyymmdd> - alternate date for input file; by default uses current date.
# Author	: Dawn M. Engler
# Date		: 01/19/2015
# Modifications : 03/17/2015 - updates to fix process failures.
#		: 10/16/2018 - TT17992-23; add dhomoly/jcolatruglio WT distribution.
#		: 08/05/2019 - TT16011-29
#
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
OUT_DIR_3=/usr/lnk/wt/sqlimports/ESI
OUT_DIR_4=/usr/lnk/wt/dhomoly
OUT_DIR_5=/usr/lnk/wt/jcolatruglio
OUT_DIR_6=/usr/lnk/wt/cbruss
MAIL_PROG="/usr/bin/mutt"
MAIL_SUBJ="Medco Claims Rebate File"
MAIL_TO="warehouse@pdmi.com tyoung@pdmi.com pvoytilla@pdmi.com jcolatruglio@pdmi.com dhomoly@pdmi.com cbruss@pdmi.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: medco_clms_rebate.sh 

ENDOFUSAGE
  exit 1
}

#
#Get File
get_file()
{
OUT_FILE=`echo ${PGP_FILE} | cut -c1-43` 
cp ${WT_DIR}/${PGP_FILE} ${DIR}/${PGP_FILE}
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
cp ${DIR}/${OUT_FILE} ${OUT_DIR_1}
cp ${DIR}/${OUT_FILE} ${OUT_DIR_2}
cp ${DIR}/${OUT_FILE} ${OUT_DIR_3}
cp ${DIR}/${OUT_FILE} ${OUT_DIR_4}
cp ${DIR}/${OUT_FILE} ${OUT_DIR_5}
cp ${DIR}/${OUT_FILE} ${OUT_DIR_6}
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

for PGP_FILE in $(ls -1 PDMI_External_Claims_Rebate_????????.??????.pgp);
do

	get_file
	decrypt_file
	copy_file
	email_note
	cleanup

done

exit 0
