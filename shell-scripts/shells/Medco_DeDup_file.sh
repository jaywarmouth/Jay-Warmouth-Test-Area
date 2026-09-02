#!/bin/sh
#
#
# Program Name	: Medco_DeDup_file.sh
# Description	: Procedure to decrypt and upload Medco Rebate Max DeDup file To internal Transfers.
#		  Command Line Arguments:
#		  -d <ccyymmdd> - alternate date for input file; by default uses current date.
# Author	: Dawn M. Engler
# Date		: 12/03/2015
# Modifications :
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
OUT_DIR_1=/usr/lnk/wt/sqlimports/ESI

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

for PGP_FILE in $(ls -1 RebateMax_DeDup2077_????????.??????.txt.pgp);
do

	get_file
	decrypt_file
	copy_file
	cleanup

done

exit 0
