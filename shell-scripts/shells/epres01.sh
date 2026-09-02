#!/bin/ksh
#
# Program Name  : epres01.sh
# Description   : Load CARDH00MAS For RXHUB.
#		  Command Line Arguments:
#		   -x <cawrk file name>
#		   -o <EPRES01TAP filename>
#		   -p <SPONSPARM filename> - optional, default is /usr/lnk/log/EPRES01SPONSPARM.txt
#		   -f Full-file flag
#		   -i Initial file flag
#                  -t Test Mode
# Author        : James Masluk
# Date          : 01/16/2009
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FULL_FILE=0
INITIAL_FILE=0
TEST_MODE=0
CAWRK_FLAG=0
EPRES_FILE=0
EPRES_DIR="/usr/lnk/e-pres/batch"
PARMFILE_FLG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: epres01.sh [-f] [-i] [-t] [-x <cawrk file name>]
	-f: Full file option		(optional)
	-i: Initial file option		(optional)
	-x <cawrk file name>		(required)
	-o <EPRES01TAP file name>	(optional)
	-p <SPONSPARM filename>		(Optional)

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


# Submit epres01 program
submit_epres01()
{
        echo ${DATE}
	echo "CAWRK00MAS=$CAWRK00MAS"
        echo "EPRES01TAP=$EPRES01TAP"
	echo "SPONSPARM=$SPONSPARM"
        runcobol ${OBJ_DIR}/epres01 -s ${FULL_FILE}${INITIAL_FILE}${TEST_MODE} 
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
    -f) FULL_FILE=1
	;;
    -i) INITIAL_FILE=1
        ;;
    -t) TEST_MODE=1
        ;;
    -x) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	CAWRK00MAS=$1;export CAWRK00MAS
	CAWRK_FLAG=1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	EPRES01TAP=$1;export EPRES01TAP
	EPRES_FILE=1
	;;
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SPONSPARM=$1; export SPONSPARM
	PARMFILE_FLG=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env


if [ ${EPRES_FILE} = 0 ]
then
	EPRES01TAP=${EPRES_DIR}/EPRES01TAP
fi

if [ ${PARMFILE_FLG} = 0 ]
then
	SPONSPARM=/usr/lnk/log/EPRES01SPONSPARM.txt
	export SPONSPARM
fi


if [ ${FULL_FILE} = 0 ]
then
	if [ ${CAWRK_FLAG} = 0 ]
	then
		echo "-*> No CAWRK00MAS file name assigned."
		usage	
	fi

	if test -s ${CAWRK00MAS}
	then
		echo "Load CARDH00MAS For RXHUB"
		date
		submit_epres01
		date
	else
		echo "-*> The CAWRK file, ${CAWRK00MAS}, does not exist, aborting script..."
		exit 1
	fi
else
	echo "Load CARDH00MAS For RXHUB"
        date
        submit_epres01
        date
fi

exit $RETVAL
