#!/bin/sh
#
# Program Name	: clms_abc_rxfl.sh
# Description	: Procedure to setup clmrt01 claims file for ABC-RXFL (sys0118/3695)
#		  Command Line Arguments:
#		  -p <mmddccyy> Date for filename 
# Author	: Linda S. Jefferis
# Date		: 11/0i2/2018
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="????CLMRTRXFL"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
TR_DIR=/usr/lnk/shares/ftp-tmp
#MAIL_PROG="/bin/mail"
#MAIL_TO="sam@rxflo.com"
#MAIL_CC="operations@pdmi.com"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="ABCRXFL"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_abc_rxfl.sh [-p <mmddccyy>]
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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


#
# Set Filenames
set_filenames()
{
        MO=`echo ${IN_DATE} | cut -c1-2`
        DAY=`echo ${IN_DATE} | cut -c3-4`
        YR=`echo ${IN_DATE} | cut -c5-8`
        PE_DATE=${YR}${MO}${DAY}
	CLM_FILE="Refreshclms-ABCRXFL-${PE_DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TR_DIR}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# FTP file
ftp_file()
{
        if test -a ${TR_DIR}/${CLM_FILE}
        then
           ${TR_PROG} ${TR_ID} ${TR_DIR}/${CLM_FILE} 
        else
           echo "--*> File not copied..."
        fi
}

#
# Cleanup
clean_up()
{
        rm -f ${TR_DIR}/${CLM_FILE}
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        IN_DATE=$1
        set_filenames
        ;;
  esac
  shift
done

parse_env

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo
echo "--> Transferring file to ${TR_ID}..."
echo

ftp_file

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."


exit 0
