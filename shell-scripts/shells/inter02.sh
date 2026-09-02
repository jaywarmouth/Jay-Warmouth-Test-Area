#!/bin/ksh
#
# Program Name	: inter02.sh   
# Description   : INTER00MAS set reject flag.
#                 Command line arguments:
#                 -f <filename>		Assign alternate INTER00MAS
# Author	: William Kohuth
# Date		: 07/18/2012
# Modifications :                                                            
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: inter02.sh [-f <filename>]
	-f <filename>	Assign different INTER00MAS

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

# Submit inter02 program
submit_inter02( )
{
     runcobol ${OBJ_DIR}/inter02
}

#
# Main routine
#

# Parse environment variables
parse_env

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
	INTER00MAS=$1
	export INTER00MAS
	;;
  esac
  shift
done


echo "Set INTER-REJ-FLAG based on NDCSEQ file"
date
echo "EXPORT PATHS:"
echo "   NDCSEQ=$NDCSEQ"
echo "   NDCIDX=$NDCIDX"
echo "   INTER00MAS=$INTER00MAS"
submit_inter02
date

exit 0
