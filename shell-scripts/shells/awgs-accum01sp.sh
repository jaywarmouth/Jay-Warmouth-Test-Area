#!/bin/sh
#
# Program Name	: accum01sp.sh - accum01 split

#                 Command line arguments:
#                 
#                 
# Author	: Marty Urbanek
# Date		: 11/29/2018
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RETVAL=0
DATE=$1
#DATE=20201228
#DATE=`date -d "yesterday 0800" +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum01sp.sh InputAccumFile InputConfigFile ReportFile

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#Create config file
create_config()
{
PARAMFILE=/usr/lnk/wt/oper-wt/accum/AWGS-splitconfig.txt

echo "ZA  ,/usr/lnk/wt/oper-wt/accum/TSCAWGS/ToPDMI/TSCAWGS_accum_${DATE}.txt" > ${PARAMFILE}
echo "TN  ,/usr/lnk/wt/oper-wt/accum/TSCNWGS/ToPDMI/TSCNWGS_accum_${DATE}.txt" >> ${PARAMFILE}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
ACCUMIN=/usr/lnk/wt/oper-wt/accum/AWGSCompany/ToPDMI/AWGSALL_accum_${DATE}.txt
RUNRPT=/usr/lnk/wt/oper-wt/accum/TSCAWGSsplit-report-${DATE}.txt


# Parse environment variables
#parse_env

# Assign alternate environment variables

create_config

${SHELL_DIR}/accum01sp.sh ${ACCUMIN} ${PARAMFILE} ${RUNRPT}
RETVAL=$?

if [ $RETVAL = 0 ]
then
	rm -f ${ACCUMIN}
fi

echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
