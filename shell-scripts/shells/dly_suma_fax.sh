#!/bin/ksh
#
# Program Name	: dly_suma_fax.sh
# Description	: Off-hours Flexgen faxing procedure
# Author	: Linda S. Jefferis
# Date		: 03/04/2004
# Modifications : 07/12/2005 - Eliminated the ohclals003.cs run and fax  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/flexgen"
FLEX="/usr/lnk/flexgen"
FILE_1=scr.txt
FILE_2=clalist.oup
FAX_NUM=13309968580
FAX_NAME="Tracy Dankoff"
FAX_PRG=/usr/local/bin/fax
VFAXDIR=/usr/vsifax/spool;export VFAXDIR
PATH=$PATH:/usr/vsifax/bin:/usr/pdm/bin;export PATH


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dly_suma_fax.sh 

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

# Parse environment variables
parse_env

rm -f ${FILE_PATH}/${FILE_1}
rm -f ${FILE_PATH}/${FILE_2}
echo "--> Removed two files in ${FILE_PATH}"
echo ""
cd ${FLEX}

date
echo "--> Starting - ohclals001.cs"
${FLEX}/ohclals001.cs
date

echo "--> Faxing the output file to ${FAX_NUM}"
FAXFROM="PDM/Roxanne Clark"; export FAXFROM
FXMAILTO="ljefferi"; export FXMAILTO
${FAX_PRG} "${FAX_NAME}" "${FILE_PATH}/${FILE_2}" "${FAX_NUM}" "132"

date
echo "--> Finished" 


exit 0
