#!/bin/ksh
#
# Program Name	: phdem03.sh
# Description   : PHDEM00MAS to REDBRICK.
#		  Command Line Arguments:
#		    -z  Sample data flag
#                   -f Complete update(Full-Run)
# Author	: Dave Tucci
# Date		: 03/03/99
# Modifications : 04/04/2001 - Added sample data flag logic  (LSJ)
#		: 10/26/2005 - Addition of Full-Run switch
#		: 05/19/2006 - Added Alt. filename for Full-Run  (LSJ)
#		: 10/19/2012 - Removed logic for Alt. filename for Full-Run
#		: 03/01/2017 - TT13065-4; change in runcobol command
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SAMP_FLAG=0
FULL_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phdem03.sh [-f] [-z]

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit phdem03 program
submit_phdem03()
{
     runcobol ${OBJ_DIR}/phdem03 -a ${FULL_RUN}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -z) SAMP_FLAG=1
        ;;
    -f) FULL_RUN=1
        ;;
     *) usage
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${SAMP_FLAG} = 1 ]
then
        ENV_FILE="/usr/lnk/demo/env_var.demo"
        parse_env
fi


echo "PHDEM00MAS Redbrick File Extract"
date
echo "EXPORT PATHS:"
echo "   PHDEMRB001=$PHDEMRB001"
submit_phdem03
date

exit 0
