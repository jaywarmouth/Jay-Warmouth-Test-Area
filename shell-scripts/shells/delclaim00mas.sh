#!/bin/sh
#
# Program Name  : compclaim00mas.sh
# Author        : dick lombardo
# Date          : 09/02/2014
# modifications	: 7/18/2018 - TT3200-212
#
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
OBJ_DIR="/usr/lnk/obj"
INFILE="NULL"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: delclaim00mas.sh [-i <filename>]

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

# Submit claim16 program
submit_delclaim00mas()
{
   runcobol ${OBJ_DIR}/DELCLAIM00MAS
}

#
# Main routine
#
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE=$1
        ;;
  esac
  shift
done

parse_env

script_pid="$$"
CLAIMCOPY=/usr/lnk/tmp/CLAIM00MAS.$script_pid
export CLAIMCOPY

if [ ${INFILE} = "NULL" ] 
then
   usage
else
  PARMFILE=${INFILE}
  export PARMFILE
fi

echo "EXPORT PATHS:"

echo "   PARMFILE =$PARMFILE "
echo "   CLAIM00MAS  =$CLAIM00MAS "
echo "   CLAIMCOPY   =$CLAIMCOPY  "
submit_delclaim00mas
date

exit 0
