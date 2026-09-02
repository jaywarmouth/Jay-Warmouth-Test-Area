#!/bin/sh
#
# Program Name	: convertcopy.sh
# Description	:
# Author	: Linda S. Jefferis
# Date		: 06/24/2013
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convertcopy.sh 

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

cd /usr/lnk/drug
mv DRLOG00MAS DRLOG00MAS.old
mv NEWDRLOG DRLOG00MAS
mv DRUG003MAS DRUG003MAS.old
mv NEWDRUG03 DRUG003MAS
mv GENER00MAS GENER00MAS.old
mv NEWGENER GENER00MAS
mv MAC0000MAS MAC0000MAS.old
mv NEWMAC MAC0000MAS

cd /usr/lnk/dosecheck
mv DCGPI DCGPI.old
mv NEWDCGPI DCGPI

cd /usr/lnk/dt
mv DTDGPI DTDGPI.old
mv NEWDTDGPI DTDGPI

exit 0
