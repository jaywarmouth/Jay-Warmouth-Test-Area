#!/bin/sh
#
# Program Name  : OneUpdRevermas.sh
# Author        : K koaslai
# Date          : 01/23/2026
# modifications	: 
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

usage: OneUpdRevermas.sh [-i <filename>]

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

# Submit  program
submit_cobolcall()
{
   runcobol ${OBJ_DIR}/INITREVERMAS -s 1
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

if [ ${INFILE} = "NULL" ] 
then
   usage
else
  PARMFILE=${INFILE}
  export PARMFILE
fi

echo "EXPORT PATHS:"

echo "   PARMFILE =$PARMFILE "
echo "    REVER00MAS =$REVER00MAS"
submit_cobolcall
date

exit 0
