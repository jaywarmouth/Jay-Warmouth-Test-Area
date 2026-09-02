#!/bin/sh
#
# Program Name	: testelig_cleanup.sh
# Description   : Eligibility processing
#                 Command line arguments:
#                   -c Client Abbrev. (2 characters)
#                   -d date of file (mmdd or mmdd-?)
#		    -f Input filename
# Author	: Linda S. Jefferis
# Date		: 11/14/2006
# Modifications : 10/15/2007 - Fixed removal of X12 and XLS files in elig_in
#		: 03/24/2008 - Added parse_config logic and removed extraneous command line arguments
#		: 03/24/2008 - Added logic for new cardh29wc program
#		: 09/18/2009 - CONV_PDF logic
#		: 11/10/2011 - PRINT-29-435 report name changed to PRINT-29-1049 and changed how report is handled.
#               : 02/15/2018 - TT13915-60; IDCHECK special process
#		: 08/16/2018 - TT18167-75; remove CNTY file logic

#		 
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT=/usr/lnk/elig_out
PRT_DIR="/usr/lnk/elig_out"
DATE="null"
DATETM=`date +%Y%m%d-%H%M%S`
CLIENT="null"
GRP_FLG=0
CONFIG_FILE="/usr/lnk/elig_in/elig.cfg"
WT_DIR=/usr/lnk/wt/oper-wt/EligReports-Test


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elig_cleanup.sh [-c <2 characters>] [-d <mmdd>] [-f <input filename>]
	<input filename> - elig input file (e.g. aue1012.lin)

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
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
# Parse config. record
parse_config()
{
        SYS=`echo $line | awk -F: '{ print $3 }'`
        ELIG_TYPE=`echo $line | awk -F: '{ print $4 }'`
        GRP_FLG=`echo $line | awk -F: '{ print $5 }'`
        RPT_NAME=`echo $line | awk -F: '{ print $6 }'`
        PROGRAM=`echo $line | awk -F: '{ print $7 }'`
        PROC_FLG=`echo $line | awk -F: '{ print $8 }'`
}

#
# Validate client
validate_client()
{
IFS="$CR"
FOUND=0
for line in `cat $CONFIG_FILE | grep -v "^#"`
do
        IFS="$OIFS"
        fid=`echo $line | awk -F: '{ print $1 }'`

        if [ "$CLIENT" = "$fid" ]
        then
                FOUND="1"
                parse_config
        fi
done
if [ "$FOUND" -ne 1 ]
then
        echo "Client ID $CLIENT not found in database."
        exit 1
fi
}

# Set Variables
set_variables()
{
	RPT_NAME_PREFIX="PRINT-29-"
}


#
# Cleanup
cleanup ()
{
   cp ${PRT_DIR}/sys${SYS}/CA29-${CLIENT}e${DATE}.txt ${WT_DIR}/${DATETM}-CA29-${CLIENT}e${DATE}.txt
   mv ${PRT_DIR}/sys${SYS}/CA29-${CLIENT}e${DATE}.txt ${PRT_DIR}/sys${SYS}/${DATETM}-CA29-${CLIENT}e${DATE}.txt
   /usr/bin/enscript -rlg -f Courier7 --non-printable-format=space -o - ${PRT_DIR}/sys${SYS}/${RPT_NAME_PREFIX}${CLIENT}e${DATE}.txt | ps2pdf - ${WT_DIR}/${DATETM}-${CLIENT}e${DATE}.pdf
   mv ${PRT_DIR}/sys${SYS}/${RPT_NAME_PREFIX}${CLIENT}e${DATE}.txt ${PRT_DIR}/sys${SYS}/${DATETM}-${RPT_NAME_PREFIX}${CLIENT}e${DATE}.txt
   mv ${CARDH29TAP} ${ELIG_OUT}/sys${SYS}
   case ${ELIG_TYPE} in
      "1")
	 mv ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_OUT}/sys${SYS}
	 ;;
      "2")
	 mv ${ELIG_DIR}/${CLIENT}e${DATE}-X12 ${ELIG_OUT}/sys${SYS}
	 ;;
      "3")
	 mv ${ELIG_DIR}/${CLIENT}e${DATE}-XLS ${ELIG_OUT}/sys${SYS}
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLIENT=$1
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	CARDH29TAP=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

umask 002

# Check client
validate_client

# Set variables
set_variables

# Cleanup
echo ""
echo "-> Doing Cleanup"
cleanup


exit 0
