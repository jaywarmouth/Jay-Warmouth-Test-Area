#!/bin/ksh
#
# Program Name  : ITITTRACMAS.sh
# Description   : run ITITTRACMAS 
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

usage: ITITTRACMAS.sh [-t] [-2|-3 -i -o]
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

echo "TITTRACMAS=${TITTRACMAS}"

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
TITTRACMAS=/usr/lnk/grp/TITTRACMAS
export TITTRACMAS


# this will be the pointer to the file which will be updated in any pass
TITTRACMASR=${TITTRACMAS}
export TITTRACMASR

HOLDDIR="./work"     #change to desired work directory in production

case "$PASS"
in
     1) TITTRACMASI=${TITTRACMAS}
        export TITTRACMASI
          # this will hold any locked records
        TITTRACMASH=${HOLDDIR}/TITTRACMASH
        export TITTRACMASH
        ;;
     2) TITTRACMASI=${HOLDDIR}/TITTRACMASH
        export TITTRACMASI
          # this will hold any locked records
        TITTRACMASH=${HOLDDIR}/TITTRACMASH2
        export TITTRACMASH
        ;;
     *) TITTRACMASI=${HOLDDIR}/$infile
        export TITTRACMASI
          # this will hold any locked records
        TITTRACMASH=${HOLDDIR}/$outfile
        export TITTRACMASH
        ;;
esac

echo "Initializing TITTRACMAS"  
echo "  pass="$PASS
echo "TITTRACMASI=${TITTRACMASI}"
echo "TITTRACMASR=${TITTRACMASR}"
echo "TITTRACMASH=${TITTRACMASH}"
date
echo press Return
read dummy

if [ $VERS = "prev" ]
then
    runcobol ${PREV_OBJ_DIR}/ITITTRACMAS
else
    runcobol ${OBJ_DIR}/ITITTRACMAS ${DEBUG} -a ${TEST_MODE}
fi

date
exit 0

