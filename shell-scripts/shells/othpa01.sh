#!/bin/ksh
#
# Program Name	: othpa01.sh
# Description   : Other Payor File Update procedure
#                 Command line arguments:
#                 -c Client Abbrev. 
#                 -d date of file (mmdd)
# Author	: Linda Jefferis
# Date		: 01/12/2006
# Modifications : 07/14/2006 - Changes for switch to .lin input file.
#		: 10/11/2006 - Added -e option to zip_elig_arch.sh  (LSJ)
#		: 10/19/2006 - Changes for 4-digit system number  (LSJ)
#		: 10/20/2009 - Logic changes for creating PDF of reports
#               : 06/03/2013 - Removed zip_arch_elig.sh procedure (DME)
#		: 12/15/2014 - TT #12196-5; add "am" logic
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT="/usr/lnk/elig_in_1"
PRT_DIR="/usr/lnk/misc"
AUDIT_DIR="/usr/lnk/audit"
DATE="null"
CLIENT="null"
SYS=0000
SHELL="/usr/lnk/shell"
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp/Benefits/Elig"
CONV_PDF="/usr/lnk/shell/conv_elig_rpts.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: othpa01.sh [-c am] [-d <mmdd>]
]

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
     "am")
         ;;
     *)  usage
         ;;
   esac
}

#
# Set variables
set_variables()
{
	OTHPA01TAP=${ELIG_DIR}/${CLIENT}o${DATE}.lin
	export OTHPA01TAP
	case ${CLIENT} in
	   "am")
		SYS=0048
		;;
	    *)	usage
		;;
	esac
}

#
# Print report
print_rpt()
{
	if test -s ${PRT_DIR}/PRINT-OP-${SYS}
	then
		#lp ${PRT_DIR}/PRINT-OP-${SYS}
		${CONV_PDF} PRINT-OP-${SYS} ${PRT_DIR}
	fi
}

#
# Cleanup
cleanup()
{
	rm -f ${ELIG_DIR}/${CLIENT}o${DATE}
	rm -f ${OTHPA01TAP}
	mv ${ELIG_OUT}/${CLIENT}o${DATE} ${ELIG_OUT}/sys${SYS}
}

# Submit othpa01 program
submit_othpa01()
{

	if test -a ${OTHPA01TAP}
	then
		rm -f ${PRT_DIR}/PRINT-OP-${SYS}
    		runcobol ${OBJ_DIR}/othpa01 -a ${CLIENT}o${DATE}${SYS}
	else
		echo
		echo "################### ERROR MESSAGE ###################"
		echo "      ${OTHPA01TAP} DOES NOT EXIST"
		echo "   CHECK WITH BENEFITS or SUPERVISOR"
		echo "#####################################################"
		exit 1
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

umask 000

# Assign other variables

FG4AUD=${AUDIT_DIR}/CRDAUD
  export FG4AUD

# Set Internal Variables
set_variables

echo "SYSTEM - ${SYS}"
echo ""
echo "Other Payor File Update -- othpa01"
date
submit_othpa01 
date

# Print procedure
echo ""
echo "--> Printing Report..."
print_rpt

# Cleanup
echo ""
echo "--> Doing Cleanup..."
cleanup

exit 0
