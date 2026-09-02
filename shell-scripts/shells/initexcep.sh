#!/bin/sh
# To run: initexcep.da -t     
#
# Program Name	:initexcep.da
# Description   : Update EXCEP00MAS RECORDS BASED ON A PARAMETER FILE.        
#                 Command line arguments
#                 -t Test mode
#		  -i <alt. input EXCEPPRM> - default is:
#			/usr/lnk/tmp/EXCEPPRM.txt
# Author	: Debbe A. Adgate   
# Date		: 3/7/2016 
# Modifications :  
#		: 
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
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: initexcep.da -t -i <EXCEPPRM file>
	both command line arguments are optional

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

	
# Submit verifyfl program
submit_initexcep()
{
      runcobol ${OBJ_DIR}/initexcep -s ${TEST_MODE} 
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
	INFILE=$1
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
	EXCEPPRM=$INFILE
else
	EXCEPPRM=/usr/lnk/tmp/EXCEPPRM.txt
fi
export EXCEPPRM

EXCEPCHG=/usr/lnk/tmp/EXCEPCHG.csv
export EXCEPCHG
AUDIT20MAS=$FG4AUD
export AUDIT20MAS 

   echo "Update EXCEP00MAS records"                   
   date
   echo "EXPORT PATHS:"
   echo "   CARDH00MAS=$CARDH00MAS"
   echo "   EXCPE00MAS=$EXCEP00MAS"
   echo "   EXCEPPRM=$EXCEPPRM"
   echo "   EXCEPCHG=$EXCEPCHG"
   echo "   AUDIT20MAS=$AUDIT20MAS"
   submit_initexcep   

   date

exit $RETVAL
