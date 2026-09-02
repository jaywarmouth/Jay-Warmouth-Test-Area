#!/bin/ksh
#
# Program Name  : limit35.sh
# Description   : Medicare TA Balance Load   
#                 Command line arguments:
#                 -d date of file (mmdd)
# Author        : Debbie Wilson    
# Date          : 04/26/04
# Modification  : 05/03/2004 - Added Command line argument and elig directory logic  (LSJ) 
#		: 06/02/2004 - Fixed problem with SHELL not being assigned  (LSJ)
#		: 06/04/2004 - Changed to not using .lin input file  (LSJ)
#		: 07/20/2005 - Addition of "umask 002" command  (LSJ)
#               : 06/03/2013 - Removed zip_arch_elig.sh procedure (DME)
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT="/usr/lnk/elig_in_1"
PRT_DIR="/usr/lnk/misc"
AUDIT_DIR="/usr/lnk/audit"
DATE="null"
SYS=35
CLIENT="su"
SHELL="/usr/lnk/shell"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit35.sh  

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

#
# Print report
print_rpt()
{
        if test -s ${PRT_DIR}/LIMIT35
        then
                lp ${PRT_DIR}/LIMIT35
        fi
}

#
# Cleanup
cleanup()
{
	rm -f ${ELIG_DIR}/${CLIENT}l${DATE}
	mv ${ELIG_OUT}/${CLIENT}l${DATE} ${ELIG_OUT}/sys0${SYS}
}

# Submit limit35 program
submit_limit35()
{
	if test -a ${LIMTA00MAS}
	then
	   rm -f ${PRT_DIR}/LIMIT35
           runcobol ${OBJ_DIR}/limit35 
	else
	   echo
                echo "################### ERROR MESSAGE ###################"
                echo "      ${LIMTA00MAS} DOES NOT EXIST"
                echo "   CHECK WITH BENEFITS or SUPERVISOR"
                echo "#####################################################"
                exit 1
        fi

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
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

# Assign alternate environment variables

LIMTA00MAS=${ELIG_DIR}/${CLIENT}l${DATE}
export LIMTA00MAS

AUDIT20MAS=${AUDIT_DIR}/LIMAUD
export AUDIT20MAS

echo "SYSTEM - ${SYS}"
echo ""
echo "Load Medicare TA Balance to Limit00mas"
date
submit_limit35
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
