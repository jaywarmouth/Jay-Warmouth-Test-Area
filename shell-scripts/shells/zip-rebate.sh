#!/bin/ksh
#
# Program Name	: zip-rebate.sh
# Description	: Creates password zip file(s) from rebate data files
#  		  Command Line Arguments:
#  		  -m <manuf. abbrev.> 
#  		  -p <3-char date prefix on filename> e.g. L31
#		  -x <quarter description for zip filename> e.g 4Q2001
#		  -t <sys#> 4-digits  (optional, if not specified will do all systems.
#		  -d  Flag for Medicare Part D file names
# Author	: Linda S. Jefferis
# Date		: 02/09/2001
# Modifications : 03/06/2001 - Added MANUF_CAP variable logic  (LSJ)
#		: 06/25/2001 - Added new manufacturers  (LSJ)
#		: 07/16/2001 - Added the "frst" manufacturer  (LSJ)
#		: 08/20/2001 - Changed procedure for determining uppercase version of the manuf. abbrev.  (LSJ)

#		: 02/14/2002 - Added the logic for the "-x" command line argument  (LSJ)
#		: 05/2004    - Added "-t" logic  (LSJ)
#		: 11/14/2005 - Changed to rebate_zipit.sh procedure  (LSJ)
#		: 05/04/2005 - Addition of MEDD_SUFFIX logic  (LSJ)
#		: 10/26/2006 - Changes for 4-digit system number  (LSJ)
#		: 11/07/2006 - Fixed cleanup  (LSJ)
#		: 01/11/2008 - Added printer name  (LSJ)
#		: 10/15/2012 - Changed printing to PDF file  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
USER=`/usr/bin/logname`
ZIP_OPTS="-j"
FILE_LOC="/usr/lnk/rebate"
ZIP_PROG="/usr/lnk/shell/rebate_zipit.sh"
SYS_FLG=0
SYS=0000
MEDD_SUFFIX=""

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-rebate.sh -m <manuf. abbrev.> -p <3-char date prefix on filename> -x <qrt descr for zip filename> -t <sys#-4 digits>

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
# Convert manuf to uppercase
set_uppercase()
{
	MANUF_CAP=`echo ${MANUF} | sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/'`
}

#
# Set Filenames
set_filenames()
{
	DATA_FILE="${MANUF}/${DATE_PREFIX}RB10DAT-${MANUF_CAP}${MEDD_SUFFIX}"
	TMP_DATA_48="48${DATE_PREFIX}RB10DAT-${MANUF_CAP}${MEDD_SUFFIX}"
	TMP_DATA_53="53${DATE_PREFIX}RB10DAT-${MANUF_CAP}${MEDD_SUFFIX}"
	RPT_FILE="${MANUF}/${DATE_PREFIX}RB10RPT-${MANUF_CAP}${MEDD_SUFFIX}"
	ZIP_LOC="/usr/lnk/shares/ftp-tmp/rebateinfo"
	TMP_LOC="/usr/lnk/rebate"
	FILEINFO=${FILE_LOC}/fileinfo_${QRT_DESCR}${MEDD_SUFFIX}.txt
}

#
# Copy Files
copy_files()
{
	if test -s ${FILE_LOC}/sys0048/${DATA_FILE}
	then
	   cp ${FILE_LOC}/sys0048/${DATA_FILE} ${TMP_LOC}/${TMP_DATA_48}
	   cp ${FILE_LOC}/sys0053/${DATA_FILE} ${TMP_LOC}/${TMP_DATA_53}
	else
	   echo "-*> The sys0048 RB10 Data file for ${MANUF_CAP} does not exist."
	   exit 1
	fi
	zip_files
}

#
# Zip Files
zip_files()
{
   echo "--> Zipping Files...."
   echo
	if [ ${SYS_FLG} = 1 ]
	then
	   ${ZIP_PROG} +r ${FILEINFO} +o "${ZIP_OPTS}" ${ZIP_LOC}/${MANUF_CAP}-${QRT_DESCR}${MEDD_SUFFIX}.zip ${FILE_LOC}/sys${SYS}/${DATA_FILE}
	else
	   echo "${ZIP_PROG} +r ${FILEINFO} +o "${ZIP_OPTS}" ${ZIP_LOC}/${MANUF_CAP}-${QRT_DESCR}${MEDD_SUFFIX}.zip ${TMP_LOC}/${TMP_DATA_48} ${TMP_LOC}/${TMP_DATA_53}"
	   ${ZIP_PROG} +r ${FILEINFO} +o "${ZIP_OPTS}" ${ZIP_LOC}/${MANUF_CAP}-${QRT_DESCR}${MEDD_SUFFIX}.zip ${TMP_LOC}/${TMP_DATA_48} ${TMP_LOC}/${TMP_DATA_53}
	fi
}

#
# Convert report to PDF
print_rpt()
{
	if [ ${SYS_FLG} = 1 ]
	then
	   a2ps -1Bl132 --print-anyway=1 --non-printable-format=blank -o - ${FILE_LOC}/sys${SYS}/${RPT_FILE} | ps2pdf - ${ZIP_LOC}/${MANUF_CAP}-${QRT_DESCR}-${SYS}-RPT.pdf
	else
	   SYS=0048
	   a2ps -1Bl132 --print-anyway=1 --non-printable-format=blank -o - ${FILE_LOC}/sys${SYS}/${RPT_FILE} | ps2pdf - ${ZIP_LOC}/${MANUF_CAP}-${QRT_DESCR}-${SYS}-RPT.pdf
	   SYS=0053
	   a2ps -1Bl132 --print-anyway=1 --non-printable-format=blank -o - ${FILE_LOC}/sys${SYS}/${RPT_FILE} | ps2pdf - ${ZIP_LOC}/${MANUF_CAP}-${QRT_DESCR}-${SYS}-RPT.pdf
	fi
}

#
# Cleanup
cleanup()
{
   echo "--> Doing Cleanup..."
   echo
   rm ${TMP_LOC}/${TMP_DATA_48}
   rm ${TMP_LOC}/${TMP_DATA_53}
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -m) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        MANUF=$1
	set_uppercase
        ;;
    -p) shift
	if [ $# -le 0 ]
	then
	  usage
	fi
	DATE_PREFIX=$1
	;;	
    -x) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	QRT_DESCR=$1
	;;
    -t) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SYS_FLG=1
	SYS=$1
	;;
    -d) MEDD_SUFFIX="-MEDD"
	;;
  esac
  shift
done

date

if [ ${SYS_FLG} = 0 ]
then
	set_filenames
	echo "Copying Files..."
	echo
	copy_files
	echo "--> Converting report..."
	echo
	print_rpt
	cleanup
else
	set_filenames
	zip_files
	echo "--> Converting report..."
        echo
        print_rpt
fi

date

# Parse environment variables
#parse_env

exit 0
