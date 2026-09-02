#!/bin/sh
#
# Program Name	: npicms_lst.sh
# Description	: Prepares weekly downloaded NPICMS file for updating.
# Author	: Linda Jefferis
# Date		: 4/11/2013
# Modifications : 3/1/2018 - added SENT_NPIFILE logic.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILELOC="/usr/lnk/wt/oper-wt/NPICMS"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: npicms_lst.sh -d <file date range>
	date range - as given in filename; mmddyy_mmddyy

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

# Date Convert
date_convert()
{
	MD1=`echo $FILEDATE | cut -c1-4`
	YR1=`echo $FILEDATE | cut -c5-6`
	MD2=`echo $FILEDATE | cut -c8-11`
	YR2=`echo $FILEDATE | cut -c12-13`
	CENT=`date +%Y | cut -c 1-2`
	CONVDATE="$CENT$YR1$MD1-$CENT$YR2$MD2"
	echo "CONVDATE=$CONVDATE"
}

# Set Filenames
set_filenames()
{
	ZIPFILE="NPPES_Data_Dissemination_${FILEDATE}_Weekly.zip"
	NPIFILE="npidata_${CONVDATE}.csv"
	SENT_NPIFILE="npidata_pfile_${CONVDATE}.csv"
	echo "NPIFLE=$NPIFLE"
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 1
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
	FILEDATE=$1
	date_convert
	set_filenames
	;;
  esac
  shift
done

# Parse environment variables
parse_env

unzip -d ${FILELOC} ${FILELOC}/${ZIPFILE} ${SENT_NPIFILE}
mv ${FILELOC}/${SENT_NPIFILE} ${FILELOC}/${NPIFILE}
RECCNT=`wc -l ${FILELOC}/${NPIFILE} | awk '{ print $1 }'`
echo "NPIFILE=${FILELOC}/${NPIFILE}"
echo "Record Count:  ${RECCNT}"


exit 0
