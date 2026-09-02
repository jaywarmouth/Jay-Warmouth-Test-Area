#!/bin/bash
#
# Program Name	: medsub_rsp_transfer.sh
# Description	: Transfers MEDSUB response files to HMS
#
# Variables Used:
RSP_DIR="/usr/lnk/wt/oper-wt/MEDSUB/HMS/FromPDMI/resp"
BUCKET="ga-internal-transfers/PDMI/HMS/OUTBOUND/MedSup_Resp/Encrypt_Send/"
AWS_CP="/usr/local/bin/aws s3 cp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: medsub_rsp_transfer.sh 

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

${AWS_CP} ${RSP_DIR} s3://${BUCKET} --recursive --only-show-errors

exit 0
