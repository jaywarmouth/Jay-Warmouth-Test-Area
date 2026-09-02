#!/bin/ksh
#
# Program Name	: excep02.sh
# Description   : Batch Exception Update Process
#                 Command line arguments:
#                   -u Update EXCEP00MAS File
#                   -t Test Mode
#                   -c Client Abbrev. (jj);(lp)
#                   -d date of file (mmdd)
#                 Index of Clients:
#		    jj - JJHC; J&J (sys88)
#                   lp - LASH PFIZER (sys0109)
#                   wi - WSN (sys0164)
# Author	: James Masluk
# Date		: 09/29/06
# Modifications : 06/27/08 jm
#		: 01/06/2010 - Changes for use in production batch mode  (LSJ)
#               : 06/03/2013 - Removed zip_arch_elig.sh procedure (DME)
#		: 04/29/2014 - change associated with TT #9768-7; add logic for WSN (wi) batch files
#
#		 
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
EXC_DIR="/usr/lnk/elig_in"
EXC_OUT=/usr/lnk/elig_in_1
FG4AUD_DIR="/usr/lnk/audit"
AUDNAME="CRDAUD"
EXCEP02_DIR="/usr/lnk/elig_in"
PRT_DIR="/usr/lnk/misc"
DATE="null"
CLIENT="null"
SHELL="/usr/lnk/shell"
UPDATE_FILE=0
TEST_MODE=0
DATETME=`date +%m%d%Y%H%M%S`
CONV_PDF="/usr/lnk/shell/conv_elig_rpts.sh"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: excep02.sh [-u] [-t] [-c <client_id>] [-d <mmdd>]
	client_id - 2-char client ID

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

# Set test variables
set_test()
{
   EXC_DIR="/usr/lnk/elig_in"    
   EXC_OUT=/usr/lnk/elig_in_1
   FG4AUD_DIR="/usr/lnk/tmp"
   AUDNAME="TSTAUD"
   EXCEP02_DIR="/usr/lnk/elig_in"   
   PRT_DIR="/usr/lnk/misc"
   SYS="0099"
   EXCEP02TAP=${EXC_DIR}/${CLIENT}x${DATE}
   PROGRAM=excep02
}

# Submit test excep02
submit_test()
{
   FG4AUD=${FG4AUD_DIR}/${AUDNAME}
   export EXCEP02TAP FG4AUD
   runcobol ${OBJ_DIR}/${PROGRAM} -s ${UPDATE_FILE}${TEST_MODE} -a ${CLIENT}x${DATE}   
}


#
# Validate -c options
validate_client()
{  case ${CLIENT} in
     "jj" | "lp" | "ar" | "wi" | "ts")
	;;
     *)  usage
	 ;;
   esac
}

#
# Set variables
#
set_variables()
{
   if [ ${CLIENT} = "null" ]
   then
     usage
   else
     PROGRAM=excep02
     EXCEP02TAP=${EXCEP02_DIR}/${CLIENT}x${DATE}.lin
     export EXCEP02TAP
     case ${CLIENT} in
       "jj")
          SYS="0088"
	  ;;
       "lp")
          SYS="0109"
          ;;
       "ar")
          SYS="0123"
          ;;
       "ar")
          SYS="0164"
          ;;
       "ts")
	  set_test
          ;;
     esac
   fi 
   REPORT0PCX=${EXC_DIR}/EXC02_${SYS}_${DATETME}.csv
   export REPORT0PCX
}


#
# Submit excep02 program
submit_excep02()
{
  if [ ${DATE} = "null" ]
  then
    echo "DATE="${DATE}
    usage
  else
     if test -s ${EXC_DIR}/${CLIENT}x${DATE}
     then
	if [ $TEST_MODE = 1 ]
	then
		submit_test
	else
             if test -s ${EXCEP02TAP}
             then
	       rm -f ${PRT_DIR}/PRINT-EX-${SYS}
               runcobol ${OBJ_DIR}/${PROGRAM} -s ${UPDATE_FILE}${TEST_MODE} -a ${CLIENT}x${DATE}  
             else
	       echo
               echo "###################### ERROR MESSAGE #####################"
               echo "${EXCEP02TAP} is zero or doesn't exist"
               echo "Have this fixed, then rerun excep02 script"
               echo "##########################################################"
               exit 1
             fi
	fi
     else
        echo "### MESSAGE ###"
        echo "${EXC_DIR}/${CLIENT}x${DATE} is zero or doesn't exist"
        echo "If this is not correct, let your supervisor know immediately"
     fi
  fi
}

#
# Print report
print_rpt()
{
        if test -s ${PRT_DIR}/PRINT-EX-${SYS}
        then
                ${CONV_PDF} PRINT-EX-${SYS} ${PRT_DIR}
	else
		echo "No PRINT-EX-${SYS} file created..."
        fi
}



#
# Cleanup
cleanup ()
{
	rm -f ${EXC_DIR}/${CLIENT}x${DATE}
	rm -f ${EXCEP02TAP}
	mv ${EXC_OUT}/${CLIENT}x${DATE} ${EXC_OUT}/sys${SYS}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -u) UPDATE_FILE=1
        ;;
    -t) TEST_MODE=1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLIENT=$1
        validate_client
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign other variables
FG4AUD=${FG4AUD_DIR}/${AUDNAME}
export FG4AUD

# Set Internal Variables
set_variables

# Submit Excep02
echo "SYSTEM - ${SYS}"
echo ""
echo "Exception File Update -- excep02"
date
submit_excep02 
date

# Print procedure
echo ""
echo "--> Printing Report..."
print_rpt

# Cleanup
echo ""
echo "-> Doing Cleanup"
if [ $TEST_MODE = 0 ]
then
	cleanup
fi

exit 0
