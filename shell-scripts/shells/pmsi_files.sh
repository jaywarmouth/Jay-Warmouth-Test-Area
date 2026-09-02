#!/bin/sh
#
# Program Name	: pmsi_files.sh
# Description	: Procedure to setup Billing Cycle files for PMSI (sys0103)
#		  Command Line Arguments:
#		  -d  Set alternate date for certain filenames <yymmddhhmm>
#		  -t  Test file flag
#		  -s <####> Alternate sequence number (e.g. 0002)
# Author	: Linda S. Jefferis
# Date		: 07/06/2007
# Modifications : 10/05/2007 - Changed names of files and removed TYPE logic  (LSJ)
#		: 10/08/2007 - Added logic to display SEQ_NUM to record in log entry  (LSJ)
#		: 11/30/2007 - Added "-s" logic  (LSJ)
#		: 03/04/2008 - Added new SUM_FILE logic and ERROR logic  (LSJ)
#		: 03/04/3008 - Removed "seconds(ss)" from DATE  (LSJ)
#		: 03/21/2008 - Added different TR_ID when test run  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
CLM_FILE="???CL131-T-PMSI"
TEXT_FILE="???PMSITEXT"
PAT_FILE="???CL131PAT-T-PMSI"
PHA_FILE="???CL131PHARM-T-PMSI"
SUM_FILE="???CL131SUMMARY-T-PMSI"
TRANSFER_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="PMSI-BILL"
DATE=`date +%y%m%d%H%M`
YEAR=`date +%Y`
YR=`echo ${YEAR} | cut -c4`
SEQ_FILE="/usr/lnk/tapes/pmsi/pmsi_seq_ctrl_${YEAR}.txt"
TMP_SEQ_FILE="/tmp/pmsi_new_seq.txt"
ALT_SEQ_FLG=0
ERROR=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pmsi_files.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Get sequence number
get_seq()
{
   if [ ${ALT_SEQ_FLG} = 1 ]
   then
	SEQ_NUM=${ALT_SEQ_NUM}
   else
   	if test -s ${SEQ_FILE}
   	then
		LAST_SEQ=`cat ${SEQ_FILE}`
		NEW_SEQ_NUM=`expr $LAST_SEQ + 1`
		CNT=`expr $NEW_SEQ_NUM : '[0-9]*'`
		case $CNT in
		  "1") SEQ_NUM="000$NEW_SEQ_NUM"
			;;
		  "2") SEQ_NUM="00$NEW_SEQ_NUM"
			;;
		  "3") SEQ_NUM="0$NEW_SEQ_NUM"
			;;
		  "4") SEQ_NUM="$NEW_SEQ_NUM"
			;;
		esac
		echo $SEQ_NUM > ${TMP_SEQ_FILE}
   	else
		echo "0000" > ${SEQ_FILE}
		get_seq
   	fi
   fi
}

#
# Get Record Counts
get_counts()
{
#	REC_CNT=`wc -l ${FILE_LOC}${PAT_FILE} | awk '{print $1}'`
#	convert_count
#	PAT_CNT=${NEW_REC_CNT}
	PAT_CNT=`grep "PATIENT RECORDS WRITTEN:" ${FILE_LOC}/${TEXT_FILE} | awk '{print $5}' | cut -c 1-7`
	REC_CNT=`wc -l ${FILE_LOC}/${PHA_FILE} | awk '{print $1}'`
	convert_count
	PHA_CNT=${NEW_REC_CNT}
#	PHA_CNT=`grep "TOTAL PHARMACY RECORDS:" ${FILE_LOC}/${TEXT_FILE} | awk '{print $5}' | cut -c 1-7`
#	REC_CNT=`wc -l ${FILE_LOC}${CLM_FILE} | awk '{print $1}'`
#        convert_count
#        CLM_CNT=${NEW_REC_CNT}	
	CLM_CNT=`grep "CLAIMS WRITTEN:" ${FILE_LOC}/${TEXT_FILE} | awk '{print $4}' | cut -c 1-7`
	INV_AMT=`grep "TOTAL PAID:" ${FILE_LOC}/${TEXT_FILE} | awk '{print $4}' | cut -c1-11`
}

#
# Convert Count
convert_count()
{
	CNT=`expr $REC_CNT : '[0-9]*'`
	case $CNT in
	  "1") NEW_REC_CNT="000000$REC_CNT"
                ;;
          "2") NEW_REC_CNT="00000$REC_CNT"
                ;;
          "3") NEW_REC_CNT="0000$REC_CNT"
                ;;
          "4") NEW_REC_CNT="000$REC_CNT"
                ;;
          "5") NEW_REC_CNT="00$REC_CNT"
                ;;
          "6") NEW_REC_CNT="0$REC_CNT"
                ;;
          "7") NEW_REC_CNT="$REC_CNT"
                ;;
        esac
}

