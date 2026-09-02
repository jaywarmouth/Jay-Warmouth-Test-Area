#!/bin/sh
#
# Program Name	: drprc12.sh
# Description   : Create "Drug Update" NADAC records to update DRGPRC0MAS file
#		  
# Date		: 05/07/24

# Modifications : mm/dd/yy (XXX) 


# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drprc12.sh -i <alternate PARMFILE>

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit  program
submit_drprc12()
{
        runcobol ${OBJ_DIR}/drprc12 
	RETVAL=$?
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
	FILEFLG=1
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

echo "Drug Update NADAC Pricing for DRGPRC0MAS"
echo "HOSTNAME=$HOSTNAME"
echo "ASSIGNED FILES:"
echo "NADACUPDT=${NADACUPDT}"
echo "DRGPRC0MAS=${DRGPRC0MAS}"
echo "DRGPRCUPDT=${DRGPRCUPDT}"

date

submit_drprc12

date


exit 0
