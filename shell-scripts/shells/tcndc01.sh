#!/bin/ksh
#
# Program Name  : tcndc01.sh
# Description   : NDC File Export for Trialcard
#		  Command Line Arguments: None
#
#                 Program uses no switches.
# Author        : John Kutchenriter
# Date          : 02/12/2010
# Modifications : 06/28/2010 - Modifications made  (LSJ)
#		: 12/14/2011 - DATE changed to "yesterday" and file has new layout
#		: 03/10/2016 - TT13309-6
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/po/misc
DATE=`date -d "yesterday 0800" +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tcndc01.sh

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


# Submit tcndc01 program
submit_tcndc01()
{
        runcobol ${OBJ_DIR}/tcndc01

}

#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables
TCNDC01TAP=/usr/lnk/tapes/TCNDC-${DATE}
export TCNDC01TAP


date
echo "FILE NAMES:"
echo "	TCNDC01TAP=$TCNDC01TAP"
submit_tcndc01
date

exit 0
