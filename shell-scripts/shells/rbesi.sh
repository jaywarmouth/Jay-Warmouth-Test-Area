#!/bin/sh
#
# Program Name	: rbesi.sh
# Description   : Claims Extract for ESI (formerly Medco)
#                 Command line arguments:
#                 -c Run Option (FULL|HALF1|HALF2)
#                 -b Run Year and Month (YYYYMM)
#		  -x Separate REV file flag
#		  -r <batch range> - Rerun option
#			Uses entered batch range and skips p/e calculation logic.
#		  -f <file> - assign alternate CLAIM00MAS
# Author	: Vito Restaino
# Date		: 03/21/2011
# modifications : 05/08/2015 - addition of RESELPARM and SUMMARY files logic
#		: 12/09/2015 - TT8864-20; logic for RESELSYSTEM parameter file and SYSTEMSUMMARY file.
#		: 5/9/2016 - TT12142-4; new messages report file and change of REBATEFILE variable to REBAT00MAS.
#		: 07/27/2017 - TT8864-41; add RETBL00MAS file logic.
#		: 09/26/2017 - TT8864-59
#		: 01/26/2018 - TT17992-1; new input config files
#		: 02/08/2018 - TT18167-11; removal of logic related to RESELPARM
#		: 01/242019 - TT19211-1
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
PROG=rbesi-2500
RERUN=0
BATCH="0000000000000000"
FILE_FLAG=0
REVFILESW=0
REPORT_DIR="/usr/lnk/wt/oper-wt/rebateinfo"


# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rbesi.sh [-c full|half1|half2] [-b yyyymm] [-r <batch range>] [-f <file>] -x
       -c Run Option (Full Month|1st Hlf Mnth| 2nd Hlf Mnth ) required
       -b Run Year and Month (YYYYMM)                         required
       -r Rerun option (batch range)			      optional
       -f <file>	use alternate CLAIM00MAS	      optional
       -x		Separate REV file switch	      optional

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


# Submit rbesi program
submit_rbesi()
{
    if [ ${RUNOPT} = "null" ]
    then
      usage
    else
       if [ ${RUN_INFO} = "null" ]
       then
          usage
       else
          runcobol ${OBJ_DIR}/${PROG} -s ${FULL}${HALF1}${HALF2}${RERUN}${REVFILESW} -a ${RUN_INFO}${BATCH}
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
     -x) REVFILESW=1
	;;
   esac
   shift
 done
 
 
# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $RERUN = 1 ]
then
	REBAT00MAS=/usr/lnk/tapes/RB-ESI-${RUN_INFO}-SPEC
	REBAT00REV=/usr/lnk/tapes/RB-ESI-REV-${RUN_INFO}-SPEC
else
	REBAT00MAS=/usr/lnk/tapes/RB-ESI-${RUN_INFO}
	REBAT00REV=/usr/lnk/tapes/RB-ESI-REV-${RUN_INFO}
fi
export REBAT00MAS REBAT00REV

if [ $FILE_FLAG = 1 ]
then
	CLAIM00MAS=$FILE
	export CLAIM00MAS
fi


SUMMARY=${REPORT_DIR}/RBESI-2500-GROUP-SUMMARY-${RUN_INFO}.csv
SYSTEMSUMMARY=${REPORT_DIR}/RBESI-2500-SYSTEM-SUMMARY-${RUN_INFO}.csv
REMSG00RPT=${REPORT_DIR}/RBESI-2500-MESSAGES-${RUN_INFO}.csv

export SUMMARY SYSTEMSUMMARY REMSG00RPT 


echo "Claims Extracts for Medco Rebates"
date
echo
echo "REBAT00MAS=${REBAT00MAS}"
echo "REBAT00REV=${REBAT00REV}"
echo "RESELSYSTEM=$RESELSYSTEM"
echo "SUMMARY=$SUMMARY"
echo "REMSG00RPT=$REMSG00RPT"
echo "RETBL00MAS=$RETBL00MAS"
echo "REHEPC0MAS=$REHEPC0MAS"
echo "RESPEC0MAS=$RESPEC0MAS"
echo "RENDCEXCL=$RENDCEXCL"
echo "RENABPEXCL=$RENABPEXCL"
echo "CLAIM00MAS=$CLAIM00MAS"
echo


# Submit the program
submit_rbesi

date

exit 0
