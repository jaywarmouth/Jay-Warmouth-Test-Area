#!/bin/ksh
#
# Program Name	: inter03.sh   
# Description   : Create NDCIDX from NDCSEQ.
#                 Command line arguments:
#           
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

usage: inter03.sh 

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

# Submit inter03 program
submit_inter03( )
{
     runcobol ${OBJ_DIR}/inter03
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Create NDCIDX file from NDCSEQ file"
date
echo "EXPORT PATHS:"
echo "   NDCSEQ=$NDCSEQ"
echo "   NDCIDX=$NDCIDX"
submit_inter03
date

exit 0
