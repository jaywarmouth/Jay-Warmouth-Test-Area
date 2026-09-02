#!/bin/ksh
#
# Program Name	: conv_prmmed.sh
# Description	: Converts the prmmed files to "|" delimited for printing
#		: Command Line Arguments:
#		  -n <day name suffix - e.g. wed> 
# Author	: Linda S. Jefferis
# Date		: 03/09/2005
# Modifications : 12/03/2005 - Changes for new system names  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
CARD_DIR="/usr/lnk/cards"
ARCH_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
SUFFIX="null"
MED_NAME="prmmed"
TMP_DIR="/tmp"
CONV_PROG="/usr/lnk/shell/prm2delim.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conv_prmmed.sh -n <name suffix - e.g. wed>

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
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -n) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SUFFIX=$1
        ;;
  esac
  shift
done


# Parse environment variables
#parse_env

if [ ${SUFFIX} = "null" ]
then
  usage
  exit 1
fi

cd ${CARD_DIR}
ls ${MED_NAME}??.${SUFFIX} > ${TMP_DIR}/prmmed-lst
for FILE in `cat ${TMP_DIR}/prmmed-lst`
do
   cat $FILE | /usr/local/bin/char_repl 26 -1 > $FILE.conv
   CARD_TYPE=`echo $FILE | cut -c1-8`
   ${CONV_PROG} $FILE.conv > ${CARD_TYPE}.TXT
   scp ${CARD_TYPE}.TXT ${ARCH_SYS}:${REMOTE_DIR}
   rm -f ${CARD_TYPE}.TXT
   rm -f $FILE.conv
done

rm -f ${TMP_DIR}/prmmed-lst

exit 0
