#!/bin/sh
#
# Program Name	: convert-exc.sh
# Description	: Run cobol conversion programs for EXCEP00MAS
# Author	: Linda S. Jefferis
# Date		: 6/9/2013
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SHELL_DIR=/usr/lnk/shell

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convert-exc.sh 

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

# Parse environment variables
parse_env

SEQEXCEP00MAS=/usr/lnk/tmp/SEQEXCEP00MAS
export SEQEXCEP00MAS

date
echo ""
echo "Starting Exception File Unload to Sequential - GPIUNLOADEXCEP00MAS"
echo "EXCEP00MAS=$EXCEP00MAS"
echo "SEQEXCEP00MAS=$SEQEXCEP00MAS"

runcobol ${OBJ_DIR}/GPIUNLOADEXCEP00MAS

echo "GPIUNLOADEXCEP00MAS - Finished"

date

EXCEP00MAS=/usr/lnk/tmp/NEWEXCEP00MAS
export EXCEP00MAS

echo ""
echo "Starting Creation of new EXCEP00MAS - GPILOADEXCEP00MAS"
echo "EXCEP00MAS=$EXCEP00MAS"
echo "SEQEXCEP00MAS=$SEQEXCEP00MAS"

runcobol ${OBJ_DIR}/GPILOADEXCEP00MAS

echo ""
date
echo "Finished"

exit 0
