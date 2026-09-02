#!/bin/sh
#
# Program Name	: conv_reconx12_5010.sh
# Description	: Temporary script to cp/mv V5010 "parallel" files
#		  Command Line Arguments:
#		  -p <file prefix> - Date prefix for file
# Author	: Linda S. Jefferis
# Date		: 10/24/2011
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL="/usr/lnk/shell"
TAPE_DIR="/usr/lnk/tapes"
TMP_DIR="/tmp"
PREFIX="null"
DEST_DIR="/usr/lnk/shares/ftp-tmp/X12"
TEXT_FLAG=0
CONFIG_FILE="/usr/local/pub/temp_5010_transfer.cfg"
CYCLE="v5010"

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
#echo
#echo "--> Creating file for NHIN..."
#${SHELL}/cat_nhin_5010.sh -p ${PREFIX} 

read_config

exit 0
