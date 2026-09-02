#!/bin/ksh
#
# Program Name  : rever01.sh
# Description   : Post Reversal "1" to claims                   
#                 Command Line Arguments
#		  -a <userclass> <username>
#                 -f <filename>
# Author        : Debbie Wilson             
# Date          : 12/12/02
# Modifications : 03/10/2006 - Changes for limitcms01 procedure  (LSJ)
#               : 11/01/2012 - Add File run switch 
#		: 04/1/2015 - TT #8641-5
#		: 04/03/2017 - RR16858-6; RV60100MAS addition
#		: 07/19/2017 - TT10861-9; RETVAL logic 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
USERCLASS=""
DEMO=0
FILE_RUN=0
FILE="null"
DATE=`date +%Y%m%d`
AUDIT_DIR=/usr/lnk/audit
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rever01.sh  -f <filename> -a ["userclass&username"]

ENDOFUSAGE
  exit 99
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


# Submit rever01 program
submit_rever01()
{
runcobol ${OBJ_DIR}/rever01 -s ${FILE_RUN} -a ${USERCLASS}${USER}'           ' 
RETVAL=$?
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
	FILE=$1
	FILE_RUN=1
        ;;
    -a) shift
        if [ $# -le 0 ]
        then
           usage
        fi
        USERCLASS=$1
        USER=$2
        ;;
   esac
   shift
done 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $FILE_RUN = 1 ]
then
	if test -s ${FILE}
	then
		REVBATCH=$FILE
		export REVBATCH
	else
		echo "-*> The $FILE does not exist or does not have any records"
		exit 99
	fi
fi
AUDIT20MAS=${AUDIT_DIR}/CLAIM02
export AUDIT20MAS
RV60100MAS=${AUDIT_DIR}/RV601-MAN-${DATE}
export RV60100MAS

echo "Post 1 to claims for reversal"
date
submit_rever01         
echo ""
date

echo "RETVAL=$RETVAL"
exit $RETVAL
