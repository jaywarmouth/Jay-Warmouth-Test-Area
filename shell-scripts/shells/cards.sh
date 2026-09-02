#!/bin/sh
#
# Program Name	: cards.sh
# Description	: Card Production
#                 Command line arguments:
#                 -u Turns off update of EMBOS00MAS
#		: 8/29/2013 - Changed MAIL_TO from operations to cards
#		: 09/30/2016 - Change REMOTE_DIR
#		: 04/29/2020 - Updated scp commands (-p)
#		: 02/02/2022 - Change REMOTE_DIR (from "/usr/lnk/shares/ftp-tmp" to "/usr/lnk/wt/oper-wt/IDCards")
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
CARD_DIR="/usr/lnk/cards"
DATE=`date +%Y%m%d`
EMB_LOG="$CARD_DIR/${DATE}-cardfilelist.csv"
JJHC_FILE="$CARD_DIR/JJHC.TXT"
MYO_FILE="$CARD_DIR/MYO-????.TXT"
LLS_FILE="$CARD_DIR/PAF-LLS.TXT"
LSHMISC_FILE="$CARD_DIR/LSH-MISC.TXT"
LSH1113_FILE="$CARD_DIR/LSH-1113.TXT"
UPDATE=0
REMOTE_DIR="/usr/lnk/wt/oper-wt/IDCards"
IDCARD_LIST="$CARD_DIR/card-list"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="cards@pdmi.com"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cards.sh [-u]

ENDOFUSAGE
  exit 1
}

#
# Card Counts
card_counts()
{
	for file in $(ls -1 *.TXT);
	do
		REC_CNT=`wc -l ${file} | awk '{print $1}'`
        	REC_CNT=`expr $REC_CNT - 1`
		echo "$file,$REC_CNT" >> ${EMB_LOG}
	done
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -u) UPDATE=1
        ;;
  esac
  shift
done

umask 002

if test -s ${JJHC_FILE}
then
	echo "--*> A JJHC.TXT file exists from a previous run!!!"
	echo "--*> Process is aborting. Fix and then rerun!!"
	exit 1
fi

cd ${CARD_DIR}

enscript -rgj -f Courier9 -a2- -o - ${IDCARD_LIST} | ps2pdf - ${IDCARD_LIST}.pdf
cp -p ${IDCARD_LIST}.pdf ${REMOTE_DIR}/${DATE}-card-list.pdf

rm -f ${CARD_DIR}/TXTCR00MAS
rm -f ${CARD_DIR}/CARR000MAS

if [ ${UPDATE} = 0 ]
then
	${SHELL_DIR}/cardh27.sh -t normal
fi
if [ ${UPDATE} = 1 ]
then
	${SHELL_DIR}/cardh27.sh -t normal -u 
fi


echo "CARD FILE,COUNT,PRINTED,NOTES" > ${EMB_LOG}
card_counts

echo "ID Card File List for `date +%D` is attached." | ${MAIL_PROG} -s "ID Card File List" ${MAIL_TO} -a ${EMB_LOG}

cp -p *.TXT ${REMOTE_DIR}

if test -s ${JJHC_FILE}
then
	/usr/lnk/shell/process_jjhc.sh
	RETVAL-JJHC=$?
fi

ls -1 ${MYO_FILE}
MYO_FILEFLG=$?
if [ ${MYO_FILEFLG} -eq 0 ]
then
	/usr/lnk/shell/process_myocardfiles.sh
	RETVAL-MYO=$?
	if [ ${RETVAL-MYO} -ne 0 ]
	then
		echo "-*> NOT able to process/distribute the MYO card file(s)" | ${MAIL_PROG} -s "Issue with MyoDerm card file distribution" ${MAIL_TO}
	fi
fi

if test -s ${LLS_FILE}
then
	/usr/lnk/shell/process_llscardfiles.sh
	RETVAL-LLS=$?
	if [ ${RETVAL-LLS} -ne 0 ]
        then
                echo "-*> NOT able to process/distribute the PAF-LLS card file(s)" | ${MAIL_PROG} -s "Issue with PAF-LLS card file distribution" ${MAIL_TO}
        fi
fi


if test -s ${LSHMISC_FILE}
then
	/usr/lnk/shell/process_lshmisccardfiles.sh
	RETVAL-LSHMISC=$?
	if [ ${RETVAL-LSHMISC} -ne 0 ]
        then
                echo "-*> NOT able to process/distribute the LSH-MISC card file(s)" | ${MAIL_PROG} -s "Issue with LSH-MISC card file distribution" ${MAIL_TO}
        fi
fi

if test -s ${LSH1113_FILE}
then
	/usr/lnk/shell/process_lsh1113cardfiles.sh
	RETVAL-LSH1113=$?
	if [ ${RETVAL-LSH1113} -ne 0 ]
        then
                echo "-*> NOT able to process/distribute the LSH-1113 card file(s)" | ${MAIL_PROG} -s "Issue with LSH-1113 card file distribution" ${MAIL_TO}
        fi
fi


exit 0
