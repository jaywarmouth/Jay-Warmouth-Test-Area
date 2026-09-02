#!/bin/sh
#
#
# Program Name	: claim72srt.sh 
# Description   : SORT CLAIM KEY RECORDS BY CLAIM NUMBER AND BATCH FOR INPUT TO claim72
#                 Command line arguments
#                 -i <filename> - assign alternate input file

#                 Switches:
#                 -t Test mode 

# Date		: 10/21/2020
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLAG=0
OUTFILE_FLAG=0
TEST_MODE=0
RETVAL=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim72srt.sh -i <input file>


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

	
# Submit CLAIM72SRT program
submit_claim72srt()
{
      runcobol ${OBJ_DIR}/CLAIM72SRT -a ${TEST_MODE} 
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
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

if [ ${INFILE_FLAG} = 1 ]
then
	CLAIMINKEY=${INFILE}; export CLAIMINKEY
else
	CLAIMINKEY=/usr/lnk/keys/CLAIMINKEY
fi
if [ ${OUTFILE_FLAG} = 1 ]
then
	CLAIM72KEY=${OUTFILE}; export CLAIM72KEY
else
	CLAIM72KEY=/usr/lnk/keys/CLAIM72KEY
fi


   echo "SORT CLAIM KEY FOR INPUT TO claim72"
   date
   echo "EXPORT PATHS:"
   echo "   CLAIMINKEY=$CLAIMINKEY"
   echo "   CLAIM72KEY=$CLAIM72KEY"
   

submit_claim72srt
   date

exit ${RETVAL}
