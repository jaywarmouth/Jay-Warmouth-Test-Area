#!/bin/ksh
#
# Program Name	: rbmedco.sh
# Description   : Claims Extract for Medco
#                 Command line arguments:
#                 -c Run Option (FULL|HALF1|HALF2)
#                 -b Run Year and Month (YYYYMM)
#		  -l Old layout flag to run rbmedco program instead of rbmedco-2500
#		  -r <batch range> - Rerun option
#			Uses entered batch range and skips p/e calculation logic.
#		  -f <file> - assign alternate CLAIM00MAS
# Author	: Vito Restaino
# Date		: 03/21/2011
# Modifications : 01/12/2012 - Changed default program and added "-l" option
#		: 03/30/2012 - Added "-r" option
#		: 04/03/2012 - Added "-f" option
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RUNOPT="null"
FULL=0
HALF1=0
HALF2=0
RUN_INFO="null"
PROG=rbmedco-2500
RERUN=0
BATCH="0000000000000000"
FILE_FLAG=0

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rbmedco.sh [-c full|half1|half2] [-b yyyymm] [-l] [-r <batch range>] [-f <file>]
       -c Run Option (Full Month|1st Hlf Mnth| 2nd Hlf Mnth ) required
       -b Run Year and Month (YYYYMM)                         required
       -l flag to run old layout (rbmedco) program instead of rbmedco-2500
       -r Rerun option (batch range)			      optional
       -f <file>	use alternate CLAIM00MAS	      optional

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

# Validate -c options
 validate_runopt()
 {  case ${RUNOPT} in
      "full")
         FULL=1
         ;;
      "half1")
         HALF1=1
         ;;
      "half2")
         HALF2=1
         ;;
     *)  usage
          ;;
 
    esac
 }


# Submit rbmedco program
submit_rbmedco()
{
    if [ ${RUNOPT} = "null" ]
    then
      usage
    else
       if [ ${RUN_INFO} = "null" ]
       then
          usage
       else
          runcobol ${OBJ_DIR}/${PROG} -s ${FULL}${HALF1}${HALF2}${RERUN} -a ${RUN_INFO}${BATCH}
       fi
    fi
}

#
# Main routine
# Check command line validity, call usage if incorrect
if [ $# -le 0 ]
then 
	usage
fi

 while [ $# -gt 0 ]
 do
   case "$1"
   in
     -b) shift
         if [ $# -le 0 ]
         then
           usage
         fi
         RUN_INFO=$1
         ;;
     -c) shift
         if [ $# -le 0 ]
         then
           usage
         fi
         RUNOPT=$1
         validate_runopt
         ;;
     -l) PROG=rbmedco
	 ;;
     -r) shift
         if [ $# -le 0 ]
         then
           usage
         fi
	 RERUN=1
         BATCH=$1
	 ;;
     -f) shift
         if [ $# -le 0 ]
         then
           usage
         fi
	 FILE_FLAG=1
         FILE=$1
	 ;;
 
   esac
   shift
 done
 
 
# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $RERUN = 1 ]
then
	REBATEFILE=/usr/lnk/tapes/RB-MEDCO-${RUN_INFO}-SPEC
else
	REBATEFILE=/usr/lnk/tapes/RB-MEDCO-${RUN_INFO}
fi
export REBATEFILE

if [ $FILE_FLAG = 1 ]
then
	CLAIM00MAS=$FILE
	export CLAIM00MAS
fi

echo "Claims Extracts for Medco Rebates"
date
echo
echo "REBATEFILE=${REBATEFILE}"
echo "CLAIM00MAS=$CLAIM00MAS"
echo


# Submit the program
submit_rbmedco

date

exit 0
