#!/bin/ksh
#
# Program Name	: cleanup_phys340b.sh
# Description	: Convert specified phys340 file to PDF, email and archive
# Author	: Dawn M. Engler
# Date		: 02/27/2103
# Modifications : 10/07/2013 - Clean up create pdf logic(place all file in one loop and remove .lst), add logic to transfer pdfs to Phys340b wt-transfer  (DME)
#		: 11/25/2015 - Mail to and CC are in wrong spots. Correcting. (DME)
#		: 12/17/2015 - update email Body to only show current run files. (TT:13915-16 DME)
#		: 02/03/2016 - Add logic to Archive the Audit File. (TT:14705-3; DME)
#
#

# Variables Used:
ARCH_SHELL="/usr/lnk/shell/arch_phys340b.sh"
DATE=$1
WT_DIR=/usr/lnk/wt/Phys-340b
RPT_DIR="/usr/lnk/tmp"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="Group340B@pdmi.com"
MAIL_CC="Operations@pdmi.com"
MAIL_SUBJ="340b Physician Report"
MAIL_TEXT="${RPT_DIR}/phys340b.txt"
B_DIR=${WT_DIR}/PhysRpts

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conv_phys340b_rpts.sh <file date> 
	where <file date> includes date provided on physician file

ENDOFUSAGE
  exit 1
}

# Create PDF
pdf()
{
cd ${RPT_DIR}
for FILE in $(ls -1 phys340b-nonmatched-dea-$DATE phys340b-terms-*-$DATE phys340b-active-*-$DATE);
do
        if test -s ${FILE}
        then
                a2ps -1l132 -o - ${FILE} | ps2pdf - ${B_DIR}/${FILE}.pdf
        else
                echo "--*> The file ${FILE} does not exist."
        fi
done
}

#Email Notification to Group340b
email()
{
echo "The following 340b Physician Reports are available: " > ${MAIL_TEXT}
echo "LOCATION: clientfiles Phys340b/PhysRpts: " >> ${MAIL_TEXT}
echo "" >> ${MAIL_TEXT}

cd ${B_DIR}
if test $? -ne 0
then
	echo "-*> The Directory, ${340B_DIR} does not exist... " >> ${MAIL_TEXT}
	exit 1
fi
	ls -t1 *${DATE}* >> ${MAIL_TEXT}

cat ${MAIL_TEXT} | ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_CC} ${MAIL_TO}
}

# Remove and Archive Files
archive()
{
rm -f ${MAIL_TEXT}

${ARCH_SHELL} ${WT_DIR}/Phys_${DATE}.txt ${DATE}
${ARCH_SHELL} ${WT_DIR}/Phys_${DATE}_Audit.txt ${DATE}

cd ${RPT_DIR}
for FILE in $(ls -1 phys340b-terms-*-$DATE phys340b-active-*-$DATE phys340b-nonmatched-dea-$DATE);
do 
	${ARCH_SHELL} ${FILE} ${DATE}
done
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
   usage
fi

pdf

email

archive

exit 0
