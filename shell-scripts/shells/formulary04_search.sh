#!/bin/ksh
#
# Program Name  : formulary04_search.sh
# Description   : Medicare part D Formulary Search File Program (Monthly)
#               : AND             Formulary "FF" File Creation Program (Monthly)
#                 Command line arguments:
#                 -f switch for indicating to run HPMS file
#                   (otherwise "CMS FF" file will be created)
#                 -v Version # <5 char> <for cms FF file only>
#                 -d Effective date <CCYYMMDD> <for cms FF file only>
#                 -s Assign Alternate: special DRUGWRKMAS.speccms
# Author        : Mike Paulus     
#             
# Date          : 02/18/09
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HPMS=0
VERSION=0
EFF_DATE=0
SPEC_FILE=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: formulary04_search.sh -f [-v <version#>] [-d <ccyymmdd>]

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


# Submit formulary04_search program
submit_formulary04_search()
{
   if [ ${HPMS} = 1 ]                
     then
        runcobol ${OBJ_DIR}/formulary04_search -s 1 
     else
        runcobol ${OBJ_DIR}/formulary04_search -s 0 -a ${VERSION}${EFF_DATE} 
     fi

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) HPMS=1
        ;;
    -v) shift
        if [ $# -le 0 ]
        then
          usage
        else
          VERSION=$1
        fi
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        else
          EFF_DATE=$1
        fi
        ;;
    -s) SPEC_FILE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${SPEC_FILE} = 1 ]
then
   DRUGWRKMAS=/usr/lnk/wrk/2010_medd/DRUGWRKMAS.speccms.2010
   export DRUGWRKMAS
else
   DRUGWRKMAS=/usr/lnk/wrk/2010_medd/DRUGWRKMAS.cms.2010
   export DRUGWRKMAS
   GENER00MAS=/usr/lnk/wrk/2010_medd/GENER00MAS.medd.2010
   export GENER00MAS
fi

echo ${HPMS}
date
echo "   DRUGWRKMAS=$DRUGWRKMAS"
echo "   GENER00MAS=$GENER00MAS"
echo "   FORM300TAP=$FORM300TAP"
echo "   FORM400TAP=$FORM400TAP"
submit_formulary04_search
date

exit 0
