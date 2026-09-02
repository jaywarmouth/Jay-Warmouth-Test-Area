#!/bin/sh
#
# Program Name	: drprc15.sh
# Description   : Update "DRGPRC0MAS" FILE WITH ADD/UPDATE RECORDS FROM DRGPRCUPDT FILE
#		  
# Date		: 05/14/24

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

usage: drprc15.sh -i <alternate PARMFILE>

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
submit_drprc15()
{
        runcobol ${OBJ_DIR}/drprc15 
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

  export CHGFILEFLAG=N


  FG4AUD=$FG4AUD
  export FG4AUD

echo "Drug Update Pricing for DRGPRC0MAS"
echo "HOSTNAME=$HOSTNAME"
echo "ASSIGNED FILES:"
echo "DRGPRC0MAS=${DRGPRC0MAS}"
echo "DRGPRCUPDT=${DRGPRCUPDT}"
echo "FG4AUD=${FG4AUD}"

date

submit_drprc15

date


exit 0
