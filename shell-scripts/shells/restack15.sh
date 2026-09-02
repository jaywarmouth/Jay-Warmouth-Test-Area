#!/bin/sh
#
# Program Name	: restack15.sh
# Description   : Update records on the RESTACK file
#                 Command line arguments
#                 -i <filename> - assign alternate input file

# Author	: Dave Rudawsky 
# Date		: 11/24/2014
# Modifications : 11/26/2014 - changes for production (LSJ)
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILEDIR=/usr/lnk/wt/oper-wt/restack
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack15.sh [-i <filename>]
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

	
# Submit restack15 program
submit_restack15()
{
      runcobol ${OBJ_DIR}/restack15  
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
  esac
  shift
done


# Parse environment variables
parse_env

RSTKCARDH=$FILEDIR/Input/RSTKCARDH
if [ $FILE_FLAG = 1 ]
then
	RSTKCARDH=$FILE
fi
export RSTKCARDH

RESTK15CSV=$FILEDIR/Output/RESTK15.csv
export RESTK15CSV

   echo "Update RESTACK MASTER from input file"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=$FG4AUD"
   echo "   RESTK00MAS=$RESTK00MAS"
   echo "   RSTKCARDH=$RSTKCARDH"
   echo "   RESTK15CSV=$RESTK15CSV"
   
   submit_restack15
   date

exit 0
