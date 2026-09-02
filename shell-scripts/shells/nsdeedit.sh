#!/bin/sh
#
# Program Name	: nsdeedit.sh
# Description   : Parse the NSDE file from CMS to create a fixed-format, indexed NSDE file.
#                 Command line arguments
#                 -i <filename> - assign alternate input file

# Author	: Dave Rudawsky 
# Date		: 10/16/2014
# Modifications : 10/31/2014 - Changes for deployment to production (LSJ)
#		: 02/13/2015 - Create NSDE000WRK file instead of entire NEW file (TT #12829-39)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
DATE=`date +%Y%m%d`
NSDE000WRK=/usr/upd/drug/NSDE000WRK-${DATE}

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nsdeedit.sh [-i <filename>]
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

	
# Submit nsdeedit program
submit_nsdeedit()
{
      runcobol ${OBJ_DIR}/nsdeedit  
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

if [ $FILE_FLAG = 1 ]
then
	CMSNSDE=$FILE
else
	CMSNSDE=/usr/lnk/wt/oper-wt/MEDD/CMSNSDE.csv
fi
export CMSNSDE

NSDEEDITCSV=/usr/lnk/misc/NSDEEDITRPT-${DATE}.csv
export NSDEEDITCSV
NSDE000MAS=$NSDE000WRK
export NSDE000MAS

   echo "Parse NSDE file"
   date
   echo "EXPORT PATHS:"
   echo "   CMSNSDE=$CMSNSDE"
   echo "   DRUG000MAS=$DRUG000MAS"
   echo "   NSDE000MAS=$NSDE000MAS"
   echo "   NSDEEDITCSV=$NSDEEDITCSV"
   
   submit_nsdeedit
   date

exit 0
