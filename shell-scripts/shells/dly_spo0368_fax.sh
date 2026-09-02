#!/bin/ksh
#
# Program Name	: dly_spo0368_fax.sh
# Description	: Off-hours Flexgen faxing procedure
# Author	: Linda S. Jefferis
# Date		: 09/20/2004
# Modifications : 02/16/2006 - Added umask 002  (LSJ)
#		: 10/10/2006 - Changed page layout designation from "132" to "land"  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/flexgen"
FLEX="/usr/lnk/flexgen"
FILE_1=scrovr.txt
FILE_4=screxc.txt
FILE_2=ovrlist.oup
FILE_3=exclist.oup
FAX_NUM=14193537429
FAX_NAME="Cheryl Albrecht"
FAX_PRG=/usr/local/bin/fax
VFAXDIR=/usr/vsifax/spool;export VFAXDIR
PATH=$PATH:/usr/vsifax/bin:/usr/pdm/bin;export PATH


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dly_spo0368_fax.sh 

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

umask 002

rm -f ${FILE_PATH}/${FILE_1}
rm -f ${FILE_PATH}/${FILE_2}
echo "--> Removed two files in ${FILE_PATH}"
echo ""
cd ${FLEX}

date
echo "--> Starting - ohovrls001.cs"
${FLEX}/ohovrls001.cs
date

rm -f ${FILE_PATH}/${FILE_4}
rm -f ${FILE_PATH}/${FILE_3}
echo "--> Removed two files in ${FILE_PATH}"
echo ""

date
echo "--> Starting - ohexcls001.cs"
${FLEX}/ohexcls001.cs
date

echo "--> Faxing the output file to ${FAX_NUM}"
FAXFROM="PDM"; export FAXFROM
FXMAILTO="ljefferis@pdmi.com"; export FXMAILTO
${FAX_PRG} "${FAX_NAME}" "${FILE_PATH}/${FILE_2}" "${FAX_NUM}" "land"
${FAX_PRG} "${FAX_NAME}" "${FILE_PATH}/${FILE_3}" "${FAX_NUM}" "land"

date
echo "--> Finished" 


exit 0
