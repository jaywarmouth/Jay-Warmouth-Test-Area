#!/bin/ksh
#
# Program Name  : rm-chk-tapes.sh
# Description   : Removal of check run reconx12 tapes files
# Author        : Linda S. Jefferis
# Date          : 09/25/2009
# Modifications : 10/13/2010 - Added remove command for files in CVSC directory
#		: 11/17/2011 - Added logic for v5010 directory
#		: 10/19/2012 - Removed logic for v5010 directory
#		: 10/30/2014 - Removed "-p" logic  (LSJ)
#
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TAPE_DIR="/usr/lnk/shares/ftp-tmp/X12"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-chk-tapes.sh 

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

#
#
# Main routine
#

find ${TAPE_DIR}/chk -name "*-V5010*" -exec rm -f {} \;
rm -f ${TAPE_DIR}/chk/CVSC/*

exit 0
