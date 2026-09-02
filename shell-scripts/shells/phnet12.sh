#!/bin/ksh
#
# Program Name	: phnet12.sh
# Description   : PHNET00MAS to REDBRICK by network.
#                 Command line arguments:
#		  -a <system range>
#		  -z Sample data flag
#                 -f Complete update(Full-Run)
# Author	: Dave Tucci
# Date		: 02/12/99
# Modifications : 04/04/2001 - Added sample data flag logic  (LSJ)
#		: 10/26/2005 - Addition of Full-Run switch 
#		: 05/19/2006 - Added alternate filename for full-run  (LSJ)
#		: 10/19/2012 - Removed logic for alternate filename for full-run
#		: 04/24/2017 - TT17149-5; convert switch to linkage for runcobol command.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
NET_RANGE=0
FULL_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet12.sh [-f] [-a <network range>] [-z]

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

# Submit phnet12 program
submit_phnet12()
{
   if [ ${NET_RANGE} = 0 ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/phnet12 -a ${FULL_RUN}${NET_RANGE}
   fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        NET_RANGE=$1
        ;;
    -f) FULL_RUN=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "PHNET00MAS Redbrick File Extract"
date
echo "EXPORT PATHS:"
echo "   PHNETRB001= "${PHNETRB001}
echo "   NETWORK RANGE= "${NET_RANGE}
submit_phnet12
date

exit 0