#
# Set Header Information
set_header()
{
	get_seq
	CLM_HDR="HDR ITRN${YR}${SEQ_NUM} Claims File"
	PAT_HDR="HDR IPAT${YR}${SEQ_NUM} Patient File"
	PHA_HDR="HDR IPHA${YR}${SEQ_NUM} Pharmacy File"
}

#
# Set Trailer Information
set_trailer()
{
	get_counts
	CLM_TRL="TRL ${CLM_CNT} ${INV_AMT}"
	PAT_TRL="TRL ${PAT_CNT}"
	PHA_TRL="TRL ${PHA_CNT}"
}


#
# Set filenames
set_filenames()
{
	set_header
	set_trailer
	NEW_CLM_FILE="ITRN${YR}${SEQ_NUM}"
	NEW_PAT_FILE="IPAT${YR}${SEQ_NUM}"
	NEW_PHA_FILE="IPHA${YR}${SEQ_NUM}"
	NEW_SUM_FILE="billtran_1181rpt_${DATE}.dat"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${CLM_FILE}
	then
	  echo ${CLM_HDR} > ${TMP_LOC}/${NEW_CLM_FILE}
	  cat ${FILE_LOC}/${CLM_FILE} >> ${TMP_LOC}/${NEW_CLM_FILE}
	  echo ${CLM_TRL} >> ${TMP_LOC}/${NEW_CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  ERROR=1
          clean_up
	  exit 1
	fi
	if test -s ${FILE_LOC}/${PAT_FILE}
	then
	  echo ${PAT_HDR} > ${TMP_LOC}/${NEW_PAT_FILE}
	  cat ${FILE_LOC}/${PAT_FILE} >> ${TMP_LOC}/${NEW_PAT_FILE}
	  echo ${PAT_TRL} >> ${TMP_LOC}/${NEW_PAT_FILE}
	else
	  echo "-*> Patient file does not exist..."
	  ERROR=1
          clean_up
	  exit 1
	fi
	if test -s ${FILE_LOC}/${PHA_FILE}
	then
	  echo ${PHA_HDR} > ${TMP_LOC}/${NEW_PHA_FILE}
	  cat ${FILE_LOC}/${PHA_FILE} >> ${TMP_LOC}/${NEW_PHA_FILE}
	  echo ${PHA_TRL} >> ${TMP_LOC}/${NEW_PHA_FILE}
	else
	  echo "-*> Pharmacy file does not exist..."
	  ERROR=1
	  clean_up
	  exit 1
	fi
	if test -s ${FILE_LOC}/${SUM_FILE}
	then
	  cp ${FILE_LOC}/${SUM_FILE} ${TMP_LOC}/${NEW_SUM_FILE}
	else
	  echo "-*> Summary file does not exist..."
	  ERROR=1
	  clean_up
	  exit 1
	fi
}


# Cleanup
clean_up()
{
	rm ${TMP_LOC}/${NEW_CLM_FILE}
	rm ${TMP_LOC}/${NEW_PAT_FILE}
	rm ${TMP_LOC}/${NEW_PHA_FILE}
	rm ${TMP_LOC}/${NEW_SUM_FILE}
	if [ $ERROR = 0 ]
	then
		mv ${TMP_SEQ_FILE} ${SEQ_FILE}
	fi
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
#if [ $# -lt 2 ]
#then
#   usage
#   exit 2
#fi

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
    -t) SEQ_FILE="/usr/lnk/tapes/pmsi/pmsi_test_seq_ctrl_${YEAR}.txt"
	TR_ID="PMSI-BILL-TST"
	;;
    -s) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	ALT_SEQ_NUM=$1
	ALT_SEQ_FLG=1
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

set_filenames

echo
echo "--> Converting file..."
echo

rename_files

echo 
echo "--> Transferring file to ${TR_ID}..."
echo
${TRANSFER_PROG} ${TR_ID} ${TMP_LOC}/${NEW_CLM_FILE} ${TMP_LOC}/${NEW_PAT_FILE} ${TMP_LOC}/${NEW_PHA_FILE} ${TMP_LOC}/${NEW_SUM_FILE}

echo
echo "--> Cleaning up..."
echo

clean_up

echo "**** Please note the following sequence number in the log entry ****"
echo "**** The file sequence is ${SEQ_NUM} ****"

echo "-=> Finished."

exit 0
