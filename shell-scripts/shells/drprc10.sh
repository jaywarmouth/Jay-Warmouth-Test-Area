#!/bin/sh
#
# Program Name	: drprc10.sh
# Description   : Create "DRGPRC0MAS" File
#		  
# Date		: 04/18/2024

# Modifications : mm/dd/yy (XXX) 


# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

OBJ_DIR=/usr/lnk/obj
RETVAL=0
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drprc11.sh 

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
submit_drprc10()
{
        runcobol ${OBJ_DIR}/drprc10
	RETVAL=$?
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
#while [ $# -gt 0 ]
#do
#  case "$1"
#  in
#    -i) shift
#        if [ $# -le 0 ]
#        then
#          usage
#        fi
#	FILEFLG=1
#        FILE=$1
#        ;;
#  esac
#  shift
#done

# Parse environment variables
parse_env

  ODF0000MAS=${DRUG000MAS}
  export ODF0000MAS


echo "Drug Update Pricing for DRGPRC0MAS"
echo "HOSTNAME=$HOSTNAME"
echo "ASSIGNED FILES:"
echo "ODF0000MAS=${ODF0000MAS}"
echo "DRGPRC0MAS=${DRGPRC0MAS}"

date

submit_drprc10

date

exit $RETVAL
