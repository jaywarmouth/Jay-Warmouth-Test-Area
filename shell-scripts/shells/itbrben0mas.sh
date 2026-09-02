#!/bin/ksh
#
# Program Name  : ITBRBEN0MAS.sh
# Description   : run ITBRBEN0MAS 
# Author        : Bill Swidal
# Date          : 06/21/2022
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PREV_OBJ_DIR=/usr/lnk/obj
OBJ_DIR=/usr/lnk/tst/wswidal

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ITBRBEN0MAS.sh [-t] [-2|-3 -i -o]
    -t: test mode, display progress through the file
    {no -2 or -3}: first pass through the file, reads the normal file. writes locked records to the Hold file
    -2: 2nd pass, reads the Hold file, writes any still locked records to a Hold 2 file
    -3: 3rd pass, like 2 but requires an input (-i) and an output (-o) file to be specified

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
# Main routine
#

# Parse environment variables
parse_env

#echo "TBRBEN0MAS=${TBRBEN0MAS}"

# Check command line validity, call usage if incorrect
TEST_MODE="N"
PASS="1"
DEBUG=" "
VERS="curr"

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE="Y"
        ;;
    -2) PASS="2"
        ;;    
    -3) PASS="3"
        ;;    
    -i) shift
        infile=$1
        ;;
    -o) shift
        outfile=$1
        ;;
    -D) DEBUG="D"
        ;;
    -P) VERS="prev"
        ;;
     *) usage
        ;;
  esac
  shift
done

# Assign alternate environment variables

# COMMENT THIS OUT ONCE THE FILENAME IS INSERTED INTO ENV_VAR
TBRBEN0MAS=/usr/lnk/grp/TBRBEN0MAS
export TBRBEN0MAS

# this will be the pointer to the file which will be updated in any pass
TBRBEN0MASR=${TBRBEN0MAS}
export TBRBEN0MASR

HOLDDIR="./work"     #change to desired work directory in production

case "$PASS"
in
     1) TBRBEN0MASI=${TBRBEN0MAS}
        export TBRBEN0MASI
          # this will hold any locked records
        TBRBEN0MASH=${HOLDDIR}/TBRBEN0MASH
        export TBRBEN0MASH
        ;;
     2) TBRBEN0MASI=${HOLDDIR}/TBRBEN0MASH
        export TBRBEN0MASI
          # this will hold any locked records
        TBRBEN0MASH=${HOLDDIR}/TBRBEN0MASH2
        export TBRBEN0MASH
        ;;
     *) TBRBEN0MASI=${HOLDDIR}/$infile
        export TBRBEN0MASI
          # this will hold any locked records
        TBRBEN0MASH=${HOLDDIR}/$outfile
        export TBRBEN0MASH7
        ;;
esac

echo "Initializing TTBRBEN0MAS"  
echo "  pass="$PASS
echo "TBRBEN0MASI=${TBRBEN0MASI}"
echo "TBRBEN0MASR=${TBRBEN0MASR}"
echo "TBRBEN0MASH=${TBRBEN0MASH}"
date
echo press Return
read dummy

if [ $VERS = "prev" ]
then
    runcobol ${PREV_OBJ_DIR}/ITBRBEN0MAS
else
    runcobol ${OBJ_DIR}/ITBRBEN0MAS ${DEBUG} -a ${TEST_MODE}
fi

date
exit 0

