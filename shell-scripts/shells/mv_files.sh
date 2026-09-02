#!/bin/ksh
#
# Program Name	: mv_files.sh
# Description	: Script to move files to new linked directories
# Author	: Linda S. Jefferis
# Date		: 07/21/98
# Modifications :  
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

usage: mv_files.sh 

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

mv ${SYSTE00MAS} /usr/lnk/grp/SYSTE00MAS
mv ${SPONS00MAS} /usr/lnk/grp/SPONS00MAS
mv ${GROUP00MAS} /usr/lnk/grp/GROUP00MAS
mv ${ADMIN00MAS} /usr/lnk/grp/ADMIN00MAS
mv ${BENEF00MAS} /usr/lnk/grp/BENEF00MAS
mv ${COPAY00MAS} /usr/lnk/grp/COPAY00MAS
mv ${PLAN000MAS} /usr/lnk/grp/PLAN000MAS
mv ${CARDH09KEY} /usr/lnk/grp/CARDH09KEY
mv ${DRTHR00MAS} /usr/lnk/drug/DRTHR00MAS
mv ${DRUG003MAS} /usr/lnk/drug/DRUG003MAS
mv ${GEAP000MAS} /usr/lnk/drug/GEAP000MAS
mv ${GENER00MAS} /usr/lnk/drug/GENER00MAS
mv ${GENTB00MAS} /usr/lnk/drug/GENTB00MAS
mv ${STEPT00MAS} /usr/lnk/drug/STEPT00MAS
mv ${GPIDI00MAS} /usr/lnk/drug/GPIDI00MAS
mv ${DRUGOVRMAS} /usr/lnk/drug/DRUGOVRMAS
mv ${MODIF00MAS} /usr/lnk/drug/MODIF00MAS
mv ${NDCMO00MAS} /usr/lnk/drug/NDCMO00MAS
mv ${CLDUR00MAS} /usr/lnk/drug/CLDUR00MAS
mv ${THERA00MAS} /usr/lnk/drug/THERA00MAS
mv ${DRUG000MAS} /usr/lnk/drug/DRUG000MAS
mv ${DEA0000MAS} /usr/lnk/phys/DEA0000MAS
cp /usr/pdm/tmp/STATU00MAS.null /usr/pdm/claims/STATU00MAS
mv ${CARDH00MAS} /usr/lnk/crd_01/CARDH00MAS
mv ${CARDI00MAS} /usr/lnk/crd_01/CARDI00MAS
mv ${CATAB00MAS} /usr/lnk/crd_01/CATAB00MAS
mv ${CARTB00MAS} /usr/lnk/crd_01/CARTB00MAS
mv ${EMBOS00MAS} /usr/lnk/crd_01/EMBOS00MAS
mv ${EXCEP00MAS} /usr/lnk/crd_01/EXCEP00MAS
mv ${OVERI00MAS} /usr/lnk/crd_01/OVERI00MAS
mv ${CARDH06MAS} /usr/lnk/crd_01/CARDH06MAS
mv ${LIMIT00MAS} /usr/lnk/crd_02/LIMIT00MAS

exit 0
