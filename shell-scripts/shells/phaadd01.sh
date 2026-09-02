#!/bin/sh
#
# Program Name	: phaadd01.sh 
# Description   : Update indexed file PHALOCKMAS from a sequential file
#                 Command line arguments:
#		  -i <PHA00PRM filename> - input text filename
#		  -o <PHA00CSV filename> - output CSV filename                 
#                 
# Author	: Lucy A. Caraballo
# Date		: 04/15/2017
# Modifications : 06/19/2017 - Changes for production version 
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RETVAL=0
INFILE="null"
OUTFILE="null"
AUDIT_DIR=/usr/lnk/audit

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phaadd01.sh -t -i <input PHA00ORM> -o <output PHA00CSV>

ENDOFUSAGE
  exit 99
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

	
# Submit phaadd01 program
submit_phaadd01()
{
      runcobol ${OBJ_DIR}/phaadd01 -s ${TEST_MODE}  
	RETVAL=$?
}      

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1     
        ;;
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	INFILE=$1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	OUTFILE=$1
	;;
  esac
  shift
done

 
#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ ${INFILE} = "null" ]
then
	usage
fi
if [ ${OUTFILE} = "null" ]
then
	usage
fi

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=${AUDIT_DIR}/PHAAUD
  export FG4AUD

PHA00CSV=${OUTFILE}
  export PHA00CSV 

PHA00PRM=${INFILE}
  export PHA00PRM

echo UPDATE PHALOCKMAS FROM A SEQ FILE
date
echo "EXPORT PATHS:"
echo "   PHALOCKMAS=$PHALOCKMAS "
echo "   PHA00PRM=$PHA00PRM "
echo "   PHA00CSV=$PHA00CSV "
echo "   FG4AUD=$FG4AUD "

submit_phaadd01
echo  "   RETVAL=$RETVAL "
date


exit $RETVAL
