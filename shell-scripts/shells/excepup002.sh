#!/bin/sh
#
# Program Name	: excepup002 
# Description   : Update EXCEP Master File based on user input parameters
#                 Command line arguments
#		    -i <Parm filename>
#		    -o <EXCEP00CSV filename>
#                 Switches:
#                   -t Test mode (no EXCEP00MAS file rewrites)
# Author	: Dave Rudawsky
# Date		: 6/17/2016
# Modifications :  
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
OUTFILE_FLG=0
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: excepup002.sh [-t] -i <parm file> -o <output csv>

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

	
# Submit excepup002 program
submit_excepup002()
{
      runcobol ${OBJ_DIR}/excepup002 -s ${TEST_MODE} 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env

FG4AUD=$FG4AUD
  export FG4AUD
         
if [ ${FILE_FLAG} = 1 ]
then
        PARMFILE=${FILE}
else
        PARMFILE=/usr/lnk/tmp/EXCEPUP002-PARMFILE.txt
fi
export PARMFILE

if [ ${OUTFILE_FLG} = 1 ]
then
        EXCEP00CSV=${OUTFILE}
else
        EXCEP00CSV=/usr/lnk/wt/oper-wt/EXCEP02CSV.txt
fi
export EXCEP00CSV

   echo "UPDATE EXCEP00MAS FILE BASED ON INPUT PARAMETERS"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   EXCEP00MAS=$EXCEP00MAS"
   echo "   PARMFILE=$PARMFILE"
   echo "   EXCEP00CSV=$EXCEP00CSV" 
   submit_excepup002
   date

exit $RETVAL
