#!/bin/ksh
#
# Program Name	: clms_wsn.sh
# Description	: Procedure to setup clmrt01 claims file for WSN (sys0164)
#		  Command Line Arguments:
#		  -p <ccyymmdd> Date for filename 
# Author	: Dawn M. Engler
# Date		: 04/04/2014
# Modifications : 04/07/2014 change Tape file naming, claims file naming, and add Filename date with -p option. TT: 9678-7&32 (dme)
#		: 04/06/2016 - changes for auto uploading the file.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TAPE_FILE="????CLMRTWSN"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1024"
TR_DIR=/usr/lnk/wt/oper-wt/sftpexport/WSN/FromPDMI
DATE=`date +%Y%m%d`
PE_DATE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_wsn.sh [-p <ccyymmdd>]
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
	CLM_FILE="Refreshclms-WSN-${PE_DATE}.txt"
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
        PE_DATE=$1
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

echo "-=> Finished."


exit 0
