#!/bin/sh
#
# Program Name	:limitpc01.sh
# Description   : Replaces flexgen program LIMITPC023 uses parameter input file.
#                 Command line arguments:
#                 -i <PARMFILE input file>
#                 -o <LIMITPC01CSV output file>
# Author	: Lucy A. Caraballo
# Date		: 09/26/2016
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_NAME="null"
RETVAL=0
INFILE_FLAG=0
OUTFILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limitpc01.sh [-i <PARMFILE input file>] [-o <LIMITPC01CSV filename>] 

ENDOFUSAGE
  exit 99
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

	
submit_limitpc01()
{
      runcobol ${OBJ_DIR}/limitpc01 
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
        INFILE_FLAG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLAG=1
        OUTFILE=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env


# Assign alternate environment variables
if [ $INFILE_FLAG = 1 ]
then
        PARMFILE=$INFILE
else
        PARMFILE=/usr/lnk/wt/oper-wt/misc/LIMITPC01-PARMFILE.txt
fi
export PARMFILE

if [ $OUTFILE_FLAG = 1 ]
then
       LIMITPC01CSV=$OUTFILE
else
       LIMITPC01CSV=/usr/lnk/wt/oper-wt/misc/GAPReport-${DATETM}.txt
fi
export LIMITPC01CSV

   echo "COBOL EXTRACT THAT REPLACES FLEXGEN LIMITPC023"                   
   date
   echo "EXPORT PATHS:"
   echo "   LIMIT00MAS=$LIMIT00MAS"
   echo "   CARDH00MAS=$CARDH00MAS"
   echo "   GROUP00MAS=$GROUP00MAS"
   echo "   PLAN000MAS=$PLAN000MAS"
   echo "   LIMITPC01CSV=$LIMITPC01CSV"
   echo "   PARMFILE=$PARMFILE"

   submit_limitpc01   
   date

exit $RETVAL
