#!/bin/sh
#

usage()
{  cat << ENDOFUSAGE
Usage: $0 <config filename>

NOTES for config file format:
# Format:
# runtype|inparmfile|batchrange|filetype|origfile|newfile|infofile
#
# runtype       P - parameter file input; listing of 14 character batch/claims
#               R - range; 16-character batchrange is required
#               F - full; convert entire file (batchrange - 00000000ZZ99Z999)
# inparmfile:   NA - if runtype is R or F
#               <directory/filename> - if runtype is P
# batchrange:   16-character begin and end batch (e.g. TA01A000TL31Z999) if runtype is R
#               NULL - if runtype is P or F
# filetype:     C - CLAIM00MAS
#               R - CLMRS00MAS
#               V - REVER00MAS
# origfile:     <directory/filename> - Input Original/Old file
# newfile:      <filename> - filename only of output new/converted file
# infofile:     <filename> - filename only of output info/msg file

ENDOFUSAGE
exit 99
}

if [ $# -lt 1 ]
then
   usage
fi

CONFIG_FILE=$1
CR="
"
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/conversions"
SCRIPT="cexp-claimconvert.sh"

IFS=$CR
for line in `cat $CONFIG_FILE | grep -v "^#"`
do
	runtype=`echo $line | awk -F\| '{ print $1 }'`
	inparmfile=`echo $line | awk -F\| '{ print $2 }'`	
	batchrange=`echo $line | awk -F\| '{ print $3 }'`	
	filetype=`echo $line | awk -F\| '{ print $4 }'`	
	origfile=`echo $line | awk -F\| '{ print $5 }'`
	newfile=`echo $line | awk -F\| '{ print $6 }'`	
	errfile=`echo $line | awk -F\| '{ print $7 }'`

	newfile_basename=`basename ${newfile}`
	
	if [ ${runtype} = "P" ]
	then
		${SHELL_DIR}/${SCRIPT} -t ${runtype} -p ${inparmfile} -s ${filetype} -b ${batchrange} -i ${origfile} -o ${newfile} -m ${errfile} > ${RPT_DIR}/rpt-convert-${newfile_basename} 2>&1
	else
		${SHELL_DIR}/${SCRIPT} -t ${runtype} -s ${filetype} -b ${batchrange} -i ${origfile} -o ${newfile} -m ${errfile} > ${RPT_DIR}/rpt-convert-${newfile_basename} 2>&1
	fi
done

exit
 
