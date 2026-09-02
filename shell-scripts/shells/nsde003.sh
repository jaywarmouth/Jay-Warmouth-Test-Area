#!/bin/sh
#
# Program Name	: nsde003.dr
# Description   : Compare work nsde to master NSDE and update master NSDE file
#                 Command line arguments
#                 -i <filename> - assign alternate NSDE000WRK file

#                 Switches:
#                 -t Test mode (no NSDE or Audit file rewrites)

# Author	: Dave Rudawsky 
# Date		: 02/10/2015
# Modifications : 03/05/2015 - Updates for production version (TT #12829-39) 
#		: 04/28/2015 - Fix NSDE003CSV assigned name
#		: 05/04/2015 - another fix to NSDE003CSV assigned name
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILEDIR=/usr/lnk/tmp
FILE_FLAG=0
TEST_MODE=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nsde003.sh [-i <filename>] [-t]
	-i <filename> is optional to provide input filename

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

	
# Submit nsde003 program
submit_nsde003()
{
      runcobol ${OBJ_DIR}/nsde003 -s ${TEST_MODE}  
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
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

if [ $FILE_FLAG = 1 ]
then
	NSDE000WRK=$FILE
fi
   export NSDE000WRK

NSDE000WRK=/usr/upd/drug/NSDE000WRK-${DATE}
   export NSDE000WRK
NSDE003CSV=/usr/lnk/misc/NSDE003RPT-${DATE}.csv
   export NSDE003CSV

   echo "Update NSDE file"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   NSDE000WRK=$NSDE000WRK"
   echo "   NSDE000MAS=$NSDE000MAS"
   echo "   NSDE003CSV=$NSDE003CSV"
   
   submit_nsde003
   date

exit 0
