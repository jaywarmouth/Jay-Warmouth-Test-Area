#!/bin/ksh
#
# Program Name	: mv_cardemb.sh
# Description	: Archives the days card emboss files
#		: Command Line Arguments:
#		  -d <date suffix - mmddccyy
# Author	: Linda S. Jefferis
# Date		: 01/04/2000
# Modifications : 08/17/2000 - Added logic for Prmden?? card files  (LSJ)
#		: 11/03/2004 - Added logic for *.TXT files  (LSJ)
#		: 10/20/2005 - Changes for linux  (LSJ)
#		: 12/03/2005 - Changes for new system names  (LSJ)
#		: 06/06/2006 - Added zip -f any MED-*.txt files  (LSJ)
#		: 07/12/2006 - Removed line for MED files since they now will be named MED-*.TXT and will get zipped along with any others  (LSJ)
#		: 11/20/2007 - Removed zip of *.EMB and PLA-*  (LSJ)
#		: 04/23/2009 - Changed archive location  (LSJ)
#		: 09/30/2016 - Change CARD_ARCH
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
CARD_DIR="/usr/lnk/cards"
ARCH_SYS="husk"
CARD_ARCH="/usr/lnk/wt/oper-wt/IDCards/Archive"
ZIP_PROG="/usr/bin/zip"
DATE_SUFFIX="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv_cardemb.sh -d <date suffix>

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
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE_SUFFIX=$1
        ;;
  esac
  shift
done


# Parse environment variables
#parse_env

if [ ${DATE_SUFFIX} = "null" ]
then
  usage
  exit 1
fi

cd ${CARD_DIR}
${ZIP_PROG} -m cards-${DATE_SUFFIX}.zip *.TXT
cp cards-${DATE_SUFFIX}.zip ${CARD_ARCH}
CMD_STATUS=$?
if [ ${CMD_STATUS} = 0 ]
then
   rm cards-${DATE_SUFFIX}.zip
else
   echo "-*> Copy of the file failed..."
fi

exit 0
