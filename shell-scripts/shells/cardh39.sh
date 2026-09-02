#!/bin/ksh
#
# Program Name	: cardh39.sh
# Description   : cardh39 Eligibility 
#                 Command line arguments:
#                   -i Interactive 
#                   -c Client Abbrev. (ss)
#                   -d date of file (mmdd or mmdd.###)
#                 Explaination of ELIG_TYPE:
#                   0 - Input files is non-converted ??e in elig_in directory
#                   1 - Input file is a converted .lin file in elig_in directory
#                   9 - Testing (ts)
#                 Index of Clients:
#		    ss - SSC (sys63)
#                   ts - TEST (sys99)
# Author	: James Masluk         
# Date		: 08/20/02
# Modifications : 04/08/2004 - Fixed the zip_arch_elig.sh to include the new "-e" option  (LSJ)
#		: 10/20/2006 - Changes for 4-digit system number  (LSJ)
# 
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT=/usr/lnk/elig_in_1
FG4AUD_DIR="/usr/lnk/audit"
AUDNAME="CRDAUD"
CARDH39_DIR="/usr/lnk/elig_in"
PRT_DIR="/usr/lnk/po/misc"
DATE="null"
CLIENT="null"
INTERACTIVE=0
SHELL="/usr/lnk/shell"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh39.sh [-i] [-c ss] [-d <mmdd> or <mmdd.###>]

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
   ELIG_DIR="/usr/lnk/elig_in"
   ELIG_OUT=/usr/lnk/elig_in_1
   FG4AUD_DIR="/usr/lnk/tmp"
   AUDNAME="CRDAUD"
   CARDH39_DIR="/usr/lnk/elig_in"
   PRT_DIR="/usr/lnk/po/misc"
   SYS="0099"
   RPT_NAME="0099"
   CARDH39TAP=${ELIG_DIR}/${CLIENT}e${DATE}
   PROGRAM=cardh39
}

# Submit test cardh39
submit_test()
{
   FG4AUD=${FG4AUD_DIR}/${AUDNAME}
   export CARDH39TAP FG4AUD
   runcobol ${OBJ_DIR}/${PROGRAM} -s ${INTERACTIVE} -a ${CLIENT}e${DATE}
}

# Cleanup test
cleanup_test()
{
   lp ${PRT_DIR}/PRINT-39-PCP-${RPT_NAME}
}

#
# Validate -c options
validate_client()
{  case ${CLIENT} in
     "ss")
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
     PROGRAM=cardh39
     case ${CLIENT} in
       "ss")
          SYS="0063"
          RPT_NAME="$SYS"
	  CARDH39TAP=${CARDH39_DIR}/${CLIENT}e${DATE}
	  ;;
       "ts")
	  set_test
          ;;
     esac
   fi 
}

#
# Set elig type
#
get_elig_type()
{
  case ${CLIENT} in
    "ss")
       ELIG_TYPE=0
       ;;
    "ts")
       ELIG_TYPE=9
  esac
}

#
# Submit cardh39 program
submit_cardh39()
{
  if [ ${DATE} = "null" ]
  then
    echo "DATE="${DATE}
    usage
  else
     rm -f ${PRT_DIR}/PRINT-39-${RPT_NAME}
     FG4AUD=${FG4AUD_DIR}/${AUDNAME}
     export CARDH39TAP FG4AUD
     if test -s ${ELIG_DIR}/${CLIENT}e${DATE}
     then
        case ${ELIG_TYPE} in
          "0")
             runcobol ${OBJ_DIR}/${PROGRAM} -s ${INTERACTIVE} -a ${CLIENT}e${DATE}
             ;;
          "1")
             if test -s ${CARDH39TAP}
             then
               runcobol ${OBJ_DIR}/${PROGRAM} -s ${INTERACTIVE} -a ${CLIENT}e${DATE}
             else
	       echo
               echo "###################### ERROR MESSAGE #####################"
               echo "${CARDH39TAP} is zero or doesn't exist"
               echo "Have this fixed, then rerun cardh39 script"
               echo "##########################################################"
               exit 1
             fi
             ;;
          "9")
	     submit_test
	     ;;
        esac
     else
        echo "### MESSAGE ###"
        echo "${ELIG_DIR}/${CLIENT}e${DATE} is zero or doesn't exist"
        echo "If this is not correct, let your supervisor know immediately"
     fi
  fi
}

#
# Cleanup
cleanup ()
{
   rm -f ${ELIG_DIR}/${CLIENT}e${DATE}
   mv ${ELIG_OUT}/${CLIENT}e${DATE} ${ELIG_OUT}/sys${SYS}
   case ${ELIG_TYPE} in
      "9")
	 cleanup_test 
	 ;;
   esac
   lp ${PRT_DIR}/PRINT-39-${RPT_NAME}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) INTERACTIVE=1
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

# Get the Elig. Type
get_elig_type

# Submit cardh39
submit_cardh39 

# Cleanup
echo ""
echo "-> Doing Cleanup"
cleanup

# Zip archive files
echo ""
echo "-> Zipping archive files"
${SHELL}/zip_arch_elig.sh -t elig -c ${CLIENT} -d ${DATE} -s ${SYS} -e ${ELIG_TYPE}


exit 0
