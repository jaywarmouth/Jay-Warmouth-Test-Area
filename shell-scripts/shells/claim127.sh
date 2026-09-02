#!/bin/ksh
#
# Program Name  : claim127.sh
# Description   : Zero Check# Update.                  
#                 -f Assign alternate CLAIM00MAS
# Author        : Debbie Wilson           
# Date          : 12/08/03
# Modifications	: 08/06/2018 - Add logic to check for non-existent ZERCHKMAS
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/misc
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim127.sh [-f <filename>] 

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


# Submit claim127 program
submit_claim127()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/claim127 -s 0000

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
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

# Assign alternate environment variables

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

echo "Zero Check Number Update"  
date
echo ""
echo "CLAIM00MAS=$CLAIM00MAS"
echo "CLAIM07KEY=$CLAIM07KEY"
echo ""
if test -s ${PRINT_DIR}/???CL07-C-ZEROCHK
then
	submit_claim127
else
	echo ""
	echo "FYI - There are no Zero Amount Check Claims that need updated"
	echo "For small or special check runs this would be an expected result."
	echo ""
fi

date

exit 0
