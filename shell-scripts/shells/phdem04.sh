#!/bin/sh
#
# Program Name	: phdem04.sh
# Description   : Update Pharm Dem. Replaces FlexGen process PHDEMUP062
#                 Command line arguments
#                 -i <filename> - assign alternate input file
#
#                 Switches:
#                 -t Test mode (no PHDEM00MAS file rewrites)
#
# Author	: Lucy A. Caraballo 
# Date		: 01/29/2015
# Modifications : 02/26/2015 - Prepare Script to run in JAMS. (TT:12468-3)(DME) 
#		: 04/20/2015 - update script to include file move and use new file created (DME)
#		: 05/04/2015 - added coding to do a file permissions change for copied Null file. (DME)
#		
#

#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_DIR="/usr/lnk/tmp"
WRK_DIR="/usr/lnk/wrk"
MAIL_PROG=/usr/bin/mutt
MAIL_PROG=pharmacypayables@pdmi.com
FILE_FLAG=0
TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phdem04.sh [-i <filename>] [-t]
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

#
# Move sepcheck file to backup 
sepchck_move()
{
cp ${FILE_DIR}/phdem-sep-chck-ind ${FILE_DIR}/phdem-sep-chck-ind2             
rm ${FILE_DIR}/phdem-sep-chck-ind            
cp ${FILE_DIR}/phdem-sep-chck-ind.null ${FILE_DIR}/phdem-sep-chck-ind                                       
chmod 664 ${FILE_DIR}/phdem-sep-chck-ind                                       
chgrp pdm ${FILE_DIR}/phdem-sep-chck-ind                                       
}	

#
# Submit phdem04 program
submit_phdem04()
{
      runcobol ${OBJ_DIR}/phdem04 -s ${TEST_MODE} 
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
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done



parse_env

if [ $FILE_FLAG = 1 ]
then
	PHDEM00WRK=${FILE}
else
	sepchck_move
	PHDEM00WRK=${FILE_DIR}/phdem-sep-chck-ind2
fi

export PHDEM00WRK

PHDEM00MAS=/usr/lnk/pharm/PHDEM00MAS
export PHDEM00MAS
         
        
FG4AUD=${WRK_DIR}/FG4AUD
PHDEM04CSV=${WRK_DIR}/PHDEM04CSV
   export PHDEM04CSV


   echo "Update FIELDS ON PHDEM MASTER file"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   PHDEM00MAS=$PHDEM00MAS"
   echo "   PHDEM00WRK=$PHDEM00WRK"
   echo "   PHDEM04CSV=$PHDEM04CSV" 
   submit_phdem04
   date

if test -s $PHDEM04CSV
then
   echo "Error file for PHDEM update is attached." | ${MAIL_PROG} -s "PHDEM update - Error File" ${MAIL_TO} -a $PHDEM04CSV
fi

exit ${RETVAL}
