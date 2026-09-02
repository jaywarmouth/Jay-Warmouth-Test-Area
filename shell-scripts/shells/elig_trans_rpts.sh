#!/bin/sh
#
# Program Name	: elig_trans_rpts.sh
# Description	: Convert eligibility transaction files to PDF and email notification
# Author	: Dawn M. Engler
# Date		: 07/24/2013
# Modifications	: 01/10/2020 - Change "a2ps" to "enscript"

#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="benefits@pdmi.com"
MAIL_CC="Operations@pdmi.com"
MAIL_SUBJ="Eligibility Transaction Reports"
ELIG_DIR="/usr/lnk/elig_out"
WT_DIR="/usr/lnk/wt/benefit-wt/trrxelig"
DATE=`date +%m%d%Y`
MAIL_TEXT=/usr/lnk/tmp/ben_elig
SYS_NUM=$1
SYS_DIR="sys${SYS_NUM}"

#
#Called functions:
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elig_trans_rpts.sh <System_Number>
        where <System_Number> includes 4 digit system number.

ENDOFUSAGE
  exit 1
}

# Create PDF and transfer to benefit-wt
#
pdf()
{
for FILE in $(ls -1  ${SYS_NUM}CA29${DATE}.*);
do
        if test -s ${FILE}
        then
                enscript -rgj -f Courier9 --non-printable-format=space -o - ${FILE} | ps2pdf - ${WT_DIR}/${FILE}.pdf
		
	else
                echo "--*> The file ${FILE} does not exist."
        fi
done
}


#Email Notification to Benefits
email()
{
echo "The following eligibility transaction reports are available:" > ${MAIL_TEXT}
        echo "LOCATION:  clientfiles benefit-wt/trrxelig: " >> ${MAIL_TEXT}
        echo "" >> ${MAIL_TEXT}
        cd ${WT_DIR}
        if test $? -ne 0
        then
                echo "-*> The directory, ${WT_DIR}, does not exist..."
                exit 1
        fi
        ls -t1 >> ${MAIL_TEXT}

cat ${MAIL_TEXT}| ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_TO} ${MAIL_CC}
}


# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
   usage
fi

#
# Main routine
#

cd $ELIG_DIR/${SYS_DIR}
pdf
email

# Remove Files
rm -f ${MAIL_TEXT}

exit 0
