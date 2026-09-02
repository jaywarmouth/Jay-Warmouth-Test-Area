#!/bin/sh
#
# Program Name	: tr_tscflexlisting.sh
# Description	:
# Modifications : 12/10/2019 - TT19240-26; new DEST_LOC 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FTYPE="null"
RETVAL=0
DATETM=`date +%Y%m%d%H%M%S`
DEST_LOC=/usr/lnk/wt/tscdaily-wt

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr_tscflexlisting.sh <filetype>
	filetype - 1|2
		1 - SpecialtyClaimsListing
		2 - BrandCareClaimsListing

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

# Transfer File
tr_file()
{
	if test -e ${HOME}/${RPT_NAME}.csv
	then
		mv ${HOME}/${RPT_NAME}.csv ${DEST_LOC}/${RPT_NAME}_${DATETM}.csv
	else
		echo "The file, ${HOME}/${RPT_NAME}.csv, does not exist"
		RETVAL=99
	fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
        usage
        exit 1
fi

FTYPE=$1

case $FTYPE 
in
     1) RPT_NAME="TSC_SPECIALTY_CLAIMS"
	tr_file
	;;
     2) RPT_NAME="TSC_BRANDCARE_CLAIMS"
	tr_file
	;;
esac

exit ${RETVAL}
