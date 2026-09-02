#!/bin/sh
# Program Name	: cardh175.sh
# Description   : Limit Balance Report (CSV)         
#                 Command line arguments
#                 Switches:
#                 -t Test mode (no Warehouse extract file writes)
#		  -p <PARMFILE name>
#		  -o <output HWELL00CSV>  
# Author	: John Shrigley     
# Date		: 3/4/2016
# Modifications :                                               
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
OUTFILE_FLG=0
INFILE_FLG=0
TEST_MODE=0
DATE=`date +%Y%m%d`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh175.sh -t -p <parmfile> -o <output CVS file>

ENDOFUSAGE
  exit 1
}


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

	
# Submit cardh175 program
submit_cardh175()
{
      runcobol ${OBJ_DIR}/cardh175 -s ${TEST_MODE} 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
	usage
fi
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        INFILE_FLG=1
        PARMFILE=$1
        ;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        HWELL00CSV=$1
        ;;
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

if [ ${OUTFILE_FLG} = 0 ]
then
	usage
fi
if [ ${INFILE_FLG} = 0 ]
then
	usage
fi
export PARMFILE HWELL00CSV


echo "Limit Balance Report"

date
echo "EXPORT PATHS:"
echo "   CARDH00MAS=$CARDH00MAS"
echo "   GROUP00MAS=$GROUP00MAS"
echo "   PLAN000MAS=$PLAN000MAS"
echo "   LIMIT00MAS=$LIMIT00MAS"
echo "   HWELL00CSV=$HWELL00CSV" 
echo "   PARMFILE=$PARMFILE" 

submit_cardh175
date

exit $RETVAL
