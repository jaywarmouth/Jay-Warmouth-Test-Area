#!/bin/sh
#
# Program Name	: tc-eoyaccum_lst.sh
# Description	: Moves files and creates log listing of TC-EOYReactivation accum file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent.
# Author	: Linda S. Jefferis
#
#
#
# Variables Used:
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH="/usr/lnk/elig_in_1"
REMOTE_DIR="/usr/lnk/wt/oper-wt/accum/TCEOY/ToPDMI"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
CLIENT="tc"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tc-eoyaccum_lst.sh [-d <ccyymmdd>]

ENDOFUSAGE
  exit 1
}


#
# Convert the date
convert_date()
{
        DATE=`echo ${INPUT_DATE} | cut -c5-8`
}

#
# Set Filenames
set_filename()
{
	ACCUM_FILE="TCEOY_accum_${INPUT_DATE}_*.txt"
	CNT_FILE="TCEOY_counts_accum_${INPUT_DATE}_*.txt"
}

#
# Move Files
move_files()
{
	cd ${REMOTE_DIR}
	filenum=1
	ls -1 ${ACCUM_FILE} > /tmp/tceoyaccum_filelist.txt
	for accumfile in `cat /tmp/tceoyaccum_filelist.txt`
	do
        	if ! test -a ${REMOTE_DIR}/${accumfile}
        	then
          		echo "-*> Incorrect elig. filename...exiting process"
          		exit 1
		else
          	  mv ${REMOTE_DIR}/${accumfile} ${ELIG_DIR}/${CLIENT}l${DATE}-eoy${filenum}
          	  cp ${ELIG_DIR}/${CLIENT}l${DATE}-eoy${filenum} ${ELIG_ARCH}
       		fi
		let filenum=filenum+1
	done
	rm -f ${REMOTE_DIR}/${CNT_FILE}
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT}l-${DATE}.log
        cd ${ELIG_DIR}
        echo "TC-EOY Accumulator Files" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}l${DATE}-eoy? >> ${ELIG_LOG}/${LOG_NAME}
        cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

	
#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INPUT_DATE=$1
	convert_date
	set_filename
        ;;
  esac
  shift
done

if [ ${INPUT_DATE} = "null" ]
then
   usage
fi

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

exit 0
