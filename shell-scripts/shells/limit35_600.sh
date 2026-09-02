#!/bin/ksh
#
# Program Name  : limit35-600.sh
# Description   : Medicare TA Balance Load   
#                 Command line arguments:
#                 -d date of file (mmdd)
# Author        : Debbie Wilson    
# Date          : 04/26/04
# Modification  : 05/03/2004 - Added Command line argument and elig directory logic  (LSJ) 
#		: 06/02/2004 - Fixed problem with SHELL not being assigned  (LSJ)
#		: 06/04/2004 - Changed to not using .lin input file  (LSJ)
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

usage: limit35_600.sh  

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

# Submit limit35_600 program
submit_limit35_600()
{
           runcobol ${OBJ_DIR}/limit35_600

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

LIMTA00MAS=/usr/lnk/elig_in/sul1228-600
export LIMTA00MAS

AUDIT20MAS=/usr/lnk/audit/LIMAUD
export AUDIT20MAS

echo "Load Medicare TA Balance to Limit00mas"
date
submit_limit35_600
date

# Print procedure

# Cleanup

# Zip Archive Files

exit 0
