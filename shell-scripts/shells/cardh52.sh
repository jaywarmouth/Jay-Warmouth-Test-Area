#!/bin/ksh
#
# Program Name	: cardh52.sh
# Description   : CARD00MAS to REDBRICK by system.
#                 Command line arguments:
#		  -a <system range> - start and end system need each to be 4 digits
#                 -s Skip the system check for inactive systems
#                 -f Complete update(Full-Run)
#		  -z  sample data flag (optional)
# Author	: Dave Tucci
# Date		: 02/10/99
# Modifications : 11/15/1999 - Added "Skip system check of inactive systems" 
#		: 04/04/2001 - Added sample data flag logic  (LSJ)
#		: 10/26/2005 - Addition of Full-Run switch
#		: 05/19/2006 - Alternate CARDHRB001 name for Full-Run  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
IGNORE_SYSTEM_CHECK=0
SYS_RANGE="null"
SAMP_FLAG=0
FULL_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh52.sh [ -s ] [-f][-a <system range e.g. 00010018>] [-z]

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

# Submit cardh52 program
submit_cardh52()
{
   if [ ${SYS_RANGE} = "null" ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/cardh52 -s ${IGNORE_SYSTEM_CHECK}${FULL_RUN} -a ${SYS_RANGE}
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
        SYS_RANGE=$1
        ;;
    -s) IGNORE_SYSTEM_CHECK=1
        ;;
    -f) FULL_RUN=1
        ;;
    -z) SAMP_FLAG=1
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
if [ ${FULL_RUN} = 1 ]
then
	CARDHRB001=${CARDHRB001}-FULL
	export CARDHRB001
fi


echo "Extract of CARD file for Redbrick"
date
echo "EXPORT PATHS:"
echo "   CARDHRB001=${CARDHRB001}"
echo "   SYSTEM RANGE=${SYS_RANGE}"
submit_cardh52
date

exit 0
