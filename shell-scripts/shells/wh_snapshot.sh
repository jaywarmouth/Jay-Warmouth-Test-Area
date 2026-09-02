#!/bin/ksh
#
# Program Name	: wh_snapshot.sh
# Description	: Runs procedures for snapshot extract files for warehouse
# Author	: Linda S. Jefferis
# Date		: 11/06/2002
# Modifications : 11/21/2002 - Added "wc -l" of files for display  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/rb_01/snapshot"
FLEX="/usr/lnk/flexgen"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_snapshot.sh 

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

rm -f ${FILE_PATH}/*.txt
echo "--> Removed all *.txt files in ${FILE_PATH}"
echo ""
cd ${FLEX}

date
echo "--> Starting - ohbenpc001.cs"
ohbenpc001.cs

date
echo "--> Starting - ohcoppc001.cs"
ohcoppc001.cs

date
echo "--> Starting - ohdrdpc001.cs"
ohdrdpc001.cs

date
echo "--> Starting - ohgdepc001.cs"
ohgdepc001.cs

date
echo "--> Starting - ohgenpc001.cs"
ohgenpc001.cs

date
echo "--> Starting - ohgropc001.cs"
ohgropc001.cs

date
echo "--> Starting - ohplapc001.cs"
ohplapc001.cs

date
echo "--> Starting - ohsdepc001.cs"
ohsdepc001.cs

date
echo "--> Starting - ohdrtpc001.cs"
ohdrtpc001.cs

date
echo "--> Starting - ohsyspc001.cs"
ohsyspc001.cs

date
echo "--> Starting - ohspopc001.cs"
ohspopc001.cs

echo "Snapshot Extract procedures are completed..."
echo ""
echo "Record Counts of files....."
echo ""
wc -l ${FILE_PATH}/*

exit 0
