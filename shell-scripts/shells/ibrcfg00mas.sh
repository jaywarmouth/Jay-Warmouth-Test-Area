#!/bin/sh
#
# Program Name  : ibrcfg00ms.sh
# Description   : run IBRCFG00MAS 
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
OBJ_DIR=/usr/lnk/obj
TEST_MODE="N"
PASS="1"
DEBUG=" "

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: IBRCFG00MAS.sh [-t] [-2|-3 -i -o]
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

# Check command line validity, call usage if incorrect

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
     *) usage
        ;;
  esac
  shift
done

# Assign alternate environment variables

# this will be the pointer to the file which will be updated in any pass
BRCFG00MASR=${BRCFG00MAS}
export BRCFG00MASR

HOLDDIR="/tmp"     #change to desired work directory in production

case "$PASS"
in
     1) BRCFG00MASI=${BRCFG00MAS}
        export BRCFG00MASI
          # this will hold any locked records
        BRCFG00MASH=${HOLDDIR}/BRCFG00MASH
        export BRCFG00MASH
        ;;
     2) BRCFG00MASI=${HOLDDIR}/BRCFG00MASH
        export BRCFG00MASI
          # this will hold any locked records
        BRCFG00MASH=${HOLDDIR}/BRCFG00MASH2
        export BRCFG00MASH
        ;;
     *) BRCFG00MASI=${HOLDDIR}/$infile
        export BRCFG00MASI
          # this will hold any locked records
        BRCFG00MASH=${HOLDDIR}/$outfile
        export BRCFG00MASH
        ;;
esac

echo "Initializing BRCFG00MAS"  
echo "  pass="$PASS
echo "BRCFG00MASI=${BRCFG00MASI}"
echo "BRCFG00MASR=${BRCFG00MASR}"
echo "BRCFG00MASH=${BRCFG00MASH}"
date
#echo press Return
#read dummy

runcobol ${OBJ_DIR}/IBRCFG00MAS ${DEBUG} -a ${TEST_MODE}
RETVAL=$?


date
exit $RETVAL
