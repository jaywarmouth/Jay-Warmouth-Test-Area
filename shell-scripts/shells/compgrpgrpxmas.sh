#!/bin/sh
#
# to run: compgrpgrpxmas.pm [-D]
#
# Program Name  : compgrpgrpxmas.pm
# Author        : kosalai k   
# Date          : 05/19/2026
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
OBJ_DIR=/usr/lnk/obj
DATETM=`date +%Y%m%d-%H%M%S`
DEBUG=" "

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


# Submit compgrpgrpxmas program
submit_compgrpgrpxmas()
{
     runcobol ${OBJ_DIR}/COMPGRPGRPXMAS   
 RETVAL=$?
        echo "Return Code = $RETVAL"

}


#
# Main routine
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -D) DEBUG="D"
        ;;
  esac
  shift
done

#

#LOADTIMES=/usr/lnk/tmp/loadtimesda
#  export LOADTIMES
#
# OLD GRPGRPXMAS file
GRPGRPXMASO=/usr/lnk/grp/GRPGRPXMAS.20260519
  export GRPGRPXMASO

# NEW GRPGRPXMAS file
GRPGRPXMASN=/usr/lnk/grp/GRPGRPXMAS
 export GRPGRPXMASN

# OLD / NEW GRPGRPXMAS Differences file
GRPGRPXMASDIF=/usr/lnk/tmp/GRPGRPXMAS-DIFF-${DATETM}
  export GRPGRPXMASDIF


echo Compare GRPGRPXMAS FILE
date
echo ""
echo "   GRPGRPXMASO=${GRPGRPXMASO}"
echo "   GRPGRPXMASN=${GRPGRPXMASN}"
echo "   GRPGRPXMASDIF=${GRPGRPXMASDIF}"

submit_compgrpgrpxmas


exit 0
