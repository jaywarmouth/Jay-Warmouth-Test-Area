#!/bin/ksh
#
# Program Name  : dea.sh 
# Description   : UPDATE DEA TAPE FILE TO DEA MASTER FILE
#                 Command Line Arguments:
#                 -i <filename> - input file name
#		  -f <filename> - path and filename where file is being copied from
# Author        : Linda Jefferis
# Date          : 07/30/2004
# Modifications : 10/20/2005 - Changes for linux  (LSJ)
#		: 12/03/2005 - Changes fro new system names  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
INPUT_FILE="null"
SCP_FILE="null"
STAT_FILE="/tmp/cpdea_flag"
RCP_SYS="husk"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dea001.sh [-i <filename>]

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


# Submit dea001 program
submit_dea001()
{
	if test -a ${STAT_FILE}
	then
           runcobol ${OBJ_DIR}/dea001
	else
	   echo ""
	   echo "-*> Possible problem with scp of DEA Input File"
   	echo "-*> dea001 will not run..."
	   exit 1
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
      -i) shift
          if [ $# -le 0 ]
          then
             usage
          fi
          INPUT_FILE=$1
          ;;
      -f) shift
	  if [ $# -le 0 ]
          then
             usage
          fi
          SCP_FILE=$1
          ;;
   esac
   shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INPUT_FILE} = "null" ]
then
   usage
else
   DEA000TAP=${INPUT_FILE}
   export DEA000TAP 
fi
if [ ${SCP_FILE} = "null" ]
then
   usage
fi
   
scp ${SCP_SYS}:${RCP_FILE} ${INPUT_FILE}
if test $? -ne 0
then
   echo ""
   echo "-*> The copy of ${LOAD_PATH}/${DEA_FILE} was unsuccessful..."
   date
   exit 1
else
   touch ${STAT_FILE}
fi


echo "DEA FILE UPDATE"
echo "EXPORT FILES:"
echo "   DEA000TAP=${DEA000TAP}"
echo "   DEA000MAS=${DEA000MAS}"
date
submit_dea001  
date

exit 0
