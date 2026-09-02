#!/bin/sh
#
# Program Name	: excepup003 
# Description   : Update EXCEP Master File based on user input parameters
#                 Command line arguments
#                 Switches:
#                   -t Test mode (no EXCEP00MAS file rewrites)
# Author	: Greg Vernon
# Date		: 3/30/2020
# Modifications :  
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
# FILEDIR=/usr/lnk/tmp
FILE_FLAG=0


TEST="N"
REPORT="Y"
BIN=00002170
OLDOCCR=0001
NEWOCCR=0003
TYPEDATE="A"
DATEOPER="LE"
USEDATE=20200331



#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: excepup003.sh [-t]

ENDOFUSAGE
  exit 1
}


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
# Main routine
#
#Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

  FG4AUD=/usr/lnk/wrk/FG4AUD-EXCEP
  export FG4AUD
         

  #EXCEP00MAS=/usr/devl/users/gvernon/WORK/EXCEP00MAS-TEST
  #export EXCEP00MAS


  EXCEP00CSV=/usr/lnk/tmp/EXCEP00CSV-2170.csv
  export EXCEP00CSV


   echo "UPDATE EXCEP00MAS FILE BASED ON LINKAGE DATA"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   EXCEP00MAS=$EXCEP00MAS"
   echo "   EXCEP00CSV=$EXCEP00CSV" 

#   submit_excepup003
     runcobol ${OBJ_DIR}/excepup003 -a ${TEST}${REPORT}${BIN}${OLDOCCR}${NEWOCCR}${TYPEDATE}${DATEOPER}${USEDATE}
	RETVAL=$?

   date
echo "RETVAL=$RETVAL"

exit $RETVAL
