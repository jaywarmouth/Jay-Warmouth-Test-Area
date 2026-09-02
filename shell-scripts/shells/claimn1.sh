#!/bin/ksh
#
# Program Name  : claimn1.sh
# Description   : Load Manual N1 Claims And PDE Records    
# Command Line Arguements:
#                 -c User class <A,B,C,D>
#                 -u Username
#                 -t test mode
#                 -f <input batch file name>            
# Author        : Mike Paulus
# Date          : 10/20/06
# Modifications : 09/12/2011 - add swith for a file run                
#		  09/29/2011 - Add input file name to -f option
#		  03/08/2017 - TT16858-6; RV60100MAS logic.
#		: 03/12/2019 - TT18987-77; CYCLERRS assignment.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER="null"
USERCLASS="null"
TEST_MODE=0
FILE_RUN=0
FILE="null"
DATETM=`date +%Y%m%d%H%M$S`
DATE=`date +%Y%m%d`
AUDIT_DIR=/usr/lnk/audit

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claimn1.sh [-t test_mode] [-b] [-f <filename>][-c <userclass>] [-u "username"]
	-b (optional)
	<filename> Alternate N1BATCHIN filename  (optional)
	<userclass> - A|B|C|D

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

#
# Validate -c options
validate_userclass()
{  case ${USERCLASS} in
     "A" | "B" | "C" | "D" )
                          ;;
     *)  usage
         ;;
   esac
}


# Submit claimn1 program
submit_claimn1()
{
        runcobol ${OBJ_DIR}/claimn1 -s ${TEST_MODE}${FILE_RUN} -a ${USERCLASS}${USER}'            '

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -u) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USER=$1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USERCLASS=$1
	validate_userclass
        ;;
    -t) TEST_MODE=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_RUN=1
	FILE=$1
        ;;

  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${TEST_MODE} = 1 ]
then
   CLWRK00MAS=/usr/lnk/wrk/CLWRK00MAS.mp   
     export CLWRK00MAS

   PDECL00WRK=/usr/lnk/wrk/PDECL00WRK.mp   
     export PDECL00WRK

   LIMIT00MAS=/usr/lnk/wrk/LIMITN1WRK.mp
   export LIMIT00MAS
fi

if [ ${USERCLASS} = "null" ]
then
	usage
fi
if [ ${USER} = "null" ]
then
	usage
fi

if [ $FILE_RUN = 1 ]
then
	N1BATCHIN=$FILE
	export N1BATCHIN
fi

N1BATCHERROR=/usr/lnk/tmp/N1BATCHERROR-${DATETM}  
export N1BATCHERROR

AUDIT20MAS=${AUDIT_DIR}/CLAIM02
   export AUDIT20MAS
RV60100MAS=${AUDIT_DIR}/RV601-MAN-${DATE}
export RV60100MAS

CYCLERRS=/usr/lnk/audit/CYCLERRS_traffic_MAN.csv; export CYCLERRS

date

echo ""
echo "EXPORT FILES:"
echo "  N1BATCHIN=$N1BATCHIN"
echo "  N1BATCHERROR=$N1BATCHERROR"
echo "	AUDIT20MAS=$AUDIT20MAS"
echo "	RV60100MAS=$RV60100MAS"
echo ""
submit_claimn1
date

exit 0
