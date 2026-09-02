#!/bin/sh
#
# Program Name	: clmss02.sh 
# Description   : Unload indexed file CLMSS00MAS to a sequential file
#                 Command line arguments:
#		  -i <CLMSSPRM input file>
#		  -o <CLMSSEXTCSV output file>
#                 
# Author	: Debbe Adgate 
# Date		: 07/08/2016
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLAG=0
OUTFILE_FLAG=0
RETVAL=0
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmss02.sh -i <CLMSSPRM input file> -o <CLMSSEXTCAV output file>

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

	
# Submit stepcpy program
submit_clmss02()
{
      runcobol ${OBJ_DIR}/clmss02
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
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE_FLAG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLAG=1
        OUTFILE=$1
        ;;
  esac
  shift
done 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $INFILE_FLAG = 1 ]
then
        CLMSSPRM=$INFILE
else
        CLMSSPRM=/usr/lnk/wt/oper-wt/misc/CLMSSPRM.txt
fi
export CLMSSPRM

if [ $OUTFILE_FLAG = 1 ]
then
        CLMSSEXTCSV=$OUTFILE
else
        CLMSSEXTCSV=/usr/lnk/wt/oper-wt/misc/CLMSSEXTCSV-${DATETM}.txt
fi
export CLMSSEXTCSV

echo UNLOAD CLMSS00MAS TO A SEQ FILE
date
echo "EXPORT PATHS:"
echo "   CLMSS00MAS=$CLMSS00MAS "
echo "   CLMSSPRM=$CLMSSPRM "
echo "   CLMSSEXTCSV=$CLMSSEXTCSV "

submit_clmss02
echo  "   RET_CODE=$RETVAL "
date


exit $RETVAL
