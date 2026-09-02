#!/bin/ksh
#
# Program Name	: zip_arch_elig.sh
# Description	: Zips eligibility files on elig. archive system
#		  Command Line Arguments:
#		    -t elig|phy|lim|ded|oth|npi - file type
#		    -c Client Abbrev. (2-chars)
#		    -e File sub-type (1-digit: 0,1,2,3,9)
#                   -d date of file (mmdd) 
#		    -s system number (4-digits)
# Author	: Linda S. Jefferis
# Date		: 03-26-2001
# Modifications : 04/11/2001 - Added -t argument logic  (LSJ) 
#		: 07/16/2001 - Added logic for new "ap" client  (LSJ)
#		: 08/08/2001 - Added logic for new "pb" client  (LSJ)
#		: 11/30/2001 - Added logic for new "ky" client  (LSJ)
#		: 12/21/2001 - Added logic for "im"  (LSJ)
#		: 12/21/2001 - Added logic for "vp"  (LSJ)
#		: 02/14/2002 - Added logic for "as" and "ig"  (LSJ)
#		: 03/28/2002 - Added logic for "ma"  (LSJ)
#		: 05/09/2002 - Added logic for "sp"  (LSJ)
#		: 06/24/2002 - Logic for new file type of "lim"  (LSJ)
#		: 08/13/2002 - Removed the "validate client" logic  (LSJ)
#		: 04/05/2004 - Changed logic for new X12 files  (LSJ)
#		: 08/05/2004 - Added error message display if elig_type is not sent in when file_type is "elig"  (LSJ)
#		: 08/05/2004 - Added zip of "c" file under elig_type 0 or 1 
#		: 01/11/2005 - Added file-type of "ded"  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 01/12/2006 - Added "oth" type  (LSJ)
#		: 01/12/2006 - Changed umask  (LSJ)
#		: 10/11/2006 - Added ELIG_TYPE options for "oth"  (LSJ)
#		: 10/19/2006 - Changes for 4-digit system number  (LSJ)
#		: 11/10/2006 - Added 3 as possible option for -e  (LSJ)
#		: 03/20/2008 - Added logic for new "npi" file type  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in_1"
DATE="null"
CLIENT="null"
ZIP_PROG="/usr/bin/zip"
FILE_TYPE="null"
ELIG_TYPE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip_arch_elig.sh [-t elig|phy|lim|ded|oth|npi] [-c <client abbrv.>] [-e <elig. type>] [-d <mmdd>] [-s <4-digit sys#>]

	<elig. type> is 1-digit code:
             eligibility files:
		0 - Input files is non-converted ??e in elig_in directory
		1 - Input file is a converted .lin file in elig_in directory
		2 - X12 related files
		3 - XLS related files
		9 - Testing (ts)
             oth files:
                0 - Other Payer files ??o (othpa01.sh)
		1 - Override files ??o (overi01.sh)
		2 - Exception files ??x (except02.sh)

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
# Validate -t options
validate_type()
{	case ${FILE_TYPE} in
	   "elig" | "phy" | "lim" | "ded" | "oth" | "npi")
		;;
	   *) usage
		;;
	esac
}

#
# Validate -e options
validate_elig_type()
{
	case ${ELIG_TYPE} in
	   "0" | "1" | "2"  | "3" | "9")
		;;
	   *) usage
		;;
	esac
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
   usage
   exit 1
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_TYPE=$1
	validate_type
	;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLIENT=$1
        ;;
    -e) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ELIG_TYPE=$1
	validate_elig_type
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
	MONTH=`echo $1 | cut -c1,2`
	YEAR=`date +%y`
        ;;
    -s) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SYS=$1
	;;
  esac
  shift
done


# Parse environment variables
#parse_env

umask 000
case ${FILE_TYPE} in
   "elig")
	case ${ELIG_TYPE} in
	   "0" | "1")
		${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}[c,e,g]${DATE}
		;;
	   "2")
		${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}[e,g]${DATE}-X12 ${ELIG_DIR}/sys${SYS}/${CLIENT}[e,g]${DATE}
		;;
	   "3")
		${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}[e,g]${DATE}-XLS ${ELIG_DIR}/sys${SYS}/${CLIENT}[e,g]${DATE}
		;;
	   "9")
		exit 0
		;;
	     *) echo "--*> An elig_type is needed" 
		usage
		;;
	esac
	;;
   "phy")
	${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}p${DATE}
	;;
   "lim")
	${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}l${DATE}
	;;
   "npi")
	${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}n${DATE}
	;;
   "ded")
	${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}d${DATE}
	;;
   "oth")
	case ${ELIG_TYPE} in
	   "0" | "1")
		${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}o${DATE}
		;;
	   "2")
		${ZIP_PROG} -mj ${ELIG_DIR}/sys${SYS}/${CLIENT}${MONTH}${YEAR}.zip ${ELIG_DIR}/sys${SYS}/${CLIENT}x${DATE}
		;;
	esac
	;;
esac

exit 0
