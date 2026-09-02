#!/bin/sh
#
# Program Name	: conv_reconx12.sh
# Description	: Converts needed X12/835 payment tape files
#		  Command Line Arguments:
#		  -p <file prefix> - Date prefix for file
# Author	: Linda S. Jefferis
# Date		: 11/12/2003
# Modifications : 06/28/2005 - Addition of logic for week-cycle
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 04/04/2006 - Changes for copying of files  (LSJ)
#		: 04/23/2006 - Changes for new output directories and addition of other group of chains  (LSJ)
#		: 05/10/2006 - Added logic for copying/moving TEXT files  (LSJ)
#		: 08/21/2006 - Addition of 835_transfer.sh procedure  (LSJ)
#		: 09/20/2006 - Addition of logic for Access Health files  (LSJ)
#		: 10/11/2006 - Addition of logic for Ahold files  (LSJ)
#		: 11/24/2006 - Addition of logic for NetRx files  (LSJ)
#		: 11/27/2006 - Addition of logic for HCC files  (LSJ)
#		: 01/11/2007 - Addition of PPOK logic for SFTP  (LSJ)
#		: 01/19/2007 - Addition of logic for Provider Pay (PPAY)  (LSJ)
#		: 02/02/2007 - Addition of logic for Central Pay  (LSJ)
#		: 02/14/2007 - Addition of logic for PBA  (LSJ)
#		: 03/23/2007 - Addition of logic for RITEAID  (LSJ)
#		: 04/02/2007 - Changed Kroger CHAIN_NAME to KROGER  (LSJ)
#		: 04/16/2007 - Addition of logic for WD (Winn-Dixie)  (LSJ)
#		: 04/25/2007 - Addition of logic for TPS (Third Party Station)
#		: 11/01/2007 - Addition of logic for Pharmerica  (LSJ)
#		: 01/23/2008 - Addition of logic for IRX  (LSJ)
#		: 02/19/2008 - Changed PBA TEXT_FLAG to 0  (LSJ)
#		: 02/29/2008 - Added logic for Emdeon  (LSJ)
#		: 03/13/2008 - Added logic for Bi-Mart  (LSJ)
#		: 06/06/2008 - Added logic for Longs  (LSJ)
#		: 08/15/2008 - Added logic for Safeway  (LSJ)
#		: 09/19/2008 - Added logic for Brookshire  (LSJ)
#		: 02/20/2009 - Added logic for Wal-Mart  (LSJ)
#		: 02/20/2009 - Added logic for Harris Teeter  (LSJ)
#		: 03/06/2009 - Removed Longs (now sent to CVS)
#		: 03/19/2009 - Added logic for Kerr Drugs  (LSJ)
#               : 04/29/2009 - Reading CONFIG_FILE for list of chains  (LSJ)
#		: 09/24/2009 - Changes for switch to new check run process
#		: 10/24/2011 - Add logic for V5010 files
#		: 12/13/2011 - Changed name of called NHIN script for 5010
#		: 09/26/2012 - Removed logic for X12SEQ-4010 files
#		: 04/25/2013 - Add logic for "3" SPEC_PROC (medsub)
#		: 03/13/2017 - Add logic for "4" SPEC_PROC (.txt filenames)
#		: 03/18/2021 - Add logic for "5" SPEC_PROC (PDMI- prefix and .txt suffix)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL="/usr/lnk/shell"
TAPE_DIR="/usr/lnk/tapes"
PREFIX="null"
DEST_DIR="/usr/lnk/wt/pdm/reconx12"
TEXT_FLAG=0
LET="C"
CYCLE="chk"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conv_reconx12.sh -p <prefix> 
	-p <prefix> - 3-char p/e date prefix of file to be converted  (required)

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


# Read config file
read_config()
{
	IFS="$CR"
	for line in `cat $CONFIG_FILE | grep -v "^#"`
        do
                IFS="$OIFS"
                parse_record
                if [ "$X12_DIR" != "NULL" ]
                then
                        move_files
                fi
	done
}

#
# Parse configuration record
parse_record()
{
        FID=`echo $line | awk -F: '{ print $1 }'`
	CHAIN_NAME=`echo $line | awk -F: '{ print $2 }'`
	X12_DIR=`echo $line | awk -F: '{ print $3 }'`
        METHOD=`echo $line | awk -F: '{ print $4 }'`  
        TEXT_FLAG=`echo $line | awk -F: '{ print $5 }'`
	SPEC_PROC=`echo $line | awk -F: '{ print $6 }'`
        CHAIN_LIST=`echo $line | awk -F: '{ print $8 }'`
}

#
# Do any noted special processing
spec_process()
{
	case ${SPEC_PROC} in
	  "2")
		DATE=`date +%Y%m%d`
		mv ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010 ${DEST_DIR}/${CYCLE}/${X12_DIR}/V5010${FNAME}.${DATE}
		rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010-TEXT
		;;
	  "3")
		mv ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010 ${DEST_DIR}/${CYCLE}/${X12_DIR}/PDMI835.${PREFIX}${FNAME}-V5010
		rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010-TEXT
                ;;
	  "4")
		mv ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010 ${DEST_DIR}/${CYCLE}/${X12_DIR}/${PREFIX}${FNAME}-V5010.txt
		rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010-TEXT
		;;
	  "5")
		mv ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010 ${DEST_DIR}/${CYCLE}/${X12_DIR}/PDMI-${PREFIX}${FNAME}-V5010.txt
		rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010-TEXT
                ;;
	esac
}


# Move file procedure
move_files()
{
        echo
        echo "--> Moving files for ${CHAIN_NAME}..."
	IFS=","
        for FNAME in $CHAIN_LIST
        do
	  if test -s ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010
          then
            if [ $SPEC_PROC = 0 ]
            then
                mv ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010 ${DEST_DIR}/${CYCLE}/${X12_DIR}
                if [ $TEXT_FLAG = 1 ]
                then
                        mv ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010-TEXT ${DEST_DIR}/${CYCLE}/${X12_DIR}
                else
                        rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${FNAME}-V5010-TEXT
                fi
            else
                spec_process
            fi
          else
                echo "-*> No payment tape file found for ${PREFIX}${FNAME}-V5010"
          fi
        done
	IFS=$OIFS
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	PREFIX=$1
	;;
  esac
  shift
done


cp ${TAPE_DIR}/${PREFIX}????-V5010 ${DEST_DIR}/${CYCLE}
cp ${TAPE_DIR}/${PREFIX}????-V5010-TEXT ${DEST_DIR}/${CYCLE}

# Procedures for NHIN
echo
echo "--> Creating file for NHIN..."
${SHELL}/cat_nhin_5010.sh -p ${PREFIX} 

CONFIG_FILE="/usr/local/etc/835_transfer.cfg"
read_config

exit 0
