#!/bin/ksh
#
# Program Name	: rbmedco-caps.sh
# Description   : Claims Extract for Medco/CAPS Rebates
#                 Command line arguments:
#                 -c Rebate Company (MED|CAP)  
#                 -b Run Year and Month (YYYYMM)
# Author	: Vito Restaino
# Date		: 01/07/2011
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
COMPANY="null"
MED=0
CAP=0
RUN_INFO="null"

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rbmedco-caps.sh [-c med|cap] [-b yyyymm]
       -c Rebate Company (med or cap)         required
       -b Run Year and Month (YYYYMM)         required

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

conv_date()
{
	TMP_DATE=`date -d "+1 month ${RUN_INFO}01" +%Y%m`
	CAP_DATE=`date -d "yesterday ${TMP_DATE}01" +%Y%m%d`
}

# Validate -c options
 validate_company()
 {  case ${COMPANY} in
      "med")
         MED=1
	 REBATEFILE=/usr/lnk/tapes/RB-MEDCO-${RUN_INFO}; export REBATEFILE
	 echo "REBATEFILE=$REBATEFILE"
         ;;
      "cap")
         CAP=1
	 conv_date
	 CAPSREBATE=/usr/lnk/tapes/PDMI${CAP_DATE}; export CAPSREBATE
	 echo "CAPSREBATE=$CAPSREBATE"
         ;;
     *)  usage
          ;;
 
    esac
 }

# Submit rbmedco-caps program
submit_rbmedco-caps()
{
    if [ ${COMPANY} = "null" ]
    then
      usage
    else
       if [ ${RUN_INFO} = "null" ]
       then
          usage
       else
          runcobol ${OBJ_DIR}/rbmedco-caps -s ${MED}${CAP} -a ${RUN_INFO}
       fi
    fi
}

#
# Main routine
# Check command line validity, call usage if incorrect
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
         COMPANY=$1
         ;;
 
   esac
   shift
 done
 
 
# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Claims Extracts for Medco Rebates"
date
echo

validate_company

# Submit the program
submit_rbmedco-caps

date

exit 0
