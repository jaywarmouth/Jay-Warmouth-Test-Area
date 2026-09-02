#!/bin/ksh
# to run: 
#         nsde005.pv -t -s 00000435 -p 0801 -d 20150801           (test mode)
#         nsde005.pv -s 00000435 -p 0801 -d 20150801              (prod mode)
#
# Program Name	: nsde005.pv
# Description   : Terminate lock by sponsor and reject code
#                 Update NDCLOCK file
#                 Command line arguments:
#                 -t Test Mode
# Author	: Peggy Voytilla 
# Date		: 07/30/2015
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var

OBJ_DIR="/usr/lnk/obj"

TEST_MODE=0
SPONSOR=0
POST_A_REJECT=0
TERM_DATE=0
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nsde005.pv [-t]
       <sponsor> is 8 characters
       <post_a_reject> is 4 characters
       <term_date> is 8 characters yyyymmdd

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


# Submit nsde001 program
submit_nsde005()
{
     runcobol ${OBJ_DIR}/nsde005 -s ${TEST_MODE} -a ${SPONSOR}${POST_A_REJECT}${TERM_DATE}  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        TERM_DATE=$1
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        POST_A_REJECT=$1
        ;;
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SPONSOR=$1
        ;;
    -t) TEST_MODE=1
        ;;

  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

  
NSDE001CSV=/usr/lnk/misc/NSDE005-REPORT-`date +%Y%m%d-%H%M%S`.csv
  export NSDE001CSV 
   
echo "NDCLOCK terminate by sponsor and reject"
date
echo "Input parameters"
echo "Sponsor        : ${SPONSOR}"
echo "Post-a-Reject  : ${POST_A_REJECT}"
echo "New Term Date  : ${TERM_DATE}"
echo " "
echo "Files"    
echo "NDCLOCKMAS=${NDCLOCKMAS}"
echo "FG4AUD=${FG4AUD}"
echo "NSDE001CSV=${NSDE001CSV}"
submit_nsde005 
date

exit 0
