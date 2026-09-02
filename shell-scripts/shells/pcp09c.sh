#!/bin/ksh
#
# Program Name	: pcp09c.sh
# Description   : PCP09CKEY PROGRAM            
#                 Command line arguments:
#                 -f Cardholder Filename <filename>
#                 -p PCP Filename <filename>
# Author	: Deborah Wilson
# Date		: 03/23/00
# Modifications : 07/24/2000 - Added command line arguments  (CH)
#		: 09/01/2005 - Added "umask 002"  command  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
PCP_FILE_FLAG=0
CARD_FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pcp09c.sh -f <filename> -p <filename>

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

# Submit pcp09c program
submit_pcp09c()
{
    runcobol ${OBJ_DIR}/pcp09c 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
     -f) shift
         if [ $# -le 0 ]
         then
           usage
         fi
         CARD_FILE_FLAG=1
         CARD_FILE=$1
         ;;
     -p) shift
         if [ $# -le 0 ]
         then
           usage
         fi
         PCP_FILE_FLAG=1
         PCP_FILE=$1
         ;;
  esac
  shift       
done

# Parse environment variables
parse_env

umask 002

# Assign alternate environment variables
if [ ${CARD_FILE_FLAG} = 1 ]
then
    CARDH00MAS=${CARD_FILE}
    export CARDH00MAS 
fi
if [ ${PCP_FILE_FLAG} = 1 ]
then
    PCP0100MAS=${PCP_FILE}
    export PCP0100MAS
fi

echo "Create PCP09CKEY" 
echo "EXPORT PATHS:"
echo "   CARDH00MAS=$CARDH00MAS"
echo "   PCP0100MAS=$PCP0100MAS"
date
submit_pcp09c
date

exit 0
