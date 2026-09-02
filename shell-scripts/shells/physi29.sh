#!/bin/ksh
#
# Program Name	: physi29.sh
# Description   : Physician Update from Tape 
#                 Command line arguments:
#		  -c Client Abbrev. (au|ts)
#			Index of Clients:
#				au - AHF;Aultman(sys48)
#				um - PSG(157/1206)
#				co - PSG(157/1245)
#				mr - PSG(157/1252)
#				ts - TEST (sys99)
#		  -d date of file (mmdd)
# Author	: Christina M. Harris
# Date		: 03/09/99
# Modifications : 08/05/99 - Added input options (-c and -d) and associated logic  (LSJ)
#		: 08/12/99 - Added test for file before execution of program  (LSJ)
#               : 10/11/99 - Added separate .cob for aultman until they get to new format (CMH)
#		: 10/19/99 - Added print of PRINT-PY29-DEA and PRINT-PY29-PHO  (LSJ)
#		: 10/28/99 - Put back regular .cob program for aultman  (LSJ)
#		: 11/19/99 - Put in rm of PRINT-PY29-DEA and PRINT-PY29-PHO before start running physi29 program  (LSJ)
#		: 02/02/2000 - Summa now reads a .lin file
#		: 03/01/2000 - Added logic for Ultimed(um) file
#		: 03/30/2000 - New print file PRINT-PY29-GRP  (LSJ)
#		: 04/03/2000 - Code to not print PRINT-PY29-DEA for sys51 (LSJ)
#		: 04/10/2000 - Added rm of PRINT-PY29-GRP before starting  (LSJ)
#		: 04/11/2001 - Added zip_arch_elig.sh procedure  (LSJ)
#		: 05/16/2005 - Addition of "umask 002" command  (LSJ)
#		: 11/29/2005 - Changes for new system names  (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#		: 09/19/2008 - Added logic to not print PY29-DEA for sys0048  (LSJ)
#		: 10/20/2009 - New logic PDF files instead of printing  (LSJ)
#		: 06/03/2013 - removing zip_arch_elig.sh procedure (DME)
#		: 07/30/2013 - logic for "um" file
#		: 10/01/2013 - logic for "co" file
#		: 02/27/2014 - logic for "mr" file
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
CLIENT="null"
DATE="null"
PHYS_DIR="/usr/lnk/elig_in"
PHYS_OUT="/usr/lnk/elig_in_1"
PRT_DIR="/usr/lnk/po/misc"
SHELL="/usr/lnk/shell"
CONV_PDF="/usr/lnk/shell/conv_elig_rpts.sh"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: physi29.sh [-c au|ts|um] [-d <mmdd>] 

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

#
# Validate -c options
validate_client()
{  case ${CLIENT} in
     "ts" | "au" | "um" | "co" | "mr")
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
     case ${CLIENT} in
	"au")
	   PHYSI00TAP=${PHYS_DIR}/${CLIENT}p${DATE}.lin
	   SYS="0048"
	   ;;
	"um" | "co" | "mr")
	   PHYSI00TAP=${PHYS_DIR}/${CLIENT}p${DATE}.lin
	   SYS="0157"
	   ;;
	"ts")
	   PHYSI00TAP=${PHYS_DIR}/${CLIENT}p${DATE}
	   SYS="0099"
	   ;;
     esac
   fi
}

# Submit physi29 program
submit_physi29()
{
 if test -a ${PHYSI00TAP}
 then
   rm -f ${PRT_DIR}/PRINT-PY29-DEA-${SYS}
   rm -f ${PRT_DIR}/PRINT-PY29-PHO-${SYS}
   rm -f ${PRT_DIR}/PRINT-PY29-GRP-${SYS}
   case ${CLIENT} in
      "au"| "um" | "co" | "mr" | "ts")
           export PHYSI00TAP
           runcobol ${OBJ_DIR}/physi29
           ;;
   esac
 else
   echo
   echo "###################### ERROR MESSAGE #####################"
   echo "        ${PHYSI00TAP} DOESN'T EXIST"
   echo "          CHECK WITH BENEFITS DEPT. OR SUPERVISOR         "
   echo "##########################################################"
   exit 1
 fi
}

#
#Cleanup
cleanup()
{
   rm -f ${PHYS_DIR}/${CLIENT}p${DATE}
   mv ${PHYS_OUT}/${CLIENT}p${DATE} ${PHYS_OUT}/sys${SYS}
   case ${CLIENT} in
     "au" | "um" | "co" | "mr")
   	rm -f ${PHYS_DIR}/${CLIENT}p${DATE}.lin
	;;
   esac
   if test -s ${PRT_DIR}/PRINT-PY29-DEA-${SYS}
   then
	if [ ${SYS} -ne "0048" ]
	then
		${CONV_PDF} PRINT-PY29-DEA-${SYS} ${PRT_DIR}
	fi
   fi
   if test -s ${PRT_DIR}/PRINT-PY29-PHO-${SYS}
   then
	${CONV_PDF} PRINT-PY29-PHO-${SYS} ${PRT_DIR}
   fi
   if test -s ${PRT_DIR}/PRINT-PY29-GRP-${SYS}
   then
	${CONV_PDF} PRINT-PY29-GRP-${SYS} ${PRT_DIR}
   fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
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

umask 002

# Assign alternate environment variables

# Set Internal Variables
set_variables

echo "SYSTEM - ${SYS}"
echo ""
echo "Physician Update from Tape"
date
submit_physi29 
date

# Cleanup
echo ""
echo "-> Doing cleanup"
cleanup

exit 0
