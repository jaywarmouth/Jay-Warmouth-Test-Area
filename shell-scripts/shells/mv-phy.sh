#!/bin/ksh
#
# Program Name	: mv-phy.sh
# Description	: Moves physician files
# Author	: Linda S. Jefferis
# Date		: 08/19/1998
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
PHY_DIR="/usr/lnk/tmp/hsphy"
WORKDEST="/usr/lnk/tmp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv-phy.sh <date>

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
#parse_env

cp ${PHY_DIR}/inp$1 ${WORKDEST}/PHYSIINLIN
cp ${PHY_DIR}/nhp$1 ${WORKDEST}/PHYSINHLIN
cp ${PHY_DIR}/nyp$1 ${WORKDEST}/PHYSINYLIN
cp ${PHY_DIR}/mep$1 ${WORKDEST}/PHYSIMELIN
cp ${PHY_DIR}/arp$1 ${WORKDEST}/PHYSIARLIN
cp ${PHY_DIR}/tnp$1 ${WORKDEST}/PHYSITNLIN
cp ${PHY_DIR}/scp$1 ${WORKDEST}/PHYSISCLIN
cp ${PHY_DIR}/kyp$1 ${WORKDEST}/PHYSIKYLIN

exit 0
