#!/bin/ksh
#
# Program Name  : drug041.sh
# Description   : Tape Update From MDDB to DRUG000MAS.
# Author        : James Masluk
# Date          : 05/30/02
# Modifications : 04/28/2006 - Added program name display and fixed error display so it outputs correctly to the rpt.  (LSJ)
#		: 08/22/2006 - Added HOSTNAME logic  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug041.sh  

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


# Submit drug041 program
submit_drug041()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drug041 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Update of MediSpan MDDBERR file - drug041"
echo "HOSTNAME=$HOSTNAME"
date

if test -s ${MDDBERR}
then
	submit_drug041
else
	echo "-*> ${MDDBERR} does not exist or is zero"
fi
date

exit 0
