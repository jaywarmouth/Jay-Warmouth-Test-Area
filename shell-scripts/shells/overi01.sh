#!/bin/ksh
#
# Program Name	: overi01.sh
# Description   : Batch Override Update Process
#                 Command line arguments:
#                   -u Update OVERI00MAS File
#                   -t Test Mode
#                   -c Client Abbrev. (jj)
#                   -d date of file (mmdd)
#                 Index of Clients:
#		    jj - JJHC; J&J (sys88)
# Author	: James Masluk
# Date		: 10/06/06
# Modifications :
#		: Removed zip_arch_elig.sh procedure (DME)
#		 
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
OVR_DIR="/usr/lnk/elig_in"
OVR_OUT=/usr/lnk/elig_in_1
FG4AUD_DIR="/usr/lnk/audit"
AUDNAME="CRDAUD"
OVERI01_DIR="/usr/lnk/elig_in"
PRT_DIR="/usr/lnk/misc"
DATE="null"
CLIENT="null"
SHELL="/usr/lnk/shell"
UPDATE_FILE=0
TEST_MODE=0
DATETME=`date +%m%d%Y%H%M%S`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: overi01.sh [-u] [-t] [-c jj] [-d <mmdd>]

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
   OVR_DIR="/usr/lnk/elig_in"    
   OVR_OUT=/usr/lnk/elig_in_1
   FG4AUD_DIR="/usr/lnk/tmp"
   AUDNAME="TSTAUD"
   OVERI01_DIR="/usr/lnk/elig_in"   
   PRT_DIR="/usr/lnk/misc"
   SYS="0099"
   OVERI01TAP=${OVR_DIR}/${CLIENT}o${DATE}
   PROGRAM=overi01
}

# Submit test overi01
submit_test()
{
   FG4AUD=${FG4AUD_DIR}/${AUDNAME}
   export OVERI01TAP FG4AUD
   runcobol ${OBJ_DIR}/${PROGRAM} -s ${UPDATE_FILE}${TEST_MODE} -a ${CLIENT}o${DATE}  
}


#
# Validate -c options
validate_client()
{  case ${CLIENT} in
     "jj" | "ts")
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
     PROGRAM=overi01
     case ${CLIENT} in
       "jj")
          SYS="0088"
          OVERI01TAP=${OVERI01_DIR}/${CLIENT}o${DATE}.lin
	  ;;
       "ts")
	  set_test
          ;;
     esac
   fi 
   REPORT0PCX=${OVR_DIR}/OVR01_${SYS}_${DATETME}.csv
   export REPORT0PCX
}


#
# Submit overi01 program
submit_overi01()
{
  if [ ${DATE} = "null" ]
  then
    echo "DATE="${DATE}
    usage
  else
     FG4AUD=${FG4AUD_DIR}/${AUDNAME}
     export OVERI01TAP FG4AUD
     if test -s ${OVR_DIR}/${CLIENT}o${DATE}
     then
	if [ $TEST_MODE = 1 ]
        then
                submit_test
        else
             if test -s ${OVERI01TAP}
             then
               runcobol ${OBJ_DIR}/${PROGRAM} -s ${UPDATE_FILE}${TEST_MODE} -a ${CLIENT}o${DATE}
             else
	       echo
               echo "###################### ERROR MESSAGE #####################"
               echo "${OVERI01TAP} is zero or doesn't exist"
               echo "Have this fixed, then rerun overi01 script"
               echo "##########################################################"
               exit 1
             fi
	fi
     else
        echo "### MESSAGE ###"
        echo "${OVR_DIR}/${CLIENT}o${DATE} is zero or doesn't exist"
        echo "If this is not correct, let your supervisor know immediately"
     fi
  fi
}


#
# Cleanup
cleanup ()
{
	mv ${OVR_OUT}/${CLIENT}o${DATE} ${OVR_OUT}/sys${SYS}
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


# Set Internal Variables
set_variables

# Submit Overi01
submit_overi01 

if test -s ${REPORT0PCX}
then
   scp -q ${REPORT0PCX} husk:/usr/lnk/shares/ftp-tmp
   if test $? -eq 0
   then
      echo "--> ${REPORT0PCX} is ready"
      mv ${REPORT0PCX} ${OVR_OUT}/sys${SYS}
   else
      echo "--*> ERROR copying ${REPORT0PCX} to Husk"
   fi
else
   echo "--*>  The OVR01 file does not exist. Verify that displayed ERROR RECORDS count is zero.  If not, contact supervisor."
fi


# Cleanup
echo ""
echo "-> Doing Cleanup"
if [ $TEST_MODE = 0 ]
then
        cleanup
fi

exit 0
