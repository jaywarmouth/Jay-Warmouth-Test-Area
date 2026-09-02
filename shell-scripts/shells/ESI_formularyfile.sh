#!/bin/sh
#
# Description	: Procedure to rename and distribute ESI Formulary file To internal Transfers.
#
#
#Variables Used:
WT_DIR=/usr/lnk/wt/oper-wt/ESIFormulary
OUT_DIR_1=/usr/lnk/wt/tyoung
OUT_DIR_2=/usr/lnk/wt/pvoytil
OUT_DIR_3=/usr/lnk/wt/jcolatruglio
OUT_DIR_4=/usr/lnk/wt/cbruss
ESI_ARCH=/usr/lnk/wt/oper-wt/ESIFormulary/Archive
MAIL_PROG="/usr/bin/mutt"
MAIL_SUBJ="ESI Formulary File"
MAIL_TO="clinicalsupport@pdmi.com,pvoytilla@pdmi.com"
MAIL_CC="operations@pdmi.com"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ESI_formularyfile.sh InputFilename OutFilename

ENDOFUSAGE
  exit 99
}

#
#Get File
get_file()
{
cd ${WT_DIR}
ESI_FILE=`ls -1 ${INFILE}`
PARTNAME=`echo ${ESI_FILE} | awk -F"." '{ print $1 }'`
FILEDATE=`echo ${PARTNAME} | awk -F"_" '{ print $5 }'`
OUT_FILE=${OUTNAME}_${FILEDATE}.txt
cp ${ESI_FILE} ${OUT_FILE}
RETVAL=$?
}


#
#Copy File to Transfers
copy_file()
{
cp ${WT_DIR}/${OUT_FILE} ${OUT_DIR_1}
cp ${WT_DIR}/${OUT_FILE} ${OUT_DIR_2}
cp ${WT_DIR}/${OUT_FILE} ${OUT_DIR_3}
cp ${WT_DIR}/${OUT_FILE} ${OUT_DIR_4}
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
mv ${WT_DIR}/${ESI_FILE} ${ESI_ARCH}
rm -f ${WT_DIR}/${OUT_FILE}
}

#
#Main Routine
#

# Check command line validity, call usage if incorrect
INFILE=$1
OUTNAME=$2

RETVAL=0
get_file
if [ $RETVAL -ne 0 ]
then
	echo "-*> Issue with get_file "
	exit 99
fi
get_file
copy_file
email_note
cleanup

exit $RETVAL

