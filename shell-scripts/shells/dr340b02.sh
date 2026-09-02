#!/bin/ksh
#
# Program Name	: dr340b02.dr  
# Description   : UPDATE DR340B0MAS file to correct records that should have been termed.
#                 Input file is sort on GROUP(ascending) Pharmacy(ascending) NDC(ascending) and EFF-DATE(descending) 
#                 Command line arguments:
#           
# Author	: Dave Rudawsky
# Date		: 08/04/2014
# Modifications : 08/11/2014 - updates to run in production mode. (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dr340b02.dr 

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

# Submit dr340b02 program
submit_dr340b02( )
{
     runcobol ${OBJ_DIR}/dr340b02  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

DR340BLST=/usr/lnk/tmp/Q_DR340B_20140811.txt
   export DR340BLST

DR340BCSV=/usr/lnk/tmp/DR340BCSV.csv
   export DR340BCSV


echo "Update DR304B0MAS by terminating non-current records"
date
echo "EXPORT PATHS:"
echo "   DR340BLST=$DR340BLST"
echo "   DR340B0MAS=$DR340B0MAS"
echo "   DR340BCSV=$DR340BCSV"
submit_dr340b02
date

exit 0
