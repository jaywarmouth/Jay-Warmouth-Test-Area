#!/bin/ksh
#
# Program Name	: nfs20_copy_claims.sh
# Description	: Copy Claims to NFS20
# Author	: Linda S. Jefferis
# Date		: 09/20/2012
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

usage: nfs20_copy_claims.sh 

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

date
echo "Copying CLAIM00MAS"
cp /usr/lnk/clm_01/CLAIM00MAS /nfs/proddata/clm/clm_01
date
echo "Copying history claims files"
cp /usr/clm/d0/CLAIMS_qu?_?? /nfs/proddata/clm/d0
date


exit 0
