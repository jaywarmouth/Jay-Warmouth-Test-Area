#!/bin/ksh
#
# Program Name	: limit29.sh
# Description   : LIMIT FILE COPAY AMOUNT UPDATE
#                 Command line arguments:
#                 -c Client Abbrev. 
#                 -d date of file (mmdd or mmdd.###)
# Author	: James Masluk
# Date		: 05/17/2002
# Modifications : 06/24/2002 - Added some procedures and made some other variable changes  (LSJ)
#		: 06/27/2002 - Had to change name of print procedure from "print" to print_rpt"  (LSJ)
#		: 07/02/2002 - Changes for non-interactive run of program (LSJ)
#		: 05/16/2005 - Addition of "umask 002" command  (LSJ)
#		: 10/19/2006 - Changes for 4-digit system number  (LSJ)
#		: 09/11/2007 - Added logic for "hw" file and removed validate_client logic  (LSJ)
#		: 12/27/2007 - Changed "hw" to "iw"  (LSJ)
#		: 10/20/2009 - CONV_PDF logic added  (LSJ)
#               : 06/03/2013 - Removed zip_arch_elig.sh procedure (DME)
#		: 11/14/2016 - TT15567-7; add "aq"  (LSJ)
#		: 04/12/2017 - Updated SYS for "aq" to 0161  (LSJ)
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
CONV_PDF="/usr/lnk/shell/conv_elig_rpts.sh"
WT_ARCH="/usr/lnk/wt/pdm/accumfiles"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit29.sh [-c <2-char client abbrev.>] [-d <mmdd>]
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
# Set variables
set_variables()
{
	case ${CLIENT} in
	   "au")
		SYS=0048
		;;
	   "aq")
		SYS=0161
		;;
	   "iw")
		SYS=0068
		;;
	    *)	usage
		;;
	esac
}

#
# Print report
print_rpt()
{
	if test -s ${PRT_DIR}/LIMIT-29-${SYS}
	then
		#lp ${PRT_DIR}/LIMIT-29-${SYS}
		${CONV_PDF} LIMIT-29-${SYS} ${PRT_DIR}
	fi
}

#
# Cleanup
cleanup()
{
	rm -f ${ELIG_DIR}/${CLIENT}l${DATE}
	cp ${ELIG_DIR}/${CLIENT}l${DATE}.lin ${WT_ARCH}/${CLIENT}l${DATE}.txt
	mv ${ELIG_DIR}/${CLIENT}l${DATE}.lin ${ELIG_OUT}/sys${SYS}
	mv ${ELIG_OUT}/${CLIENT}l${DATE} ${ELIG_OUT}/sys${SYS}
}

# Submit limit29 program
submit_limit29()
{

	if test -a ${LIMIT29TAP}
	then
		rm -f ${PRT_DIR}/LIMIT-29-${SYS}
    		runcobol ${OBJ_DIR}/limit29 -a ${CLIENT}l${DATE2}${SYS}
	else
		echo
		echo "################### ERROR MESSAGE ###################"
		echo "      ${LIMIT29TAP} DOES NOT EXIST"
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
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
	DATE2=`echo $DATE | cut -c1-4`
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

umask 002

# Assign other variables

LIMIT29TAP=${ELIG_DIR}/${CLIENT}l${DATE}.lin
  export LIMIT29TAP

FG4AUD=${AUDIT_DIR}/LIMAUD
  export FG4AUD

# Set Internal Variables
set_variables

echo "CLIENTID - ${CLIENT}"
echo "SYSTEM - ${SYS}"
echo ""
echo "Limit Update from File -- limit29"
date
echo "DATE2=$DATE2"
submit_limit29 
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
