#!/bin/ksh
#
# Program Name	: reconx12.sh
# Description   : Pharmacy Payment Tapes 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -f Assign alternate CLAIM00MAS
#		  -r <batch range><ccyymmdd(paid date)> - Rerun
#                 -p <Chain>
#                 -i Independent Run
#		  -t Test flag
#		  -v V5010 Flag 
# Author	: James Masluk
# Date		: 10/02/2002
# Modifications : 10/02/2003 - Added -t option  (LSJ) 
#                 11/14/2005 - Added -i option  (JM)
#		: 09/18/2009 - Changes for switch to new check run process
#		: 09/17/2014 - Had wrong OUTDAT0MAS assigned wheh switched to using -v option all the time.  Fix this so used normal file.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
FILE_FLAG=0
INDEP_RUN=0
RERUN=0
RERUN_DATA="                00000000"
CHAIN=0000
TEST_FLAG=0
V5010_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

M
usage: reconx12.sh [-s] [-i] [-f <filename>] [-r <batch range><paid date-ccyymmdd>] [-p chain] [-t] [-v]
	-s			skip sort flag (optional)
	-f <filename>		to use optional input claims file (optional)
	-r <batch range><paid date-ccyymmdd>	batchrange and paid date for rerun (optional)
	-p <chain>	enter chain # to run only one chain  (optional)
	-i              independent run
	-t		test flag  (optional)
	-v		V5010 flag (optional)

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


# Submit reconx12 program
submit_reconx12()
{
     runcobol ${OBJ_DIR}/reconx12 -s ${SKIP_SORT}${INDEP_RUN}${RERUN}${TEST_FLAG}${V5010_FLAG} -a ${RERUN_DATA}${CHAIN}
}


# Cleanup
cleanup ()
{
   rm ${RECONX12MAS}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -t) TEST_FLAG=1
        ;;
    -v) V5010_FLAG=1
	;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
    -i) INDEP_RUN=1
        ;;
    -r) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	RERUN=1
	RERUN_DATA=$1
	;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CHAIN=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

RECONX12MAS=/tmp/RECONX12MAS
export RECONX12MAS

if [ ${TEST_FLAG} = 1 ]
then
	OUTDAT0MAS=$OUTDAT0MAS-TST
	export OUTDAT0MAS
fi


echo Pharmacy Payment Tapes
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   RECONX12KEY=$RECONX12KEY"
echo "   OUTDAT0MAS=$OUTDAT0MAS"

# Submit program
submit_reconx12 

# Cleanup
echo ""
echo "-> Doing Cleanup"
echo "    removing RECONX12MAS"
cleanup

date

exit 0
